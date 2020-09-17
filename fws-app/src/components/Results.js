import React from 'react';
import MUIDataTable from "mui-datatables"
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import Alert from '@material-ui/lab/Alert';
import IconButton from '@material-ui/core/IconButton';
import Collapse from '@material-ui/core/Collapse';
import CloseIcon from '@material-ui/icons/Close';
import DeleteIcon from '@material-ui/icons/Delete';
import {DropzoneArea} from 'material-ui-dropzone'

class Results extends React.Component {
	state = {
		selectedSpecimen: {},
		editedSelectedSpecimen: {},
		open: false,
		confirmOpen: false,
		unsavedOpen: false,
		deleteFileOpen: false,
		delFile: "",
		deleteSpecimenOpen: false,
		tableStatePersist: { //Dynamic collection of props that are needed between table refreshes.
			searchText: '',
			filterList: [],
			columns: [],
		},
		alert: false,
		error: "",
		files: [],
		specimenFiles: [],
	  }

	  // I really loathe how the event handlers for the various user flows through dialogs are organized. It's very difficult to follow & debug. 
	  // If I had more time, I would definitely go back through these. 
	handleUnsavedOpen = () => {
		if (this.isEquivalent(this.state.selectedSpecimen, this.state.editedSelectedSpecimen)){
			this.setState({
				open: false,
				error: "",
				alert: false,
				selectedSpecimen: {},
				editedSelectedSpecimen: {},
			})
			return
		}
		this.setState({
			unsavedOpen: true
		})
	}

	handleUnsavedClose = () => {
		this.setState({
			unsavedOpen: false
		})
	}
	
	handleConfirmOpen = () => {
		this.setState({
			confirmOpen: true,
			alert: false,
			error: ""
		})
	}

	handleConfirmClose = () => {
		this.setState({
			confirmOpen: false
		})
	}

	handleClickOpen = (specimen) => {
		this.getFiles(specimen)
		this.setState({
			open: true
		})
	  };

	handleEditsSave = () => {
		if(!this.isEquivalent(this.state.selectedSpecimen, this.state.editedSelectedSpecimen) || this.state.files){
			this.handleConfirmOpen()
		}
		else{
			this.handleUnsavedOpen()
		}
	};

	handleDiscard = () => {
		this.handleUnsavedClose()
		let conf = true
		this.handleClose(conf)
	}
	
	handleClose = (conf) => {
		if (this.isEquivalent(this.state.selectedSpecimen, this.state.editedSelectedSpecimen)){
			this.setState({
				open: false,
				error: "",
				alert: false,
				selectedSpecimen: {},
				editedSelectedSpecimen: {},
				specimenFiles: [],
			});
			this.closeAlert();
			return
		}
		if (conf) {
			this.handleUnsavedClose()
			this.setState({
				open: false,
				error: "",
				alert: false,
				selectedSpecimen: {},
				editedSelectedSpecimen: {},
				specimenFiles: [],
			});
			this.closeAlert();
			return
		}
		return
	  };

	handleOnChange = (e, fieldName)  => {
		//keep track of input => editedSpec
		if (fieldName) {
			if (e.target.value === ""){ //might not need this anymore since the DB doesn't care if it's "" or null
				this.setState({
					editedSelectedSpecimen: {
						...this.state.editedSelectedSpecimen,
						[fieldName]: null
					}
				});
			}
			else{
				this.setState({
					editedSelectedSpecimen: {
						...this.state.editedSelectedSpecimen,
						[fieldName]: e.target.value
					}
				});
			}
		}
	};

