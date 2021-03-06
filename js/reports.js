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
	$("#report_id").val(id);

	$("#form").submit();
	
}

function runSharedReport(id) {
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


function saveReport(id) {
	//run different code if report id == 0; this means that the report is new and should not be modifying the previous report for whatever reason...
	if ( $("#report_name").val() === "" ) {
		alert("Report name can't be empty!");
		return;
	}
	$.post( "app/builder/report.cfc", { 
		method: "saveReport",
		report_id: id,
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

//function to share a report.
function shareReport() {
	if ($("#username_opt").val() == null) {
		$("#shareWarningText").html("Please select a username.")
		$("#shareWarning").show();
	}
	else {
		$('#shareReportModal').modal('hide')
		$("#shareWarning").hide();
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
}

//function to call CF function to pull report info
function showReportInfo(id) {
	$.get({
		url: "app/builder/report.cfc?method=getreportInfo&id=" + id, 
		success: function(result) {
			$("#reportInfoModalBody").html(result);
		}
	});
	$('#reportInfoModal').modal()
}

//trigger a modal that alerts the user that the report delete is permanent
function triggerDeleteWarning(id) {
	$("#deleteReportButton").attr("onclick", "deleteReport(" + id + ")");
	$('#deleteModal').modal()
}

//function to trigger coldfusion function to delete the report
function deleteReport(id) {
	$.get({
		url: "app/builder/report.cfc?method=deleteReport&id=" + id, 
		success: function(result) {
		    if (result.trim() === "true") {
		    	location.reload(); 
		    } else {
			   	$("#error_alert").removeClass("alert-success");
		    	$("#error_alert").addClass("alert-danger");
		    	$("#error_alert_text").html("There was an error deleting the report.");
		    	$("#error_alert").show();
		    }
		}
	});
}