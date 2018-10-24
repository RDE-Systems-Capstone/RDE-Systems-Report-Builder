/*
JavaScript/JQuery code to support DOM manipulation of builder page
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

//graph options
$(document).ready(function() { 	//only run once page is ready
	//Load output section based on report chosen
	$("#report_type").change(function() {
		if ($("#report_type").val() === "trend") {
			$("#trend_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
			$("#doughnut_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "pie") {
			$("#trend_output_div").attr('hidden', true);
			$("#pie_output_div").removeAttr('hidden');
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
			$("#doughnut_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "doughnut") {
			$("#trend_output_div").attr('hidden', true);
			$("#doughnut_output_div").removeAttr('hidden');
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
			$("#pie_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "bar") {
			$("#trend_output_div").attr('hidden', true);
			$("#bar_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
			$("#doughnut_output_div").attr('hidden', true);
		}
		else if ($("#report_type").val() === "data") {
			$("#trend_output_div").attr('hidden', true);
			$("#data_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
			$("#doughnut_output_div").attr('hidden', true);
		}
	});
});

/* WORK IN PROGRESS - SHOW FILTER DATA IN CHOSEN FILTER TEXT 
The following function ageFilterUpdate will update the text of the filter button to refect the parameters set by the user */
function ageFilterUpdate(filter_id) {
	var buttons = $("#chosen_filters").find("[type='button']");
	var age_options = $("#" + filter_id);
	var age_min = $(age_options).find("#age_min");
	var age_max = $(age_options).find("#age_max");
	for(i = 0; i < buttons.length; i++) {
		if (buttons[i].value === filter_id) {
			buttons[i].innerHTML = "Age BETWEEN " + age_min.val() + ", " + age_max.val();
			break;
		}
	}
};

/* This function will update the text of the observations dropdown-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function observationsFilterUpdate(filter_id) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find("option:selected");
	var value_num = $("#value_num").val();
	var filter_text = "Observations: ";
	
	button.innerHTML = filter_text;
	options.each( function() {
		button.append($(this).text() + " ");
	});
	button.append(value_num);
};

/* This function will update the text of any checkbox-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function checkboxFilterUpdate(filter_id, filter_type, filter_text) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find(":checked");
	
	button.innerHTML = filter_text;
	options.each( function() {
		button.append(this.value + " ");
	});
};

/* This function will update the text of any dropdown-type filter
 where filter_id is the unique id of the added filter, filter_type is type of filter (ex. race) and filter_text is text to be prepended (ex. "Race: ") */
function dropdownFilterUpdate(filter_id, filter_type, filter_text) {
	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
	var filter_options = $("#" + filter_id);
	var options = $(filter_options).find("option:selected");
	
	button.innerHTML = filter_text;
	options.each( function() {
		button.append($(this).text());
	});
};


function getFilters() {
	//store filter params in array
	var filters_array = [];
	var tokens = [];

	//keep track of errors
	var errors = 0;
	var error_list = "<strong>Errors detected:</strong><br />";
	
	//first let's get the report type and associated parameters
	var report_options = {};
	report_options["type"] = $("#report_type").val();
	
	//add report type options to array
	//for trend
	if ( $("#report_type").val() === "trend" ) {
		report_options["observation_id"] = $("#trend_observation").val();
		report_options["options"] = $("#trend_numbers").val();
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
		report_options["columns"] = doughnut_array;
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
			//for age filter
			if (this.id == "age_button") {
				var age_array = {}
				age_array["type"] = "age";
				$("#" + this.value).children().each(function() {
					//define filter type and params
					age_array['format'] = "between";
					if(this.id == "age_min") {
						age_array["min"] = this.value;
					}
					if(this.id == "age_max") {
						age_array["max"] = this.value;
					}
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
				tokens.push("(")
				
			}
			else if (this.id == "r_paren") {
				var rparen_arr = {"type":"r_paren"}
				filters_array.push(rparen_arr);
				tokens.pop();
			}
			else if (this.id == "and_box") {
				var and_arr = {"type":"and"}
				filters_array.push(and_arr);
				
			}
			else if (this.id == "or_box") {
				var or_arr = {"type":"or"}
				filters_array.push(or_arr);
				
			}
		});
	}
	//alert(JSON.stringify(filters_array));

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

