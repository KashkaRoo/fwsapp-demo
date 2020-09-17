import React, { Component } from "react";
import { JsonToTable } from "react-json-to-table";
import LibraryAddIcon from "@material-ui/icons/LibraryAdd";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogTitle from "@material-ui/core/DialogTitle";
import CsvParse from "@vtex/react-csv-parse";
import Alert from "@material-ui/lab/Alert";
import IconButton from "@material-ui/core/IconButton";
import Collapse from "@material-ui/core/Collapse";
import CloseIcon from "@material-ui/icons/Close";
import CircularProgress from "@material-ui/core/CircularProgress";

class BulkAdd extends Component {
  state = {
    disableSave: false, //to prevent double click of Save when bulk is loading
    bulkOpen: false,
    alert: false,
    error: "",
    errorObj: {},
    loading: false,
    bulkSpecimen: [],
    csvXyFields: [
      "Binomial_Nomenclature",
      "WD_Num",
      "Collection_Num",
      "Other_Nums",
      "Previous_Collection",
      "Collector",
      "Source_Type",
      "Wild_Cultivated",
      "Specimen_Description",
      "Heartwood_Sapwood",
      "Notes",
      "Color",
      "NFWFL_Analyzed",
      "Catalogued_By",
      "Continent",
      "Country",
      "State",
      "Locality",
      "Lat_Long",
      "Family",
      "Previous_Designation",
      "Common_Name",
      "Sample_Location",
      "Subspecies",
    ],
    csvCrimFields: [
      "Binomial_Nomenclature",
      "CRIM_Num",
      "Collection_Num",
      "Other_Names",
      "Previous_Collection",
      "Collector",
      "Source_Type",
      "Wild_Cultivated",
      "Specimen_Description",
      "Notes",
      "Color",
      "NFWFL_Analyzed",
      "Catalogued_By",
      "Continent",
      "Country",
      "State",
      "Locality",
      "Lat_Long",
      "Family",
      "Previous_Designation",
      "Common_Name",
      "Sample_Location",
      "Subspecies",
    ],
    csvHerpFields: [
      "Binomial_Nomenclature",
      "Class",
      "Subclass",
      "Order",
      "Suborder",
      "Family",
      "Subfamily",
      "Subgenus",
      "Subspecies",
      "Variety",
      "Common_Name",
      "Previous_Designation",
      "Specimen_Sex",
      "Specimen_Age",
      "NFWFL_Num",
      "REP_Num",
      "Deaccessioned_To",
      "Deaccessioned_Reason",
      "Material",
      "Prep_By",
      "Specimen_Owner",
      "Accession_Num",
      "ESA",
      "CITES",
      "Document_Reference",
      "Locality_Desc",
      "Location_Desc",
    ],
  };

  handleChange = (k, v) => this.setState({ [k]: v });

  handleBulkOpen = () => {
    this.setState({
      bulkOpen: true,
    });
  };

  handleBulkClose = () => {
    this.handleChange("bulkOpen", false);
    this.handleChange("bulkSpecimen", []);
    this.closeAlert();
  };

  handleCSVParse = (e) => {
    //careful of this. might need to hand this even outside.
    this.setState({
      bulkSpecimen: e,
    });
  };

  disableAndSave = () => {
    this.handleChange("loading", true);
    this.handleBulkSave();
  };

  handleBulkSave = () => {
    const { bulkSpecimen } = this.state;
    var putURL = this.props.APIURL + this.props.database + "/update";
    fetch(putURL, {
      method: "PUT",
      body: JSON.stringify(bulkSpecimen),
      headers: {
        "Content-type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((json) => {
        if (json.code === "EREQUEST") {
          this.setState({
            error: json.originalError.info.message,
            alert: true,
            loading: false,
          });
        } else {
          this.setState({
            alert: true,
            error: "",
            loading: false,
          });
        }
      })
      .catch(error => {
        alert ("Something happened in fetch " + putURL +  " : " + error)
    });
  };

  isEmpty(obj) {
    for (var key in obj) {
      if (obj[key] !== null) return false;
    }
    return true;
  }

  closeAlert = () => {
    this.setState({
      alert: false,
      error: undefined,
    });
  };
  render() {
    const { error, bulkSpecimen, loading } = this.state;
    const { database } = this.props;
    var alertmessage, severity;
    if (error) {
      alertmessage = error;
      severity = "error";
    } else {
      alertmessage = "Success!";
      severity = "success";
    }

    if (bulkSpecimen.length > 500) {
        var bulkPreview = bulkSpecimen.slice(0,499);
    }
    return (
      <div>
        <Button
          color="primary"
          disableElevation
          variant="outlined"
          endIcon={<LibraryAddIcon />}
          //style={{ float: "center", margin: "25px" }}
          onClick={(e) => this.handleBulkOpen()}
          style={{marginBottom: "10px"}}
        >
          Bulk Add
        </Button>

        <Dialog
          fullWidth={true}
          maxWidth="md"
          open={this.state.bulkOpen} //determines if dialog is open
          aria-labelledby="form-dialog-title"
        >
          <DialogTitle id="form-dialog-title">
            Bulk Upload - {database}{" "}
          </DialogTitle>
          <DialogContent>
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
            Please use this template for {database} specimen:{" "}
            {database === "Herpetology" ? (
              <a href="./Herpetology_Template.csv" download="./Herpetology_Template.csv">
                Herpetology Template
              </a>
            ) : database === "Xylarium" ? (
              <a
                href="./Xylarium_Template.csv"
                download="./Xylarium_Template.csv"
              >
                Xylarium Template
              </a>
              ) : (
                <a
                href="./Criminalistics_Template.csv"
                download="./Criminalistics_Template.csv"
              >
                Criminalistics Template
              </a>
            )}
            <br />
            {database === "Xylarium"
              ? "Latest Specimen: " + this.state.lastWD
              : ""}{" "}
            <br />
            Page may become unresponsive when loading large CSVs. If it does,
            select 'Wait' and give it up to 5 minutes. 
            <br />
            <CsvParse
              keys={
                database === "Herpetology"
                  ? this.state.csvHerpFields
                  : database === "Xylarium" ? this.state.csvXyFields : this.state.csvCrimFields
              }
              onDataUploaded={this.handleCSVParse}
              render={(onChange) => <input type="file" onChange={onChange} />}
            />
            <br />
            <DialogContentText>
              Please review your additions below and click 'Save' to confirm:{" "}
            </DialogContentText>
            {/* This JsonToTable component is causing a fkton of errors in the browser console, but no data errors. */}
            <JsonToTable json={bulkPreview ? bulkPreview : bulkSpecimen} />
          </DialogContent>
          <DialogActions> 
            <Button
              onClick={this.handleBulkClose}
              disabled={loading}
              color="primary"
            >
              Close
            </Button>
            {/*             <Button onClick={this.handleBulkSave} color="primary">
              Save
            </Button> */}
            <Button
              variant="contained"
              color="primary"
              disabled={loading}
              onClick={this.disableAndSave}
            >
              Save
              {loading && <CircularProgress size={24} />}
            </Button>
          </DialogActions>
        </Dialog>
      </div>
    );
  }
}

export default BulkAdd;
