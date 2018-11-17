/*
JavaScript/JQuery code to support saving and editing filters
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

/*
function runSavedReport gets the given query and report type JSON strings for the report id given using two cffunctions.
Then it will send the reports to output.cfc to re-generate the report.
 */
function runSavedReport(id) {
	//get report query and options
	$.get({
		url: "app/builder/report.cfc?method=getreportQuery&id=" + id, 
		async: false,
		success: function(result) {
			$("#query_string").val(result);
		}
	});
	$.get({
		url: "app/builder/report.cfc?method=getreportType&id=" + id, 
		async: false,
		success: function(result) {
			$("#report_type_string").val(result);
		}
	});

	$("#form").submit();
	
}

function saveReport() {
	if ( $("#report_name").val() === "" ) {
		alert("Report name can't be empty!");
		return;
	}
	$.post( "app/builder/report.cfc", { 
		method: "saveReport",
		name: encodeURIComponent($("#report_name").val()), 
		description: encodeURIComponent($("#report_comment").val()),
		query_string: encodeURIComponent($("#query_string").val()),
		report_type_string: encodeURIComponent($("#report_type_string").val())
	}).done(function( data ) {
	    if (data.trim() === "true") {
	    	$("#error_alert").removeClass("alert-danger");
	    	$("#error_alert").addClass("alert-success");
	    	$("#error_alert_text").html("Report was saved successfully!");
	    	$("#error_alert").show();
	    } else {
	    	$("#error_alert").removeClass("alert-success");
	    	$("#error_alert").addClass("alert-danger");
	    	$("#error_alert_text").html("There was an error saving your report.");
	    	$("#error_alert").show();
	    }
	 });
}

function shareReport() {
	$.post( "app/builder/report.cfc", { 
		method: "shareReport",
		id: parseInt($("#share_report_id").val()), 
		shared_with: encodeURIComponent($("#username_opt").val()) 
	}).done(function( data ) {
	    if (data.trim() === "true") {
	    	$("#error_alert").removeClass("alert-danger");
	    	$("#error_alert").addClass("alert-success");
	    	$("#error_alert_text").html("Report was shared successfully!");
	    	$("#error_alert").show();
	    } else {
	    	$("#error_alert").removeClass("alert-success");
	    	$("#error_alert").addClass("alert-danger");
	    	$("#error_alert_text").html("There was an error sharing your report.");
	    	$("#error_alert").show();
	    }
	 });
}