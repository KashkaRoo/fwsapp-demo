var express = require("express");
var router = express.Router();
var sql = require("mssql");
var dbConfig = require('../config');

//Function to connect to database and execute query
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
					res.send(sql_res.recordsets);
				}
			});
		}
	});           
}

//Function to connect to database and execute stored procedure
var executePutProc = function(proc, json, res){             
	sql.connect(dbConfig, function (err) {
		if (err) {   
			console.log("Error while connecting database :- " + err);
			res.send(err);
		}
		else {
			// create Request object
			var request = new sql.Request();

			// prepare input parameters
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

// make sure route is working
router.get("/connected", function(req, res, next) {
    res.send("herpRoute is connected");
});

// get full Herpetology_Specimen table
router.get("/", function(req , res){
	var query = "SELECT * FROM [dbo].[VW_Herpetology_Organism_All]";
	console.log(query);
    executeQuery (query, res);
});;

// get full Herpetology_Specimen fieldlist
router.get("/getfields", function(req , res){
	var query = "USE " + dbConfig.database + "; \
		SELECT COLUMN_NAME \
		FROM INFORMATION_SCHEMA.COLUMNS \
		WHERE TABLE_NAME = 'VW_Herpetology_Organism_All' \
		AND TABLE_SCHEMA='dbo'";
	console.log(query);
    executeQuery (query, res);
});

// support where clause
router.get("/search/:fieldID/:searchValue", function(req, res){
	if (req.params.fieldID.toUpperCase() == "ORGANISM_ID") {
		req.params.fieldID = "o.Organism_ID";
	}
	
	if (req.params.fieldID.toUpperCase() == "ORDER") {
		req.params.fieldID = "[Order]";
	}


	var query = "SELECT * FROM [dbo].[VW_Herpetology_Organism_All] \
		WHERE " + req.params.fieldID + " LIKE '%" + req.params.searchValue + "%' \
		ORDER BY NFWFL_Num DESC";

	console.log("query: " + query);
	executeQuery (query, res);
});

// new method
router.put("/update", function(req, res) {
	// req is json object representing entire specimen record	
	//console.log(req);
	var proc = "[dbo].[SP_Herp_Update_or_Add]";
	console.log("proc: " + proc);
	
	removeNulls(req.body);
	
	var json = JSON.stringify(req.body);

	console.log("json: " + json);

	executePutProc(proc, json, res);
});

router.get("/lastNFWFL_Num", function(req, res) {
	//get the highest catalog num
	var query = "SELECT max(Try_Convert(int,NFWFL_Num)) as NFWFL_Num \
	FROM [dbo].[Herpetology_Specimen]";

	//get the most recently entered catalog num 
/* 	var query = "SELECT top (1) NFWFL_Num \
	FROM [dbo].[Herpetology_Specimen] \
	Order by Specimen_ID desc"; */

	console.log(query);
    executeQuery (query, res);
});

router.get("/delete/:specimenID", function(req, res){

	var query = "DELETE FROM [" + dbConfig.database + "].[dbo].[Herpetology_Specimen] \
	WHERE Specimen_ID = " + req.params.specimenID;
	
	console.log(query);
	executeQuery (query, res);
});;

// a simple function to remove null values from object
// passed by reference, so no need for return
// necessary for proc to merge
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