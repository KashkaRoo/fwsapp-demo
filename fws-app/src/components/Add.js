import React, { Component } from "react";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import AddCircleIcon from "@material-ui/icons/AddCircle";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogTitle from "@material-ui/core/DialogTitle";
import Autocomplete from "@material-ui/lab/Autocomplete";
import Alert from "@material-ui/lab/Alert";
import IconButton from "@material-ui/core/IconButton";
import Collapse from "@material-ui/core/Collapse";
import CloseIcon from "@material-ui/icons/Close";
import {DropzoneArea} from 'material-ui-dropzone'

class Add extends Component {
  state = {
    alert: false,
    error: "",
    newSpecimen: {},
    selectedOrganism: {},
    open: false,
    unsavedOpen: false,
    organisms: [],
    organismFieldList: [],
    confirmDialogOpen: false,
    files: [],
  };

  //when user clicks Add+ Button - opens main dialog
  handleClickOpen = () => {
    this.setState({ open: true });
  };

  //closes main dialog - checks if trying to leave with unsaved changes
  handleClose = () => {
    if (this.isEmpty(this.state.newSpecimen)) {
      this.handleDiscard(); //clears varialbes just 'cause
    } else {
      this.setState({
        unsavedOpen: true, //opens Unsaved Changes Dialog
      });
    }
  };

  //closes the unsaved changes dialog
  handleUnsavedClose = () => {
    this.setState({ unsavedOpen: false });
  };

  handleDiscard = () => {
    this.setState({
      newSpecimen: {},
      selectedOrganism: {},
      unsavedOpen: false,
      open: false,
    });
    this.closeAlert(); //closes & clears the success/fail alert at top of dialog
  };

  closeAlert = () => {
    this.setState({
      alert: false,
      error: undefined,
    });
  };

  //opens dialog for user to confirm changes - called from main dialog 'save' button
  handleConfirmOpen = () => {
    this.setState({ confirmDialogOpen: true });
  };

  //closes confirm dialog - called from continue button on confirm dialog
  handleConfirmClose = () => {
    this.setState({ confirmDialogOpen: false });
  };

  //takes from TextFields and puts in newSpecimen object onBlur
  handleInput = (e, fieldName) => {
    if (fieldName) {
      if (e.target.value === "") {
        this.setState({
          newSpecimen: {
            ...this.state.newSpecimen,
            [fieldName]: null,
          },
        });
      } else {
        this.setState({
          newSpecimen: {
            ...this.state.newSpecimen,
            [fieldName]: e.target.value,
          },
        });
      }
    }
  };

  //after confirmation save
  handleAddNew = () => {
    //get called when save is clicked in dialog
    var putURL = this.props.APIURL + this.props.database + "/update";
    fetch(putURL, {
      method: "PUT",
      body: JSON.stringify(this.state.newSpecimen),
      headers: {
        "Content-type": "application/json",
      },
    })
    .then((response) => response.json())
      .then((json) => {
        console.log(json)
        
        if (json.code === "EREQUEST") {
          this.setState({
            error: json.originalError.info.message,
            alert: true,
          });
        } else {
          if (this.state.files){
            this.handleFileUpload(json[2][0].Specimen_ID)
          }
          this.props.getLastWD(this.state.newSpecimen.WD_Num);
          this.setState({
            alert: true,
            error: "",
            newSpecimen: {},
            files: [],
          });
        }
      })
      .catch(error => {
        alert ("Something happened in fetch " + putURL +  " : " + error)
    });
    this.handleConfirmClose();
    this.dialogContent.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  };

  /* Quality of Life Helper Functions */
  isEmpty(obj) {
    for (var key in obj) {
      if (obj[key] !== null) return false;
    }
    return true;
  }

  isOrganism = (fieldName) => {
    if (
      fieldName === "Class" ||
      fieldName === "Subclass" ||
      fieldName === "Order" ||
      fieldName === "Suborder" ||
      fieldName === "Family" ||
      fieldName === "Subfamily" ||
      fieldName === "Subgenus" ||
      fieldName === "Subspecies" ||
      fieldName === "Variety" ||
      fieldName === "Common_Name" ||
      fieldName === "Binomial_Nomenclature" ||
      fieldName === "Previous_Designation"
    ) {
      return true;
    }
    return false;
  };

  /* ORGANISM FUNCTIONS */

  async getOrganismList(e) {
    var URL = this.props.APIURL + "organism/auto/" + e.target.value;
    if (e.target.value) {
      await fetch(URL)
        .then((res) => res.json())
        .then((json) => {
          var keys = Object.getOwnPropertyNames(json[0]);
          this.setState({
            organisms: json,
            organismFieldList: keys,
          });
        })
        .catch(error => {
          alert ("Something happened in fetch " + URL +  " : " + error)
      });
    }
  }

  handleSelectedOrganism = (v) => {
    this.setState({
      selectedOrganism: {
        ...v,
      },
      newSpecimen: {
        ...this.state.newSpecimen,
        ...v,
      },
    });
  };

