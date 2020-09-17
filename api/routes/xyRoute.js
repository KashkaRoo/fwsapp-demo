var express = require("express");
var router = express.Router();
var sql = require("mssql");
var dbConfig = require('../config');
var fs = require('fs');
var fs = require('fs');
var fileUpload = require('express-fileupload');

router.use(fileUpload());

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
			//console.log(request);

			// query to the database
			request.query(query, function (err, sql_res) {
				if (err) {
					console.log("Error while querying database :- " + err);
					res.send(err);
				}
				else {
					console.log('Rows affected:', res.length);
					res.send(sql_res);
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
    res.send("xyRoute is connected");
});

// get full Xylarium_Specimen table
router.get("/", function(req , res){
	var query = "SELECT * FROM [dbo].[VW_Xylarium_Organism_All]";
	console.log(query);
    executeQuery (query, res);
});;

// get full Xylarium_Specimen fieldlist
router.get("/getFields", function(req, res){
	var query = "SELECT COLUMN_NAME \
	FROM INFORMATION_SCHEMA.COLUMNS \
	WHERE TABLE_NAME = 'VW_Xylarium_Organism_All' \
	AND TABLE_SCHEMA='dbo'";
	console.log(query);
    executeQuery (query, res);
});;

// support where clause
router.get("/search/:fieldID/:searchValue", function(req, res){
	if (req.params.fieldID.toUpperCase() == "ORGANISM_ID") {
		req.params.fieldID = "o.Organism_ID";
	}
	
	if (req.params.fieldID.toUpperCase() == "ORDER") {
		req.params.fieldID = "[Order]";
	}

	var query = "SELECT * FROM [dbo].[VW_Xylarium_Organism_All] \
		WHERE " + req.params.fieldID + " LIKE '%" + req.params.searchValue + "%'";
	
	console.log(query);
	executeQuery (query, res);
});;
 
router.put("/update", function(req, res) {
	// req is json object representing entire specimen record	
	//console.log(req);
	var proc = "[dbo].[SP_Xy_Update_or_Add]";
	console.log("proc: " + proc);
	
	//removeNulls(req.body);
	
	var json = JSON.stringify(req.body);

	//console.log("json: " + json);

	executePutProc(proc, json, res);
});

router.get("/lastWD", function(req, res) {
	//get the latest NFWFL Num
	var query = "SELECT TOP (1) WD_Num \
	FROM [" + dbConfig.database + "].[dbo].[Xylarium_Specimen] \
	order by WD_Num desc";
	console.log(query);
    executeQuery (query, res);
});

router.get("/delete/:specimenID", function(req, res){

	var query = "DELETE FROM [" + dbConfig.database + "].[dbo].[Xylarium_Specimen] \
	WHERE Specimen_ID = " + req.params.specimenID;
	
	console.log(query);
	executeQuery (query, res);
});;


module.exports = router;