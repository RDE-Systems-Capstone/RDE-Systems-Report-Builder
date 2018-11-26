/*
JavaScript/JQuery code to support DOM manipulation of builder page
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

//graph options
$(document).ready(function() { 	//only run once page is ready
	//Load output section based on report chosen
	//We do this by making the corresponding div unhidden0
	$("#report_type").change(function() {
		$(".output_div").attr('hidden', true);
		if ($("#report_type").val() === "trend") {
			$("#trend_output_div").removeAttr('hidden');
		}
		else if ($("#report_type").val() === "pie") {
			$("#pie_output_div").removeAttr('hidden');
		}
		else if ($("#report_type").val() === "doughnut") {
			$("#doughnut_output_div").removeAttr('hidden');
		}
		else if ($("#report_type").val() === "bar") {
			$("#bar_output_div").removeAttr('hidden');
		}
		else if ($("#report_type").val() === "data") {
			$("#data_output_div").removeAttr('hidden');
		}
	});
});

/* WORK IN PROGRESS - SHOW FILTER DATA IN CHOSEN FILTER TEXT 
function ageFilterUpdate has been moved. See drag.js:createAgeFilter function */

/* This function will update the text of the observations dropdown-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function observationsFilterUpdate(filter_id) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find("option:selected");
	var value_num = $("#value_num").val();
	var filter_text = "Observations: ";
	
	options.each( function() {
		filter_text += $(this).text() + " ";
	});
	filter_text += value_num;
	button.innerHTML = filter_text;
};

/* This function will update the text of any checkbox-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function checkboxFilterUpdate(filter_id, filter_type, filter_text) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find(":checked");
	var values = [];

	options.each( function() {
		values.push($(this).attr("data-label"));
	});
	filter_text += values.join(', ');
	button.innerHTML = filter_text;
};

/* This function will update the text of any dropdown-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function dropdownFilterUpdate(filter_id, filter_type, filter_text) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find("option:selected");
	
	options.each( function() {
		filter_text += $(this).text();
	});
	button.innerHTML = filter_text;
};

//Function that will delete the filter, its filter button and all associated forms and options
function deleteFilter(filter_id) {
	//delete the button added to the chosen filters
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	$(button).remove();
	//delete the associated options for the filter
	var filter_options = $("#" + filter_id);
	$(filter_options).parent().remove();
}

function getFilters() {
	//store filter params in array
	var filters_array = [];
	var tokens = [];
	var filter_string = "";

	//keep track of errors
	var errors = 0;
	var error_list = "<strong>Errors detected:</strong><br />";
	
	//first let's get the report type and associated parameters
	var report_options = {};
	report_options["type"] = $("#report_type").val();
	
	//add report type options to array
	//for trend
	if ( $("#report_type").val() === "trend" ) {
		if ($("#trend_observation").val() == null) {
			errors++;
			error_list += "Output: Trend observation can't be empty<br />";
		}
		report_options["observation_id"] = $("#trend_observation").val();
		report_options["options"] = $("#trend_numbers").val();
		if ($("#trend_start_date").val() == "" || $("#trend_end_date").val() == "" ) {
			errors++;
			error_list += "Output: Trend dates can't be empty<br />";
		}
		report_options["start_date"] = $("#trend_start_date").val();
		report_options["end_date"] = $("#trend_end_date").val();
	}
	//for bar graph
	else if ( $("#report_type").val() === "bar" ) {
		bar_array = [];
		var options = $("#bar_output").find("[name='columns']:checked").each(function() {
			bar_array.push(this.value);
		});
		if ( bar_array.length == 0 ) {
			error_list += "Output: Bar graph is missing options<br />";
			errors++;
		}
		report_options["group_by"] = bar_array;
	}
	//for pie graph
	else if ( $("#report_type").val() === "pie" ) {
		pie_array = [];
		var options = $("#pie_output").find("[name='columns']:checked").each(function() {
			pie_array.push(this.value);
		});
		if ( pie_array.length == 0 ) {
			error_list += "Output: Pie graph is missing options<br />";
			errors++;
		}
		report_options["group_by"] = pie_array;
	}
	//for donut graph
	else if ( $("#report_type").val() === "doughnut" ) {
		doughnut_array = [];
		var options = $("#doughnut_output").find("[name='columns']:checked").each(function() {
			doughnut_array.push(this.value);
		});
		if ( doughnut_array.length == 0 ) {
			error_list += "Output: Doughnut graph is missing options<br />";
			errors++;
		}
		report_options["group_by"] = doughnut_array;
	}
	//for data table
	else if ( $("#report_type").val() === "data" ) {
		data_array = [];
		var options = $("#data_output").find("[name='columns']:checked").each(function() {
			data_array.push(this.value);
		});
		if ( data_array.length == 0 ) {
			error_list += "Output: Data table is missing options<br />";
			errors++;
		}
		report_options["group_by"] = data_array;
	} 
	else if ( $("#report_type").val() == null ) {
		error_list += "Report Type: Graph option can't be empty<br />";
		errors++;
	}
	
	//alert(JSON.stringify(report_options));
	var chosen_filters = $("#chosen_filters").children();
	if (chosen_filters.length == 0) {
		error_list += "Filters: No filters selected<br />";
		errors++;
	} else {
		chosen_filters.each(function() {
			filter_string += $(this).text() + " ";
			//input validation for and/or
			if ($(this).hasClass("filter")) {
				if ( $(this).prev().hasClass("filter") ) {
					error_list += "Filters: AND/OR is missing<br />";
					errors++;	
				}
			}
			//for age filter
			if (this.id == "age_button") {
				//get the filter id
				filter_id = this.value;
				var age_array = {}
				age_array["type"] = "age";
				var slider = $("#" + this.value).find(".ui-slider").each(function() {
					//define filter type and params
					age_array['format'] = "between";
					//get the max and min age from slider
					age_array["min"] = $( "#slider" + filter_id ).slider( "values", 0 );
					age_array["max"] = $( "#slider" + filter_id ).slider( "values", 1 );
				});
				//alert(JSON.stringify(age_array));
				filters_array.push(age_array);
			}
			//gender filter
			else if (this.id == "gender_button") {
				var gender_array = {"type":"gender"}
				gender_array["values"] = [];
				var options = $("#" + this.value).find("[name='gender']:checked").each(function() {
					if (this.value == "M") {
						gender_array["values"].push(this.value)
					}
					if (this.value == "F") {
						gender_array["values"].push(this.value)
					}
				});
				if ( gender_array["values"].length == 0) {
					error_list += "Filters: Gender filter is missing options<br />";
					errors++;
				}
				filters_array.push(gender_array);
			}
			 else if (this.id == "race_button") {
				var race_array = {"type":"race"}
				race_array["values"] = [];
				var options = $("#" + this.value).find("[name='race']:checked").each(function() {
					race_array["values"].push(this.value)
				});
				if ( race_array["values"].length == 0) {
					error_list += "Filters: Race filter is missing options<br />";
					errors++;
				}
				filters_array.push(race_array);
			}
			 else if (this.id == "ethnicity_button") {
				var eth_array = {"type":"ethnicity"}
				eth_array["values"] = [];
				var options = $("#" + this.value).find("[name='ethnicity']:checked").each(function() {
					eth_array["values"].push(this.value)
				});
				if ( eth_array["values"].length == 0) {
					error_list += "Filters: Ethnicity filter is missing options<br />";
					errors++;
				}
				filters_array.push(eth_array);
			}
			 else if (this.id == "marital_button") {
				var marital_array = {"type":"marital"}
				marital_array["values"] = [];
				var options = $("#" + this.value).find("[name='marital']:checked").each(function() {
					marital_array["values"].push(this.value)
				});
				if ( marital_array["values"].length == 0) {
					error_list +="Filters: Marital status filter is missing options<br />";
					errors++;
				}
				filters_array.push(marital_array);
			}
			 else if (this.id == "conditions_button") {
				var conditions_array = {"type":"conditions"}
				var options = $("#" + this.value).find("[name='condition']").each(function() {
					conditions_array["id"] = this.value;

				});
				filters_array.push(conditions_array);
			}
			 else if (this.id == "observations_button") {
				var observations_array = {"type":"observations"}
				var options = $("#" + this.value).find("[name='observations_opt']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Observations filter is missing options<br />";
						errors++;
					}
					observations_array["id"] = this.value;
				});
				$("#" + this.value).find("*").each(function() {
					if (this.id == "value_options") {
						observations_array["options"] = this.value;
					}
					if (this.id == "value_num") {
						observations_array["value"] = this.value;
					}
				});
				filters_array.push(observations_array);
			}
			 else if (this.id == "medications_button") {
				var medications_array = {"type":"medications"}
				var options = $("#" + this.value).find("[name='medication_opt']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Medications filter is missing options\n";
						errors++;
					}
					medications_array["id"] = this.value;
				});
				filters_array.push(medications_array);
			}
			 else if (this.id == "immunizations_button") {
				var immunization_array = {"type":"immunizations"}
				var options = $("#" + this.value).find("[name='immunization']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Immunizations filter is missing options!\n";
						errors++;
					}
					immunization_array["id"] = this.value;
				});
				filters_array.push(immunization_array);
			}
			 else if (this.id == "allergies_button") {
				var allergy_array = {"type":"allergies"}
				var options = $("#" + this.value).find("[name='allergy']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Allergy filter is missing options!<br />";
						errors++;
					}
					allergy_array["id"] = this.value;
				});
				filters_array.push(allergy_array);
			}
			 else if (this.id == "encounters_button") {
				var encounters_array = {"type":"encounters"}
				var options = $("#" + this.value).find("[name='encounter']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Encounters filter is missing options<br />";
						errors++;
					}
					encounters_array["id"] = this.value;
				});
				filters_array.push(encounters_array);
			}
			 else if (this.id == "procedures_button") {
				var procedures_array = {"type":"procedures"}
				var options = $("#" + this.value).find("[name='procedure']").each(function() {
					if ( $(this).val() == null ) {
						error_list += "Filters: Procedures filter is missing options!<br />";
						errors++;
					}
					procedures_array["id"] = this.value;
				});
				filters_array.push(procedures_array);
			}
			else if (this.id == "l_paren") {
				var lparen_arr = {"type":"l_paren"}
				filters_array.push(lparen_arr);
				tokens.push("(");
				
			}
			else if (this.id == "r_paren") {
				var rparen_arr = {"type":"r_paren"}
				filters_array.push(rparen_arr);
				if (tokens.pop() !== "(") {
					error_list +="Filters: Missing parentheses\n";
					errors++;
				};
			}
			else if (this.id == "and_box") {
				if (!($(this).prev().hasClass("filter"))) {
					error_list += "Filters: Missing filter before AND!<br />";
					errors++;
				}
				if (!($(this).next().hasClass("filter") || $(this).next().attr('id') == "l_paren")) {
					error_list += "Filters: Missing filter after AND!<br />";
					errors++;
				}
				var and_arr = {"type":"and"}
				filters_array.push(and_arr);
				
			}
			else if (this.id == "or_box") {
				if (!$(this).prev().hasClass("filter")) {
					error_list += "Filters: Missing filter before OR!<br />";
					errors++;
				}
				if (!$(this).next().hasClass("filter")) {
					error_list += "Filters: Missing filter after OR!<br />";
					errors++;
				}
				var or_arr = {"type":"or"}
				filters_array.push(or_arr);
				
			}
		});
	}

	//generate a string of the chosen filters for the output page
	var report_filter_string = {"type":"filter_string", "string": filter_string};
	filters_array.push(report_filter_string);

	//Verify that the parentheses match
	if (tokens.length != 0) {
		error_list +="Filters: Missing parentheses\n";
		errors++;
	} 
	if (errors == 0) {
		$("#query_string").val(JSON.stringify(filters_array));
		$("#report_type_string").val(JSON.stringify(report_options));
		//alert(query_string);
		$("#form").submit();
	} else {
		$("#error_alert_text").html(error_list);
		$("#error_alert").show();
	}

};