  handleFiles(files){
		this.setState({
		  files: files
		});
  };
  
  handleFileUpload = async (ID) => {
		const files = this.state.files
		const formData = new FormData()
		var PUTURL = this.props.APIURL + "upload/" + this.props.database + "/" + ID
		console.log(PUTURL)
		let i;
		for (i = 0; i < files.length; i++) {
			formData.append('attachment', files[i])
		}
		//fetch(this.props.APIRUL + '/upload/' + PK, {
		await fetch(PUTURL, {
		  method: 'POST',
		  body: formData
		})
		.then(response => response.json())
		.then(data => {
		  console.log("handleFileUpload POST response: ", data)
		})
		.catch(error => {
		  console.error(error)
		})
		
	}

  render() {
    const { database, fields, lastWD, lastNFWFL_Num, lastCrim } = this.props;
    const { error, selectedOrganism } = this.state;
    var alertmessage, severity;
    if (error) {
      alertmessage = error;
      severity = "error";
    } else {
      alertmessage = "Success!";
      severity = "success";
    }

    return (
      <div>
        <Button
          onClick={() => this.handleClickOpen()}
          color="primary"
          disableElevation
          variant="outlined"
          endIcon={<AddCircleIcon />}
          style={{marginBottom: "10px"}}
        >
          Add New
        </Button>

        {/* ------- DIALOG -------- */}
        <Dialog
          fullWidth={true}
          maxWidth="md"
          open={this.state.open} //determines if dialog is open
          //onClose={this.handleClose} // the function that closes it
          aria-labelledby="form-dialog-title"
        >
          <DialogTitle id="form-dialog-title">
            Add New Specimen - {database}{" "}
          </DialogTitle>
          <DialogContent>
            <div
              ref={(node) => {
                this.dialogContent = node;
              }}
            >
              <br />
              <br />
              <DialogContent>
                {/* Alert for to display received errors. */}
                <Collapse in={this.state.alert}>
                  <Alert
                    severity={severity}
                    action={
                      <IconButton
                        aria-label="close"
                        color="inherit"
                        size="small"
                        onClick={this.closeAlert}
                      >
                        <CloseIcon fontSize="inherit" />
                      </IconButton>
                    }
                  >
                    {alertmessage}
                  </Alert>
                </Collapse>

                <fieldset>
                  <legend>Search:</legend>
                  <Autocomplete
                    disableClearable={true}
                    id="combo-box-demo"
                    options={this.state.organisms}
                    getOptionLabel={(option) => {
                      if (
                        option.Class === null &&
                        option.Order === null &&
                        option.Family === null &&
                        option["Binomial_Nomenclature"] === null &&
                        option.Common_Name === null
                      ) {
                        return "Unknown. Select for details.";
                      } else {
                      }
                      var optionLabel = "";
                      if (option.Class) {
                        optionLabel += option.Class + " ";
                      }
                      if (option.Subclass) {
                        optionLabel += option.Subclass + " ";
                      }
                      if (option.Order) {
                        optionLabel += option.Order + " ";
                      }
                      if (option.Suborder) {
                        optionLabel += option.Suborder + " ";
                      }
                      if (option.Binomial_Nomenclature) {
                        optionLabel += option.Binomial_Nomenclature + " ";
                      }
                      if (option.Family) {
                        optionLabel += option.Family + " ";
                      }
                      if (option.Subspecies) {
                        optionLabel += option.Subspecies + " ";
                      }
                      if (option.Common_Name) {
                        optionLabel += '"' + option.Common_Name + '"';
                      }

                      return optionLabel;
                    }}
                    onChange={(event, value) =>
                      this.handleSelectedOrganism(value)
                    }
                    fullWidth
                    renderInput={(params) => (
                      <TextField
                        {...params}
                        label="Search by Class, Order, Family, Binomial Nomenclature"
                        variant="outlined"
                        fullWidth
                        onChange={(e) => {
                          this.getOrganismList(e);
                        }}
                      />
                    )}
                  />
                </fieldset>

                {fields.map((fieldName) => {
                  if (
                    fieldName === "Specimen_ID" ||
                    fieldName === "CREATED_TS" ||
                    fieldName === "Organism_ID" ||
                    fieldName === "MODIFIED_TS"
                  ) {
                    return <div></div>;
                  }
                  if (this.isOrganism(fieldName)) {
                    return (
                      <TextField
                        key={fieldName}
                        disabled={false}
                        id={fieldName}
                        label={fieldName}
                        defaultValue={selectedOrganism[fieldName]}
                        value={this.state.newSpecimen[fieldName] || ""}
                        fullWidth
                        variant="outlined"
                        style={{ paddingBottom: "25px" }}
                        size="small"
                        InputLabelProps={{ shrink: true }}
                        onChange={(e) => this.handleInput(e, fieldName)}
                      ></TextField>
                    );
                  } else if (fieldName === "NFWFL_Num") {
                    return (
                      <TextField
                      key={fieldName}
                      id={fieldName}
                      label={fieldName}
                      helperText={
                        fieldName === "NFWFL_Num" && database === "Herpetology"
                          ? "Last specimen: " + lastNFWFL_Num
                          : ""
                      }
                      fullWidth
                      variant="outlined"
                      style={{ paddingBottom: "25px" }}
                      size="small"
                      InputLabelProps={{ shrink: true }}
                      //onChange={e => this.handleInput(e, fieldName)}
                      onBlur={(e) => this.handleInput(e, fieldName)}
                    ></TextField>
                    )
                  } else if (fieldName === "CRIM_Num") {
                    return (
                      <TextField
                      key={fieldName}
                      id={fieldName}
                      label={fieldName}
                      helperText={
                        fieldName === "CRIM_Num" && database === "Criminalistics"
                          ? "Last specimen: " + lastCrim
                          : ""
                      }
                      fullWidth
                      variant="outlined"
                      style={{ paddingBottom: "25px" }}
                      size="small"
                      InputLabelProps={{ shrink: true }}
                      //onChange={e => this.handleInput(e, fieldName)}
                      onBlur={(e) => this.handleInput(e, fieldName)}
                    ></TextField>
                    )
                  } else {
                    return (
                      <TextField
                        key={fieldName}
                        id={fieldName}
                        label={fieldName}
                        helperText={
                          fieldName === "WD_Num" && database === "Xylarium"
                            ? "Last specimen: " + lastWD
                            : ""
                        }
                        fullWidth
                        variant="outlined"
                        style={{ paddingBottom: "25px" }}
                        size="small"
                        InputLabelProps={{ shrink: true }}
                        //onChange={e => this.handleInput(e, fieldName)}
                        onBlur={(e) => this.handleInput(e, fieldName)}
                      ></TextField>
                    );
                  }
                })}

                <fieldset>
                  <legend><center>Upload:</center></legend>
                  <DropzoneArea
                    onChange={this.handleFiles.bind(this)}
                  />
				        </fieldset>
              </DialogContent>
            </div>
          </DialogContent>
          <DialogActions>
            <Button onClick={this.handleClose} color="primary">
              Close
            </Button>
            <Button onClick={this.handleConfirmOpen} color="primary">
              Save
            </Button>
          </DialogActions>
        </Dialog>

        {/* CONFIRMATION DIALOG */}

        <Dialog
          open={this.state.confirmDialogOpen}
          aria-labelledby="alert-dialog-title"
          aria-describedby="alert-dialog-description"
        >
          <DialogTitle id="alert-dialog-title">
            Confirm New Specimen
          </DialogTitle>
          <DialogContent>
            <DialogContentText id="alert-dialog-description">
              {Object.keys(this.state.newSpecimen).map((fieldName) => {
                if (
                  fieldName === "MODIFIED_BY" ||
                  fieldName === "MODIFIED_TS" ||
                  fieldName === "CREATED_BY" ||
                  fieldName === "CREATED_TS" ||
                  fieldName === "Organism_ID" ||
                  this.state.newSpecimen[fieldName] === null
                ) {
                  return "";
                } else {
                  return (
                    <div key={fieldName}>
                      <li key={fieldName}>
                        <b>{fieldName}</b>: {this.state.newSpecimen[fieldName]}
                      </li>
                    </div>
                  );
                }
              })}
            </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Button onClick={this.handleConfirmClose} color="primary" autoFocus>
              Resume Editing
            </Button>
            <Button onClick={this.handleAddNew} color="primary">
              Confirm
            </Button>
          </DialogActions>
        </Dialog>

        {/* UNSAVED CHANGES DIALOG */}

        <Dialog
          open={this.state.unsavedOpen}
          aria-labelledby="alert-dialog-title"
          aria-describedby="alert-dialog-description"
        >
          <DialogTitle id="alert-dialog-title">
            {"Navigating away from new specimen input!"}
          </DialogTitle>
          <DialogContent>
            You are navigating away without saving these changes!
            {Object.keys(this.state.newSpecimen).map((fieldName) => {
              if (
                fieldName === "MODIFIED_BY" ||
                fieldName === "MODIFIED_TS" ||
                fieldName === "CREATED_BY" ||
                fieldName === "CREATED_TS" ||
                fieldName === "Organism_ID"
              ) {
                return "";
              } else {
                return (
                  <div key={fieldName}>
                    <li key={fieldName}>
                      <b>{fieldName}</b>: {this.state.newSpecimen[fieldName]}
                    </li>
                  </div>
                );
              }
            })}
          </DialogContent>
          <DialogActions>
            <Button onClick={this.handleDiscard} color="primary" autoFocus>
              Discard Changes
            </Button>
            <Button onClick={this.handleUnsavedClose} color="primary">
              Continue Entry
            </Button>
          </DialogActions>
        </Dialog>
      </div>
    );
  }
}

export default Add;
