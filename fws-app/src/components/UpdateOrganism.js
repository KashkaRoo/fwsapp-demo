import React from 'react';
import Button from "@material-ui/core/Button";
import LightBulb from '@material-ui/icons/EmojiObjects';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import TextField from '@material-ui/core/TextField';
import Autocomplete from '@material-ui/lab/Autocomplete';
import { JsonToTable } from "react-json-to-table";
import Alert from '@material-ui/lab/Alert';
import IconButton from '@material-ui/core/IconButton';
import Collapse from '@material-ui/core/Collapse';
import CloseIcon from '@material-ui/icons/Close';

export default class UpdateOrganism extends React.Component {
    state = {
        selectedOrganism: {},
        editedOrganism: {},
        relatedHerp: [],
        relatedXy: [],
        relatedCrim: [],
        organismFieldList: [],
        organisms: [],
        mainDialogOpen: false,
        confirmOpen: false,
        unsavedOpen: false,
        alert: false,
        error: "",
    };

    handleOpenMainDialog = () => {
        this.setState({
            mainDialogOpen: true,
        })
    }

    handleUnsavedClose = () => {this.setState({ unsavedOpen: false})}
    handleUnsavedOpen = () => {
        if (!this.isEquivalent(this.state.selectedOrganism, this.state.editedOrganism)){
            this.setState({
                unsavedOpen: true,
            })
        }
        else{
            this.handleCloseMainDialog(true)
        }
    }

    handleDiscard = () => {
		this.handleUnsavedClose()
		let conf = true
		this.handleCloseMainDialog(conf)
	}

    handleCloseMainDialog = (conf) => {
        if (this.isEquivalent(this.state.selectedOrganism, this.state.editedOrganism)){
            this.setState({
                mainDialogOpen: false,
                selectedOrganism: {},
                editedOrganism: {}
            });   
        }
        if (conf){ //if user has elected to discard
            this.setState({
                mainDialogOpen: false,
                selectedOrganism: {},
                editedOrganism: {},
                alert: false
            }); 
        }
    }

    handleSelectedOrganism = (v) => {
        this.setState({
            selectedOrganism: {...v},
            editedOrganism: {...v}
        })
    }

    handleEditOrganism = (e, fieldName) => {
        if (fieldName) {
                this.setState({
                    editedOrganism: {
                        ...this.state.editedOrganism,
                        [fieldName]: e.target.value
                    }
                });
		}
    }

    async getOrganismList (e) {
        var URL = this.props.APIURL + "organism/auto/" + e.target.value;
        if (e.target.value) {
            await fetch(URL)
            .then((res) => res.json())
            .then((json) => {
              if (json.length > 0){
                var keys = Object.getOwnPropertyNames(json[0]);
                this.setState({
                    organisms: json,
                    organismFieldList: keys,
                  });
              }
            })
            .catch(error => {
                alert ("Something happened in fetch " + URL + " : " + error)
            }); 
        } 
      };

    async findRelatedSpecimen (organismID) {
        var URL =
		this.props.APIURL +
		"organism" +
        "/related/" + organismID;

        await fetch(URL)
        .then(res => res.json())
        .then(json => {
            this.setState({
                relatedHerp: json[0],
                relatedXy: json[1],
                relatedCrim: json[2]
            })
        })
    }

    //when user his the first 'save'
    handleConfirmOpen = () => {
        //get all related specimen & open confirmation dialog
        if (!this.isEquivalent(this.state.selectedOrganism, this.state.editedOrganism)){
            this.findRelatedSpecimen(this.state.editedOrganism["Organism_ID"]);
            this.setState({
                confirmOpen: true
            });
        }
        else{
            this.handleCloseMainDialog(true)
        }
        
    }

    //when user hits 'Continue Editing'
    handleConfirmClose = () => {this.setState({ confirmOpen: false})}

