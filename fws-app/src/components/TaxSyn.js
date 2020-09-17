import React from "react";
import Button from "@material-ui/core/Button";
import LightBulb from "@material-ui/icons/EmojiObjects";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogTitle from "@material-ui/core/DialogTitle";
import TextField from "@material-ui/core/TextField";
import SearchIcon from "@material-ui/icons/Search";
import { JsonToTable } from "react-json-to-table";

export default class TaxSyn extends React.Component {
  state = {
    field: "Class",
    dialogOpen: false,
    searchTerm: "",
    organisms: {},
  };

  handleChange = (k, v) => this.setState({ [k]: v });

  handleSearch = () => {
    const { field, searchTerm } = this.state;
    var URL;
    if (searchTerm === "") {
      URL = this.props.APIURL + "organism/history/";
    } else {
      URL =
      this.props.APIURL + "organism/history/" + field + "/" + searchTerm;
    }
    fetch(URL)
      .then((res) => res.json())
      .then((json) => {
        this.setState({
          organisms: json,
        });
      })
      .catch(error => {
        alert ("Something happened in fetch " + URL + " : " + error)
    }); 
  };


  closeAndClear = () => {
    this.setState({
      dialogOpen: false,
      organisms: {},
      searchTerm: "",
      field: "Class",
    });
  };

  render() {
    const { field, searchTerm, organisms } = this.state;
    const {organismFieldList} = this.props;
    return (
      <div>
        <Button
          color="primary"
          disableElevation
          variant="outlined"
          endIcon={<LightBulb />}
          onClick={(e) => this.handleChange("dialogOpen", true)}
          style={{marginBottom: "10px"}}
        >
          Taxonomic Synonyms
        </Button>

        <Dialog
          fullWidth
          maxWidth="lg"
          open={this.state.dialogOpen} //determines if dialog is open
          aria-labelledby="form-dialog-title"
        >
          <DialogTitle id="form-dialog-title">Taxonomic Synonyms</DialogTitle>
          <DialogContent>
            History of 'Update Scientific Name' changes: <br /><br />
            <TextField
              id="field"
              select
              label="Field"
              value={field}
              onChange={(e) => this.handleChange("field", e.target.value)}
              SelectProps={{
                native: true,
              }}
              InputLabelProps={{ shrink: true }}
              variant="outlined"
              size="small"
            >
              {organismFieldList && organismFieldList.map((option) => {
                if (
                  option.COLUMN_NAME === "CREATED_BY" ||
                  option.COLUMN_NAME === "CREATED_TS" ||
                  option.COLUMN_NAME === "MODIFIED_BY" ||
                  option.COLUMN_NAME === "MODIFIED_TS" ||
                  option.COLUMN_NAME === "Organism_ID"
                ) {
                  return "";
                } else {
                  return (
                    <option key={option.COLUMN_NAME} value={option.COLUMN_NAME}>
                      {option.COLUMN_NAME}
                    </option>
                  );
                }
              })}
            </TextField>
            <TextField
              id="searchTerm"
              label="Search"
              value={searchTerm}
              onChange={(e) => this.handleChange("searchTerm", e.target.value)}
              onKeyPress={(e) => {
                if (e.key === "Enter") {
                  this.handleSearch(e);
                }
              }}
              variant="outlined"
              size="small"
            />
            <Button
              onClick={(e) => this.handleSearch(e)}
              color="primary"
              disableElevation
              variant="outlined"
              endIcon={<SearchIcon />}
            >
              Search
            </Button>
            <br />
            <JsonToTable json={organisms} />
          </DialogContent>
          <DialogActions>
            <Button onClick={this.closeAndClear} color="primary">
              Close
            </Button>
          </DialogActions>
        </Dialog>
      </div>
    );
  }
}
