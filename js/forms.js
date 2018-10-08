/*
JavaScript/JQuery code to support DOM manipulation of builder page
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

//JS object to keep track of enabled filters
var filter_status = {
		age: 0,
		gender: 0,
		race: 0,
		ethnicity: 0,
		marital: 0,
		conditions: 0,
		observations: 0,
		medications: 0
}

$(document).ready(function() { 	//only run once page is ready
	//Load output section based on report chosen
	$("#report_type").change(function() {
		if ($("#report_type").val() === "trend") {
			$("#trend_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "pie") {
			$("#trend_output_div").attr('hidden', true);
			$("#pie_output_div").removeAttr('hidden');
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "bar") {
			$("#trend_output_div").attr('hidden', true);
			$("#bar_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "data") {
			$("#trend_output_div").attr('hidden', true);
			$("#data_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
		}
	});
	//for now this function will print out the enabled filters along with values passed
	//Later on, this will probably POST to a page that will execute the SQL query to build reports
	$("#submit").click(function() {
		var filter_count = 0;
		var query_debug = "";
		
		query_debug += "Report Type: " + $("#report_type").val() + "\n";
		
		query_debug += "Filters applied: \n"
		if (filter_status.age === 1) {
			filter_count++;
			query_debug += "AGE between " + $("#age_min").val() + " and " + $("#age_max").val() + "\n";
		}
		if (filter_status.gender === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "GENDER is ";
			$("#gender_options input:checked").each(function(){
				query_debug += $(this).attr('value') + " ";
			});
			query_debug += "\n"
		}
		if (filter_status.race === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "RACE is ";
			$("#race_options input:checked").each(function(){
				query_debug += $(this).attr('value') + " ";
			});
			query_debug += "\n"
		}
		if (filter_status.ethnicity === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "ETHNICITY is ";
			$("#ethnicity_options input:checked").each(function(){
				query_debug += $(this).attr('value') + " ";
			});
			query_debug += "\n"
		}
		if (filter_status.marital === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "MARITAL is ";
			$("#marital_options input:checked").each(function(){
				query_debug += $(this).attr('value') + " ";
			});
			query_debug += "\n"
		}
		if (filter_status.conditions === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "CONDITION is " + $("#condition").val();
			query_debug += "\n"
		}
		if (filter_status.medications === 1) {
			filter_count++;
			if (filter_count > 1) {
				query_debug += "AND ";
			}
			query_debug += "MEDICATION is " + $("#medication_opt").val();
			query_debug += "\n"
		}
		alert(query_debug);
	});
});

