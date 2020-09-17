var express = require("express");
var router = express.Router();
var sql = require("mssql");
var dbConfig = require('../config');

var executeQuery = function(query, res){             
	sql.connect(dbConfig, function (err) {
		if (err) {   
			console.log("Error while connecting database :- " + err);
			res.send(err);
		}
		else {
			// create Request object
			var request = new sql.Request();

			// query to the database
			request.query(query, function (err, sql_res) {
				if (err) {
					// need to pass this error back to the frontend somehow
					console.log("Error while querying database :- " + err);
					res.send(err);
				}
				else {
					console.log('Rows affected:', res.length);
					res.send(sql_res.recordsets[0]);
				}
			});
		}
	});           
}

//Function to connect to database and execute stored procedure
var executePutProc = function(proc, orgID, json, res){             
	sql.connect(dbConfig, function (err) {
		if (err) {   
			console.log("Error while connecting database :- " + err);
			res.send(err);
		}
		else {
			// create Request object
			var request = new sql.Request();

			// prepare input parameters
			request.input('l_org_id', orgID);
			request.input('json', json);

			// query to the database
			request.execute(proc, function (err, sql_res) {
				if (err) {
					// need to pass this error back to the frontend somehow
					console.log("Error while querying database :- " + err);
					res.send(err);
				}
				else {
					console.log('Rows affected:', sql_res.rowsAffected);
					res.send(sql_res.recordsets);
				}
			});
		}
	});           
}

//Function to connect to database and execute stored procedure without JSON
var executeGetProc = function(proc, orgID, res){             
	sql.connect(dbConfig, function (err) {
		if (err) {   
			console.log("Error while connecting database :- " + err);
			res.send(err);
		}
		else {
			// create Request object
			var request = new sql.Request();
			// prepare input parameters
			request.input('org_id', orgID);
			// query to the database
			request.execute(proc, function (err, sql_res) {
				if (err) {
					// need to pass this error back to the frontend somehow
					console.log("Error while querying database :- " + err);
					res.send(err);
				}
				else {
					console.log('Rows affected:', sql_res.rowsAffected);
					res.send(sql_res.recordsets);
				}
			});
		}
	});           
}

// get full Organism table
router.get("/auto/:input", function(req , res){
	var query = "SELECT * \
	FROM dbo.Organism \
	WHERE (Class LIKE '%" + req.params.input + "%')	\
	OR (Subclass LIKE '%" + req.params.input + "%')		\
	OR ([Order] LIKE '%" + req.params.input + "%')		\
	OR (Suborder LIKE '%" + req.params.input + "%')	\
	OR (Family LIKE '%" + req.params.input + "%')\
	OR (Subfamily LIKE '%" + req.params.input + "%')\
	OR (Binomial_Nomenclature LIKE '%" + req.params.input + "%')\
	OR (Subgenus LIKE '%" + req.params.input + "%')			\
	OR (Subspecies LIKE '%" + req.params.input + "%')		\
	OR (Variety LIKE '%" + req.params.input + "%')\
	OR (Common_Name LIKE '%" + req.params.input + "%')\
	OR (Previous_Designation LIKE '%" + req.params.input + "%')";
	console.log(query);
    executeQuery (query, res);
});

// get all specimen with organism FK 
router.get("/history/:fieldID/:searchValue", function(req, res){
	if (req.params.fieldID.toUpperCase() == "ORDER") {
		req.params.fieldID = "[Order]";
	}

	if (req.params.fieldID.toUpperCase() == "BINOMIAL_NOMENCLATURE") {
		req.params.fieldID = "Binomial";
		var query = "SELECT * FROM [dbo].[Organism_History] \
	WHERE Previous_Binom LIKE '%" + req.params.searchValue + "%' \
	OR New_Binomial LIKE '%" + req.params.searchValue + "%'";
	}else{
		var query = "SELECT * FROM [dbo].[Organism_History] \
		WHERE Previous_" + req.params.fieldID + " LIKE '%" + req.params.searchValue + "%' \
		OR New_" + req.params.fieldID + " LIKE '%" + req.params.searchValue + "%'";
	}

	console.log("query: " + query);
	executeQuery (query, res);
});

//for when TaxSyn has no search value
router.get("/history", function(req, res){
	var query = "SELECT * FROM [dbo].[Organism_History]";
	
	console.log("query: " + query);
	executeQuery (query, res);
})

// get all specimen with organism FK 
router.get("/related/:organismID", function(req , res){
	var orgID = req.params.organismID;
	var proc = "[dbo].[SP_Related_Organism]";
	console.log(proc);
    executeGetProc (proc, orgID, res);
});

// update scientific name / organism information
router.put("/update/:organismID", function(req, res) {
	var orgID = req.params.organismID;
	removeNulls(req.body);
	var json = JSON.stringify(req.body);
	console.log("json: " + json);

	var proc = "[dbo].[SP_Update_Scientific_Name]";
	console.log("proc: " + proc);

	executePutProc(proc, orgID, json, res);

});

// get full Organism fieldlist
router.get("/getFields", function(req, res){
	var query = "SELECT COLUMN_NAME \
	FROM INFORMATION_SCHEMA.COLUMNS \
	WHERE TABLE_NAME = 'Organism' \
	AND TABLE_SCHEMA='dbo'";
	console.log("query: " + query);
    executeQuery (query, res);
});;

var removeNulls = function(jsonIn) {
	console.log("Removing nulls from json...");

	for(let [key, value] of Object.entries(jsonIn)) {
		console.log(`key: ${key} value: ${value}`);
		if(value === null || value === '') {
			delete jsonIn[key];
		}
	}

	// cleaned up json
	// console.log(jsonIn);
};

module.exports = router;