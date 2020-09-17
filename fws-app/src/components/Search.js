import React from "react";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import SearchIcon from "@material-ui/icons/Search";
import "../App.css";
import CircularProgress from "@material-ui/core/CircularProgress";

export default class Search extends React.Component {
  state = {
    searchTerm: "",
    field: "Binomial_Nomenclature",
    database: "Herpetology",
    fields: [],
    databases: [
      {
        value: "Herpetology",
        label: "Herpetology",
      },
      {
        value: "Xylarium",
        label: "Xylarium",
      },
      {
        value: "Criminalistics",
        label: "Criminalistics",
      },
    ],
 };

  constructor() {
    super();
    this.apiCall("herpetology");
  }

  handleChange = (k, v) => this.setState({ [k]: v });

  async apiCall(database) {
    var address = "http://192.168.1.18:9000/"
    await fetch(address + database + "/getFields")
      .then((response) => {
        return response.json();
      })
      .then((data) => {
        if (data.recordsets) {
          this.handleChange("fields", data.recordsets[0]);
          this.props.setAppFields(data.recordsets[0])
        }
        else {
          this.handleChange("fields", data[0]);
          this.props.setAppFields(data[0]);
        }
      })
      .catch(error => {
        alert ("Something happened in fetch " + address + database + "/getFields : " + error)
    });

      await fetch(address + "xylarium/lastWD")
      .then((res) => res.json())
      .then((json) => {

        if(json.recordsets[0][0] !== undefined){
        this.props.getLastWD(json.recordsets[0][0].WD_Num);
        }
        else{
          this.props.getLastWD("No Previous Specimen - Check DB Connection");
        }
      })
      .catch(error => {
        alert ("Something happened in fetch " + address + "xylarium/lastWD: " + error)
    });

    await fetch(address + "herpetology/lastNFWFL_Num")
    .then((res) => res.json())
    .then((json) => {

      if(json[0] !== undefined){
      this.props.getLastNFWFL_Num(json[0][0].NFWFL_Num);
      }
      else{
        this.props.getLastNFWFL_Num("No Previous Herpetology Specimen - Check DB Connection");
      }
    })
    .catch(error => {
      alert ("Something happened in fetch " + address + "herpetology/lastNFWFL_Num: " + error)
  });

  await fetch(address + "criminalistics/lastCrim")
  .then((res) => res.json())
  .then((json) => {

    if(json.recordsets[0][0] !== undefined){
    this.props.getLastCrim(json.recordsets[0][0].CRIM_Num);
    }
    else{
      this.props.getLastCrim("No Previous Criminology Specimen - Check DB Connection");
    }
  })
  .catch(error => {
    alert ("Something happened in fetch " + address + "criminalistics/lastCrim: " + error)
});

    await fetch(address + "organism/getFields")
    .then((res) => res.json())
    .then((data) => {
        this.props.setOrganismFields(data);
    })
    .catch(error => {
      alert ("Something happened in fetch " + address + "organism/getFields : " + error)
  });

  }

  async handleDBChange(e) {
    const { fields } = this.state;
    this.handleChange("searchTerm", "");
    this.handleChange("field", fields[0].COLUMN_NAME);
    this.handleChange("data", []);
    this.handleChange("database", e.target.value);
    this.props.setAppDB(e.target.value);
    await this.apiCall(e.target.value);
  }

  render() {
    const {
      database,
      databases,
      field,
      fields,
      searchTerm,
    } = this.state;

    return (
      <div className="searchInside">
        <TextField
          id="db"
          select
          size="small"
          label="Database"
          value={database}
          onChange={(e) => this.handleDBChange(e)}
          SelectProps={{
            native: true,
          }}
          style={{width: '440px', marginBottom: '15px', marginTop: '10px'}}
          variant="outlined"
        >
          {databases.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </TextField><br />

        <TextField
          id="field"
          select
          size="small"
          label="Field"
          value={field}
          onChange={(e) => this.handleChange("field", e.target.value)}
          SelectProps={{
            native: true,
          }}
          InputLabelProps={{ shrink: true }}
          style={{marginBottom: '15px'}}
          variant="outlined"
        >
          {/* hide fields from the Search Field selection list */}
          {fields &&
            fields.map((option) => {
              if (
                option.COLUMN_NAME === "Location_ID" ||
                option.COLUMN_NAME === "Locality_ID" ||
                option.COLUMN_NAME === "Organism_ID" ||
                option.COLUMN_NAME === "Specimen_ID"
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
          size="small"
          style={{marginBottom: '15px'}}
          value={searchTerm}
          onChange={(e) => this.handleChange("searchTerm", e.target.value)}
          onKeyPress={(e) => {
            if (e.key === "Enter") {
              this.props.handleSearch(field, searchTerm);
            }
          }}
          variant="outlined"
        /><br />
        
        <Button
          onClick={(e) => this.props.handleSearch(field, searchTerm)}
          color="primary"
          variant="outlined"
          endIcon={<SearchIcon />}
          style={{marginBottom: '15px'}}
        >
          Search 
          {this.props.loading && <CircularProgress size={24} />}
        </Button>
        
        
      </div>
    );
  }
}