    handleUpdateOrganism = () => {
		const { editedOrganism } = this.state;
		var organismID = editedOrganism["Organism_ID"];
            var putURL =
            this.props.APIURL +
            "organism" +
            "/update/" + organismID;

            fetch(putURL, {
                method: 'PUT',
                body: JSON.stringify(editedOrganism),
                headers: {
                    "Content-type": "application/json"
                }
            })
            .then(response => response.json())
            .then((json) => {
        
                if (json.code === "EREQUEST"){
                this.setState({
                    error: json.originalError.info.message,
                    alert: true
                    })
                }
                else {
                this.handleConfirmClose();
                this.setState({
                    selectedOrganism: editedOrganism,
                    alert: true,
                    error: "",
                    })
                }
            })
            .catch(error => {
                alert ("Something happened in fetch " + putURL + " : " + error)
            }); 
        this.dialogContent.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
            });
    }

    isEquivalent = (a, b) => {
		// Create arrays of property names
		var aProps = Object.getOwnPropertyNames(a);
		var bProps = Object.getOwnPropertyNames(b);
	
		// If number of properties is different,
		// objects are not equivalent
		if (aProps.length !== bProps.length) {
			return false;
		}
	
		for (var i = 0; i < aProps.length; i++) {
			var propName = aProps[i];
			// If values of same property are not equal,
			// objects are not equivalent
			if (a[propName] !== b[propName]) {
				return false;
			}
		}
		// If we made it this far, objects
		// are considered equivalent
		return true;
	}

    render() {
        var alertmessage, severity;
        if (this.state.error) {
          alertmessage = this.state.error
          severity = "error"
        }
        else {
          alertmessage = "Success!"
          severity = "success"
        }

        return (<div>
                <Button
                    color="primary"
                    disableElevation
                    variant="outlined"
                    endIcon={<LightBulb />}
                    style={{marginBottom: "10px"}}
                    onClick={this.handleOpenMainDialog}
                    >
                    Update Scientific Name
                </Button>
                <Dialog 
                    fullWidth
                    maxWidth="md"
                    open={this.state.mainDialogOpen} //determines if dialog is open
                    aria-labelledby="form-dialog-title" >
                    <DialogTitle id="form-dialog-title">Update Scientific Name </DialogTitle>
                    <DialogContent>
                    <div ref={node => {
                        this.dialogContent = node;
                        }}>
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

                        {Object.keys(this.state.selectedOrganism).map( (fieldName) => {
                            if(fieldName==="CREATED_BY" || fieldName==="CREATED_TS" || fieldName==="MODIFIED_BY" || fieldName==="MODIFIED_TS" || fieldName==="Organism_ID"){
                                return""
                            }else{
                                return<TextField
                                        key={fieldName}
                                        disabled={fieldName === "Organism_ID" ? true : false}
                                        id={fieldName}
                                        label={fieldName}
                                        value={this.state.editedOrganism[fieldName] 
                                        || ""}
                                        fullWidth
                                        variant="outlined"
                                        style={{paddingBottom: "25px"}}
                                        size="small"
                                        InputLabelProps={{ shrink: true }}
                                        onChange={e => this.handleEditOrganism(e, fieldName)}
                                          >
                                </TextField>
                                }      
                            })
                        }
                    </DialogContent>
                    </div>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={this.handleUnsavedOpen}
                            color="primary">
                            Close
                        </Button>
                        <Button 
                            onClick={this.handleConfirmOpen}
                            color="primary">
                            Save
                        </Button>
                    </DialogActions>
                </Dialog>


                <Dialog
                    open={this.state.confirmOpen}
                    aria-labelledby="alert-dialog-title"
                    aria-describedby="alert-dialog-description"
                >
                <DialogTitle id="alert-dialog-title">{"Confirm your Changes"}</DialogTitle>
                <DialogContent>
                    Changes in progess: 
                    {Object.keys(this.state.selectedOrganism).map( (fieldName) =>{
                        if (this.state.selectedOrganism[fieldName] !== this.state.editedOrganism[fieldName]){
                            return<div>
                                <li>From <b>{fieldName}</b>: {this.state.selectedOrganism[fieldName] ? this.state.selectedOrganism[fieldName] : "[empty]"} ----{">"} <b>{fieldName}</b>: {this.state.editedOrganism[fieldName]}</li> 
                            </div>
                        }
                        return""
                    })}

                    Your changes will affect the following specimen:
                    
                    {<JsonToTable json={this.state.relatedHerp} />}
                    <br />
                    {<JsonToTable json={this.state.relatedXy} />}
                    <br />
                    {<JsonToTable json={this.state.relatedCrim} />}

 
                </DialogContent>
                <DialogActions>
                    <Button onClick={this.handleConfirmClose} color="primary" autoFocus>
                        Continue Editing
                    </Button>
                    <Button onClick={this.handleUpdateOrganism} color="primary">
                        Confirm Save
                    </Button>
                </DialogActions>
            </Dialog>

		  <Dialog
			open={this.state.unsavedOpen}
			aria-labelledby="alert-dialog-title"
			aria-describedby="alert-dialog-description"
		>
        <DialogTitle id="alert-dialog-title">{"Navigating away from Unsaved Changes!"}</DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
            You are navigating away without saving these changes!
			{Object.keys(this.state.editedOrganism).map( (fieldName) =>{
				if (this.state.selectedOrganism[fieldName] !== this.state.editedOrganism[fieldName]){
					return<div>
						<li>From <b>{fieldName}</b>: {this.state.selectedOrganism[fieldName]} ----{">"} <b>{fieldName}</b>: {this.state.editedOrganism[fieldName]}</li> 
					</div>
                }
                return""
			})}
			
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={this.handleDiscard} color="primary" autoFocus>
            Discard Changes
          </Button>
          <Button onClick={this.handleUnsavedClose} color="primary">
            Continue Editing
          </Button>
        </DialogActions>
      	</Dialog> 

            </div>
        );
    }
}

