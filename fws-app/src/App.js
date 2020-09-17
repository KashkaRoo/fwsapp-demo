import React, { Component } from 'react';
import './App.css';
import Navbar from './components/NavBar'
import Search from './components/Search'
import UpdateOrganism from './components/UpdateOrganism'
import TaxSyn from './components/TaxSyn';
import Results from './components/Results';
import Add from './components/Add';
import BulkAdd from './components/BulkAdd';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { 
      loading: false,
      database: "Herpetology",
      organismFieldList: [],
      APIURL: "https://fwsfl-demo.herokuapp.com/",
      data: [],
      fields: [],
      lastWD: "",
      searchTerm: "",
      field: "",
      lastNFWFL: "",
      lastCrim: "",
    };
    
  }

  handleChange = (k, v) => this.setState({ [k]: v });

/*   componentDidMount() {
    //for autocomplete... hopefully.
    this.setState({
      isLoaded: true
    });
    this.getOrganismFieldList();
    } */

  // this puts the database at a higher parent level.
  setAppDB=(DB)=>{this.setState({database: DB, data: []})}

  setAppFields=(f)=>{this.setState({fields: f})}

  getLastWD=(WD_Num)=>{this.setState({lastWD: WD_Num})}
  
  getLastNFWFL_Num=(NFWFL_Num)=>{this.setState({lastNFWFL: NFWFL_Num})}

  getLastCrim=(CRIM_Num)=>{this.setState({lastCrim: CRIM_Num})}

  setOrganismFields=(org)=>{this.setState({organismFieldList: org})}


  handleSearch = (dropdownValue, searchValue) => {
    const { database} = this.state;
    this.handleChange("loading", true);
    var address = this.state.APIURL;
    var fetchURL = " ";

    //determine whether a search term was entered
    //if not, return all records from the database
    if (searchValue === "") {
      fetchURL = address + database;
    } else {
      fetchURL =
        address + database + "/search/" + dropdownValue + "/" + searchValue;
    }

    fetch(fetchURL)
      .then((res) => res.json())
      .then((json) => {
        this.handleChange(
          "data",
          database === "Herpetology" ? json[0] : json.recordsets[0]
        );
        this.handleChange("searchTerm", searchValue);
        this.handleChange("field", dropdownValue);
        this.handleChange("loading", false);
      });

      if (database === "Xylarium"){
        fetch(address + database + "/lastWD")
        .then((res) => res.json())
        .then((json) => {
          if (json.recordsets[0][0] === undefined){
            this.getLastWD("No Previous Specimen - No Xylarium records exist or DB not connected.");
          } else {
            if (this.state.lastWD !== json.recordsets[0][0].WD_Num){
              this.handleChange(
                "lastWD",
                json.recordsets[0][0].WD_Num
              );
            }
          }
        })
        .catch(error => {
          alert ("ERROR - xy", error)
        });
      }
      else if (database === "Herpetology"){
        fetch(address + database + "/lastNFWFL_Num")
        .then((res) => res.json())
        .then((json) => {
          if (json[0][0] === undefined){
            this.getLastNFWFL_Num("No Previous Specimen - No Herpetology records exist or DB not connected.");
          } else {
            if (this.state.lastNFWFL !== json[0][0].NFWFL_Num){
              this.handleChange(
                "lastNFWFL",
                json[0][0].NFWFL_Num
              );
            }
          }
        })
        .catch(error => {
          console.log(error)
          alert ("ERROR - herp", error)
        });
      }
      else if (database === "Criminalistics"){
        fetch(address + database + "/lastCrim")
        .then((res) => res.json())
        .then((json) => {
          if (json.recordsets[0][0] === undefined){
            this.getLastCrim("No Previous Specimen - No Criminalistics records exist or DB not connected.");
          } else {
            if (this.state.lastNFWFL !== json.recordsets[0][0].CRIM_Num){
              this.handleChange(
                "lastCrim",
                json.recordsets[0][0].CRIM_Num
              );
            }
          }
        })
        .catch(error => {
          alert ("ERROR crim- ", error)
        });
      }
  };


  render() {
    const {APIURL, data, fields, database, lastWD, searchTerm, field, organismFieldList, loading, lastNFWFL, lastCrim} = this.state;
      return (
        <div className="App">
          <div className="header">
            <Navbar database={database} />
          </div>

          <div className="buttons" align="right">
            <div className="Add">
              <Add database={database} fields={fields.map((field) => field.COLUMN_NAME)} lastWD={lastWD} lastNFWFL_Num={lastNFWFL} lastCrim={lastCrim} getLastCrim={this.getLastCrim} getLastNFWFL_Num={this.getLastNFWFL_Num} getLastWD={this.getLastWD} APIURL={APIURL} />
            </div>

            <div className="BulkAdd">
              <BulkAdd database={database} APIURL={APIURL}/>
            </div>

            <div className="UpdateSciName">
              <UpdateOrganism database={database} APIURL={APIURL}/>
            </div>

            <div className="TaxonomicSynonyms">
              <TaxSyn database={database} APIURL={APIURL} organismFieldList={organismFieldList}/>
            </div>
          </div>

          <div className="search">
            <Search setAppDB={this.setAppDB} setAppFields={this.setAppFields} getLastWD={this.getLastWD} getLastNFWFL_Num={this.getLastNFWFL_Num} getLastCrim={this.getLastCrim} setOrganismFields={this.setOrganismFields} handleSearch={this.handleSearch} loading={loading} APIURL={APIURL}/>
          </div>

          <div className="results">
            <Results
              data={data}
              fields={fields.map((field) => field.COLUMN_NAME)}
              database={database}
              handleSearch={this.handleSearch}
              APIURL={APIURL}
              field={field}
              searchTerm={searchTerm}
            />
          </div>

        </div>
      )
    }
}

export default App;
