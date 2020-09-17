import React from "react";
import AppBar from "@material-ui/core/AppBar";
import Typography from "@material-ui/core/Typography";
import Toolbar from "@material-ui/core/Toolbar";
import HelpIcon from "@material-ui/icons/Help";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogTitle from "@material-ui/core/DialogTitle";
import ExpansionPanel from "@material-ui/core/ExpansionPanel";
import ExpansionPanelSummary from "@material-ui/core/ExpansionPanelSummary";
import ExpansionPanelDetails from "@material-ui/core/ExpansionPanelDetails";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";

export default class NavBar extends React.Component {
  state = {
    helpOpen: false,
  };

  handleHelpOpen = () => {
    this.setState({ helpOpen: true });
  };
  handleHelpClose = () => {
    this.setState({ helpOpen: false });
  };

  render() {
    return (
      <div>
        <AppBar postiion="static" style={ this.props.database === "Xylarium" ? {backgroundImage: "url(./wood.jpg)"} : {backgroundImage: "url(./snake.jpg)"} }>
          <Toolbar>
            <Typography color="inherit" style={{ flex: 1 }}>
              FWSFDB Application
            </Typography>
            <Button
              color="default"
              disableElevation
              variant="outlined"
              startIcon={<HelpIcon />}
              style={{ float: "right", backgroundColor: "#FFFFFF" }}
              onClick={this.handleHelpOpen}
            >
              Help
            </Button>
          </Toolbar>
        </AppBar>

        <Dialog
          fullWidth
          maxWidth="md"
          open={this.state.helpOpen} //determines if dialog is open
          aria-labelledby="form-dialog-title"
        >
          <DialogTitle id="form-dialog-title">Help</DialogTitle>
          <DialogContent>
            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="search_a_database">
                  <b>Search a database</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the database you would like to search
                    <br></br>
                    <img
                      src="./Help/database.PNG"
                      alt="Database dropdown menu"
                    />
                  </p>
                  <p>
                    2. Select the field to search by
                    <br></br>
                    <img src="./Help/field.PNG" alt="Field dropdown menu" />
                  </p>
                  <p>
                    3. Enter a search term
                    <br></br>
                    <img src="./Help/search_box.PNG" alt="Search text box" />
                  </p>
                  <p>
                    (<b>Note:</b> If no search term entered, the entire database
                    will be returned!)
                  </p>
                  <p>
                    4. Select the <b>SEARCH</b> button or press <b>Enter</b> on
                    your keyboard
                    <br></br>
                    <img src="./Help/search.PNG" alt="Search button" />
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="add_a_specimen">
                  <b>Add a Specimen</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the database you would like to add a specimen to
                    <br></br>
                    <img
                      src="./Help/database.PNG"
                      alt="Database dropdown menu"
                    />
                  </p>
                  <p>
                    2. Select the button labeled <b>NEW</b>
                    <br></br>
                    <img src="./Help/new.PNG" alt="New specimen button" />
                  </p>
                  <p>
                    3. (Optional) Search for or select an existing genus/species
                    <br></br>
                    <img
                      src="./Help/gs_search.PNG"
                      alt="Genus and species search field"
                    />
                  </p>
                  <p>
                    4. Enter specimen data into the form
                    <br></br>
                    <img src="./Help/add_new.PNG" alt="Add new specimen form" />
                  </p>
                  <p>
                    5. Select <b>CONFIRM</b> after reviewing the specimen
                    details
                    <br></br>
                    <img
                      src="./Help/add_new2.PNG"
                      alt="Add new specimen form confirmation window"
                    />
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="bulk_upload">
                  <b>Add Multiple Specimen</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the database you would like to add specimen to
                    <br></br>
                    <img
                      src="./Help/database.PNG"
                      alt="Database dropdown menu"
                    />
                  </p>
                  <p>
                    2. Select the <b>BULK ADD</b> button
                    <br></br>
                    <img src="./Help/bulk_add.PNG" alt="Bulk Add button" />
                  </p>
                  <p>
                    3. Select the <b>Browse...</b> button to open a file
                    explorer
                    <br></br>
                    <img src="./Help/browse.PNG" alt="Browse button" />
                  </p>
                  <p>
                    4. Navigate to, and select the <b>.csv</b> file containing
                    the specimen data
                  </p>
                  <p>
                    5. Select the <b>SAVE</b> button
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="view_specimen">
                  <b>View a Specimen</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. After searching the database, select the record to view
                  </p>
                  <p>
                    2. The specimen's information will be displayed in form view
                    <br></br>
                    <img src="./Help/view_edit.PNG" alt="View/Edit form" />
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="edit_specimen">
                  <b>Edit a Specimen</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. After searching the database, select the record to edit
                  </p>
                  <p>
                    2. The specimen's information will be displayed in form view
                    <br></br>
                    <img src="./Help/view_edit.PNG" alt="View/Edit form" />
                  </p>
                  <p>3. Make necessary changes to the specimen data</p>
                  <p>
                    4. Select the <b>CONFIRM SAVE</b> button to save the changes
                    <br></br>
                    <img
                      src="./Help/view_edit2.PNG"
                      alt="View/Edit form confirmation window"
                    />
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="update_scientific_name">
                  <b>View Taxonomic Synonyms</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>TAXONOMIC SYNONYMS</b> button
                    <br></br>
                    <img
                      src="./Help/tax_syn.PNG"
                      alt="Taxonomic Synonyms button"
                    />
                  </p>
                  <p>
                    2. Select the field to search by
                    <br></br>
                    <img
                      src="./Help/tax_syn4.PNG"
                      alt="Taxonomic Synonym search field"
                    />
                  </p>
                  <p>
                    3. Enter a search term
                    <br></br>
                    <img src="./Help/search_box.PNG" alt="Search text box" />
                  </p>
                  <p>
                    4. Select the <b>SEARCH</b> button
                    <br></br>
                    <img src="./Help/search.PNG" alt="Search button" />
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="filter_search_results">
                  <b>Filter Search Results</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>Filter Table</b> button
                    <br></br>
                    <img src="./Help/filter.PNG" alt="Filter icon" />
                  </p>
                  <p>
                    2. Select a field to filter by to display a list of options
                    <br></br>
                    <img
                      src="./Help/filter_results.PNG"
                      alt="Filter table options pane"
                    />
                  </p>
                  <p>3. Select an option from the dropdown list</p>
                  <p>
                    4. Click outside the <b>Filter Table</b> window to return to
                    filtered results
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="select_columns">
                  <b>Select Fields to Display</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>View Columns</b> button
                    <br></br>
                    <img src="./Help/columns.PNG" alt="View Columns icon" />
                  </p>
                  <p>
                    2. Select the checkboxes for the fields to display in the
                    table
                    <br></br>
                    <img
                      src="./Help/show_columns.PNG"
                      alt="List of selectable columns"
                    />
                  </p>
                  <p>3. Select an option from the dropdown list</p>
                  <p>
                    4. Click outside the <b>View Columns</b> window to return to
                    results
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="print">
                  <b>Print Search Results</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>Print</b> button
                    <br></br>
                    <img src="./Help/print.PNG" alt="Print icon" />
                  </p>
                  <p>
                    2. Follow your system's dialogs to select preferred print
                    settings
                  </p>
                  <p>
                    3. Select <b>Print</b> within your system's print dialog
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="download_csv">
                  <b>Download Search Results (.csv)</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>Download CSV</b> button to open a file
                    explorer
                    <br></br>
                    <img src="./Help/download.PNG" alt="Download icon" />
                  </p>
                  <p>
                    2. Within the file explorer, select the save location and
                    name
                  </p>
                  <p>
                    3. Select <b>Save</b> to save the file
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>

            <ExpansionPanel>
              <ExpansionPanelSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
              >
                <Typography className="sub_search">
                  <b>Search Within Results</b>
                </Typography>
              </ExpansionPanelSummary>
              <ExpansionPanelDetails>
                <Typography>
                  <p>
                    1. Select the <b>Search</b> button
                    <br></br>
                    <img src="./Help/sub_search1.PNG" alt="Search icon" />
                  </p>
                  <p>
                    2. Enter the search term(s) into the search field that
                    appears
                    <br></br>
                    <img src="./Help/sub_search2.PNG" alt="Search text field" />
                  </p>
                  <p>
                    3. The results in the table will be automatically updated
                  </p>
                </Typography>
              </ExpansionPanelDetails>
            </ExpansionPanel>
          </DialogContent>
          <DialogActions>
            <Button onClick={this.handleHelpClose} color="primary">
              Close
            </Button>
          </DialogActions>
        </Dialog>
      </div>
    );
  }
}