	handleUpdate = async () =>{
		const {editedSelectedSpecimen, selectedSpecimen, files} = this.state;

			var putURL =
			this.props.APIURL +
			this.props.database +
			"/update";
			await fetch(putURL, {
				method: 'PUT',
				body: JSON.stringify(editedSelectedSpecimen),
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
					//check if file is being uploaded
					if (files){
						this.handleFileUpload(selectedSpecimen.Specimen_ID)
					}
					this.handleConfirmClose();
					this.setState({
						alert: true,
						error: "",
						selectedSpecimen: editedSelectedSpecimen,
						files: []
					})
				}
			})
			.then(() => {
				this.getFiles(this.state.selectedSpecimen)
			})
			.then(()=> {
				this.props.handleSearch(this.props.field, this.props.searchTerm);
			})
			.catch(error => {
				alert ("Something happened in fetch " + putURL + " : " + error)
			});
		this.dialogContent.scrollIntoView({ //returns the dialog scroll to top of the page where alert can be seen
			behavior: 'smooth',
			block: 'start'
		});
	} 

	closeAlert = () => {
		this.setState({
		  alert: false,
		  error: "",
		})
	}

	/* ~~~              HELPER FUNCTIONS                ~~~ */


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

	isOrganism = (fieldName) => {
		if (fieldName === "Class" ||
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
			fieldName === "Previous_Designation"){
			return true;
		}
		return false;
	}

	handleChange = (action, tableState) => {
		if(action !== 'propsUpdate') { //Store new tableStatePersist only if not updating props
		  this.setState({
			tableStatePersist: {
			  searchText: tableState.searchText,
			  filterList: tableState.filterList, //An array of filters for all columns
			  columns: tableState.columns //We can pull column-specific options from this array, like display and sortDirection
			},
		  });
		}
	  };

	  getSearchText = () => {
		return this.state.tableStatePersist.searchText;
	  }


		//Return all columns, their props, and any current state-related changes
	getColumns = () => {
		//Define all of the alert table's columns and their default props and options as per the mui-datatables documentation
		// column names passed in from Results fields
		const columnNames = this.props.fields;
		// create array columns (array of objects) in order to customize default display options
		var columns = [];
		for (var i in columnNames) {		// items in columnNames are ints
			//Disable columns that should not be visible to user: Organism_ID, Location_ID, Locality_ID	
			if (columnNames[i] === "Organism_ID" || columnNames[i] === "Location_ID" || columnNames[i] === "Locality_ID") {
				//do nothing
			}
			else { //make fields available to display
				var c = {};
				c["name"] = columnNames[i]; 	// get the name associated with the current index, put it in an object, add it to columns array
				c["options"] = {};
				columns.push(c);
			}
		}

		// iterate over columns array
		// if an entry is not in the preset list, set display to FALSE to start with
		const displayColumns = ["NFWFL_Num", "WD_Num", "CRIM_Num", "Material", "Common_Name", "Sample_Location", "Binomial_Nomenclature"];
		for (var j in columns) {
			if(!displayColumns.includes(columns[j].name)) {
				columns[j].options.display = false;
			}
		}

		//Loop thru columns and assign all column-specific settings that need to persist thru a data refresh
		for(let i = 0; i < columns.length; i++) {     
		//Assign the filter list to persist
		columns[i].options.filterList = this.state.tableStatePersist.filterList[i];
		if(this.state.tableStatePersist.columns[i] !== undefined) {
			//If 'display' has a value in tableStatePersist, assign that, or else leave it alone
			if(this.state.tableStatePersist.columns[i].hasOwnProperty('display'))
			columns[i].options.display = this.state.tableStatePersist.columns[i].display;
			//If 'sortDirection' has a value in tableStatePersist, assign that, or else leave it alone
			if(this.state.tableStatePersist.columns[i].hasOwnProperty('sortDirection')) {
			//The sortDirection prop only permits sortDirection for one column at a time
			if(this.state.tableStatePersist.columns[i].sortDirection !== 'none')
				columns[i].options.sortDirection = this.state.tableStatePersist.columns[i].sortDirection;
			}
		}
		}
	
		return columns;
	}

	closeAlert = () => {
		this.setState({
		  alert: false,
		  error: undefined
		})
	  }

	  handleFiles(files){
		this.setState({
		  files: files
		});
	  }

	  handleFileUpload = async (ID) => {
		const files = this.state.files
		console.log(files)
		const formData = new FormData()
		var PUTURL = this.props.APIURL + "upload/" + this.props.database + "/" + ID
		console.log(PUTURL)
		console.log(files.length)
		let i;
		for (i = 0; i < files.length; i++) {
			formData.append('attachment', files[i])
		}
		console.log(formData)

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

	getFiles = async (specimen) => {
		var ID = specimen.Specimen_ID
		var URL = this.props.APIURL + "getFiles/" + this.props.database + "/" + ID
		await fetch(URL)
		.then(response => response.json())
		.then((response) => {
			console.log("getFiles fetch response: ", response)
			this.setState({
				specimenFiles: response
			})
		})
		.catch(error => {
			alert (error)
		});
	}

	retrieveFile = async (fileName) => {
		var ID = this.selectedSpecimen.Specimen_ID

		window.open(this.props.APIURL + "Docs/" + this.props.database + "/" + ID + "/" + fileName);
	}

	deleteFile = async (fileName) => {
		var ID = this.state.selectedSpecimen.Specimen_ID
		
		var URL = this.props.APIURL + "deleteFile/" + this.props.database + "/" + ID + "/" + fileName
		await fetch(URL)
		.then( res => {
			console.log(res)
			this.getFiles(this.state.selectedSpecimen)
			this.closeFileDelete()
		})
		.catch(error => {
			alert (error)
		});
	}

	openFileDelete = (fileName) => {this.setState({deleteFileOpen: true, delFile: fileName})}
	closeFileDelete = () => {this.setState({deleteFileOpen: false, delFile: ""})}

	deleteSpecimen = async () => {
		const {specimenFiles, selectedSpecimen} = this.state;
		const {database, APIURL} = this.props;
		var fileName;
		//delete files
		for (fileName in specimenFiles) {
			this.deleteFile(fileName);
		}
		//back up specimen?
		//delete specimen
		var URL = APIURL + database + "/delete/" + selectedSpecimen.Specimen_ID;
		await fetch(URL)
		.then( res => {
			console.log(res)
			this.props.handleSearch(this.props.field, this.props.searchTerm);
					this.setState({
						selectedSpecimen: {},
						editedSelectedSpecimen: {},
						files: [],
						open: false,
						alert: false,
					})
		})
		.catch(error => {
			alert (error)
		});
		this.closeSpecimenDelete();
	}

	openSpecimenDelete = () => {this.setState({deleteSpecimenOpen: true})}
	closeSpecimenDelete = () => {this.setState({deleteSpecimenOpen: false})}


	render() {
		const { error, specimenFiles, delFile } = this.state;
		var alertmessage, severity;
		if (error) {
		  alertmessage = error
		  severity = "error"
		}
		else {
		  alertmessage = "Success!"
		  severity = "success"
		}
		
	
    return (
      <div>
        <MUIDataTable
          title={"Results"}
          data={this.props.data}
          columns={this.getColumns()}
          options={{
			selectableRows: 'single',
			disableToolbarSelect: 'true',
	  
			onRowClick: (rowData, rowMeta, rowState) => {	// !!! Bad things happen if you take rowData out of the params. Don't touch it. !!!
			  this.setState({
				selectedSpecimen: this.props.data[rowMeta.dataIndex],		// use row meta data to access json data and grab the object associated with the row
				editedSelectedSpecimen: this.props.data[rowMeta.dataIndex],
			  });
			  this.getFiles(this.props.data[rowMeta.dataIndex]);
			  this.handleClickOpen(this.props.data[rowMeta.dataIndex])
			},
	  
			onRowsDelete: () => {
			  window.alert('Do we want to delete from table for printing? -- Not implemented at this time.');
			  return false;
			},
			
			// adjust onDownload to only download searched/filtered options - currently downloads everything searched for
			// https://github.com/gregnb/mui-datatables/blob/master/examples/on-download/index.js
	  
			  searchText: this.state.tableStatePersist.searchText,
			  onTableChange: (action, tableState) => this.handleChange(action, tableState),
		  }}
        />

		<Dialog 
			fullWidth={true}
			maxWidth="md"
			open={this.state.open} 
			aria-labelledby="form-dialog-title" >
        <DialogTitle id="form-dialog-title" ref={this.titleRef}>View and Edit Specimen Details</DialogTitle>
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
				<legend><center>Attachments:</center></legend>
						{specimenFiles.map( (fileName) => {
							return <div key={fileName}> 
							<Button
							key={fileName}
							onClick={e => this.retrieveFile(fileName) }
							color="primary"
							>
								{fileName}
							</Button>
							<IconButton 
								aria-label="delete" 
								color="secondary"
								onClick={e => this.openFileDelete(fileName) }
							>
								<DeleteIcon />
							</IconButton>
							</div>

						})}


				</fieldset>

				<fieldset>
					<legend><center>Updating these fields will only change this specimen. <br /><small> Use Update Scientific Designation to change many specimen at once.</small></center></legend>
				{Object.keys(this.state.selectedSpecimen).map( (fieldName) => {
					if (fieldName === "Location_ID" || fieldName === "Locality_ID" || fieldName === "Organism_ID"){
						return""
					}

					if (this.isOrganism(fieldName)){
						return <div key={fieldName}>
								<TextField
									key={fieldName}
									id={fieldName}
									label={fieldName}
									defaultValue={this.state.selectedSpecimen[fieldName]}
									fullWidth
									variant="outlined"
									style={{paddingBottom: "25px"}}
									size="small"
									InputLabelProps={{ shrink: true }}
									onBlur={e => this.handleOnChange(e, fieldName)}
								>
								</TextField>						
						</div>;
					}
					return""
				})}
				</fieldset>
				{Object.keys(this.state.selectedSpecimen).map( (fieldName) => {
					if (fieldName === "Location_ID" || fieldName === "Locality_ID" || fieldName === "Organism_ID" || fieldName ==="Specimen_ID"){
						return""
					}
					if (!this.isOrganism(fieldName)){
					return <div key={fieldName}>
								<TextField
									key={fieldName}
									disabled={fieldName === "Specimen_ID" ? true : false}
									id={fieldName}
									label={fieldName}
									defaultValue={this.state.selectedSpecimen[fieldName]}
									fullWidth
									variant="outlined"
									style={{paddingBottom: "25px"}}
									size="small"
									InputLabelProps={{ shrink: true }}
									onBlur={e => this.handleOnChange(e, fieldName)}
								>
								</TextField>
							</div>; 
					}
					return""
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
				<Button onClick={this.openSpecimenDelete} 
					color="secondary"
				>
					Delete Specimen
				</Button>
				<div style={{flex: '1 0 0'}} />
				<Button onClick={this.handleUnsavedOpen} 
					color="primary">
					Close
				</Button>
				<Button onClick={ this.handleEditsSave} color="primary">
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
          
            <b>Changes in progress: </b><br />
			<i>Attachments:</i>
 			{this.state.files.map( (file) => {
				 console.log(file.name)
				return <div key={file.name}> 
				<li>
					{file.name}
				</li>
				</div>
			})}

			{Object.keys(this.state.selectedSpecimen).map( (fieldName) =>{
				if (this.state.selectedSpecimen[fieldName] !== this.state.editedSelectedSpecimen[fieldName]){
					return<div>
						<li>From <b>{fieldName}</b>: {this.state.selectedSpecimen[fieldName]} ----{">"} <b>{fieldName}</b>: {this.state.editedSelectedSpecimen[fieldName]}</li> 
					</div>
				}
				return""
			})}
			<br />
			<hr />
			<small><b>A Note:</b><br/>
			Updates made to the following fields: <br/> <br/>
			Binomial Nomenclature, Class, Subclass, Order, Suborder, Family, Subfamily, <br/> Subgenus, Subspecies, Variety, Common Name, or Previous Designation<br /><br />
			Will <b>only</b> affect/reflect in this specimen. <br />
			To change a scientific designation across multiple specimen, use the <b>Update Scientific Name</b> feature.</small>

        </DialogContent>
        <DialogActions>
          <Button onClick={this.handleConfirmClose} color="primary" autoFocus>
            Continue Editing
          </Button>
          <Button onClick={this.handleUpdate} color="primary">
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
			{Object.keys(this.state.selectedSpecimen).map( (fieldName) =>{
				if (this.state.selectedSpecimen[fieldName] !== this.state.editedSelectedSpecimen[fieldName]){
					return<div>
						<li>From <b>{fieldName}</b>: {this.state.selectedSpecimen[fieldName]} ----{">"} <b>{fieldName}</b>: {this.state.editedSelectedSpecimen[fieldName]}</li> 
					</div>
				}
				return""
			})}
			

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

		<Dialog
			open={this.state.deleteFileOpen}
			aria-labelledby="alert-dialog-title"
			aria-describedby="alert-dialog-description"
		>
        <DialogTitle id="alert-dialog-title">Are you sure?</DialogTitle>
        <DialogContent>
			Are you sure you want to delete <Button
							onClick={e => this.retrieveFile(delFile) }
							color="primary"
							>
								{delFile}
							</Button>
        </DialogContent>
        <DialogActions>
          <Button onClick={this.closeFileDelete} color="primary" autoFocus>
            Cancel
          </Button>
          <Button onClick={e => this.deleteFile(delFile)} color="secondary">
            Delete
          </Button>
        </DialogActions>
      	</Dialog>

		<Dialog
			open={this.state.deleteSpecimenOpen}
			aria-labelledby="alert-dialog-title"
			aria-describedby="alert-dialog-description"
		>
        <DialogTitle id="alert-dialog-title">Are you sure?</DialogTitle>
        <DialogContent>
			Are you sure you want to delete this specimen?
        </DialogContent>
        <DialogActions>
          <Button onClick={this.closeSpecimenDelete} color="primary" autoFocus>
            Cancel
          </Button>
          <Button onClick={e => this.deleteSpecimen()} color="secondary">
            Delete
          </Button>
        </DialogActions>
      	</Dialog>
      </div>
    );
  }
}

export default Results;