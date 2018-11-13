/*
JavaScript/JQuery code to support saving and editing filters
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
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