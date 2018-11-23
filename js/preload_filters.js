/*
JavaScript/JQuery code to support report modification.
Will read in JSON data from a previous or saved report and re-generate the builder page
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

/* this function will recreate the builder page to modify a previous report. */
function generateBuilderPage() {
	//convert the json strings to objects
	var query_json = JSON.parse(query_preload);
	var report_type_json = JSON.parse(report_type_preload);

	//change the report output type and trigger a change  in output section
	$("#report_type").val(report_type_json["type"]);
	$(".output_div").attr('hidden', true);
	if ($("#report_type").val() === "trend") {
		$("#trend_observation").val(report_type_json["observation_id"]);
		$("#trend_numbers").val(report_type_json["options"]);
		$("#trend_start_date").val(report_type_json["start_date"]);
		$("#trend_end_date").val(report_type_json["end_date"]);
		$("#trend_output_div").removeAttr('hidden');
	}
	//for pie chart, check all applicable options
	else if ($("#report_type").val() === "pie") {
		var report_values = report_type_json["group_by"];
		for (opt_count = 0; opt_count < report_values.length; opt_count++) {
			$("#pie_output").find('[value="' + report_values[opt_count] + '"]').click();
		}
		$("#pie_output_div").removeAttr('hidden');
	}
	//for doughnut chart
	else if ($("#report_type").val() === "doughnut") {
		var report_values = report_type_json["group_by"];
		for (opt_count = 0; opt_count < report_values.length; opt_count++) {
			$("#doughnut_output").find('[value="' + report_values[opt_count] + '"]').click();
		}
		$("#doughnut_output_div").removeAttr('hidden');
	}
	//bar chart
	else if ($("#report_type").val() === "bar") {
		var report_values = report_type_json["group_by"];
		for (opt_count = 0; opt_count < report_values.length; opt_count++) {
			$("#bar_output").find('[value="' + report_values[opt_count] + '"]').click();
		}
		$("#bar_output_div").removeAttr('hidden');
	}
	//data table
	else if ($("#report_type").val() === "data") {
		var report_values = report_type_json["group_by"];
		for (opt_count = 0; opt_count < report_values.length; opt_count++) {
			$("#data_output").find('[value="' + report_values[opt_count] + '"]').click();
		}
		$("#data_output_div").removeAttr('hidden');
	}

	//then for each filter we must add it to the filter output page
	query_json.forEach(function(filter) {
		var filter_id = Math.floor((Math.random() * 1000000) +1);

		//load the options for the age filter
		if (filter["type"] === "age") {
			var age_min = filter["min"];
			var age_max = filter["max"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="age_button" value="0">Age</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=age&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					createAgeFilter("between", filter_id, age_min, age_max);
				}
			});
		}
		//for gender filter
		else if (filter["type"] === "gender") {
			var filter_values = filter["values"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="gender_button" value="0">Gender</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=gender&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					for (opt_count = 0; opt_count < filter_values.length; opt_count++) {
						$("#" + filter_id).find('[value="' + filter_values[opt_count] + '"]').click();
					}
				}
			});
		}
		//for race filter
		else if (filter["type"] === "race") {
			var filter_values = filter["values"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="race_button" value="0">Race</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=race&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					for (opt_count = 0; opt_count < filter_values.length; opt_count++) {
						$("#" + filter_id).find('[value="' + filter_values[opt_count] + '"]').click();
					}
				}
			});
		}
		//for ethnicity
		else if (filter["type"] === "ethnicity") {
			var filter_values = filter["values"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="ethnicity_button" value="0">Ethnicity</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=ethnicity&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					for (opt_count = 0; opt_count < filter_values.length; opt_count++) {
						$("#" + filter_id).find('[value="' + filter_values[opt_count] + '"]').click();
					}
				}
			});
		}
		//for martial status
		else if (filter["type"] === "marital") {
			var filter_values = filter["values"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="marital_button" value="0">Marital Status</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=marital&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					for (opt_count = 0; opt_count < filter_values.length; opt_count++) {
						$("#" + filter_id).find('[value="' + filter_values[opt_count] + '"]').click();
					}
				}
			});
		}
		//for observations
		else if (filter["type"] === "observations") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="observations_button" value="0">Observations</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=observations&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='observations_opt']").val(filter_value);
					$("#" + filter_id).find("[name='value_options']").val(filter["options"]);
					$("#" + filter_id).find("[id='value_num']").val(filter["value"]);
					observationsFilterUpdate(filter_id);
				}
			});
		}
		//for observations
		else if (filter["type"] === "conditions") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="conditions_button" value="0">Conditions</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=conditions&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='condition']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'conditions', 'Conditions: ');
				}
			});
		}
		//for medications
		else if (filter["type"] === "medications") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="medications_button" value="0">Medications</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=medications&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='medication_opt']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'medications', 'Medications: ');
				}
			});
		}
		//for allergies
		else if (filter["type"] === "allergies") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="allergies_button" value="0">Allergies</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=allergies&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='allergy']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'allergies', 'Allergies: ');
				}
			});
		}
		//for immunizations
		else if (filter["type"] === "immunizations") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="immunizations_button" value="0">Immunizations</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=immunizations&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='immunization']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'immunizations', 'Immunizations: ');
				}
			});
		}
		//for encounters
		else if (filter["type"] === "encounters") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="encounters_button" value="0">Encounters</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=encounters&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='encounter']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'encounters', 'Encounters: ');
				}
			});
		}
		//for procedures
		else if (filter["type"] === "procedures") {
			var filter_value = filter["id"];
			var button = $('<button type="button" class="btn btn-primary btn-space filter filter_preloaded" data-toggle="collapse" id="procedures_button" value="0">Procedures</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=procedures&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
					$("#" + filter_id).find("[name='procedure']").val(filter_value);
					dropdownFilterUpdate(filter_id, 'procedures', 'Procedures: ');
				}
			});
		}
		//logic filters - and, or, paren
		else if (filter["type"] === "and") {
			var button = $('<button type="button" class="btn btn-primary btn-space filter_preloaded logic" data-toggle="collapse" id="and_box" value=0>AND</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=logic&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
				}
			});
		}
		else if (filter["type"] === "or") {
			var button = $('<button type="button" class="btn btn-primary btn-space filter_preloaded logic" data-toggle="collapse" id="or_box" value=0>OR</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=logic&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
				}
			});
		}
		else if (filter["type"] === "l_paren") {
			var button = $('<button type="button" class="btn btn-primary btn-space filter_preloaded logic" data-toggle="collapse" id="l_paren" value=0>(</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=logic&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
				}
			});
		}

		else if (filter["type"] === "r_paren") {
			var button = $('<button type="button" class="btn btn-primary btn-space filter_preloaded logic" data-toggle="collapse" id="r_paren" value=0>)</button>').val(filter_id);
			$("#chosen_filters").append(button);
			$.get({
				url: "app/builder/filters.cfc?method=getFilterForm&filter=logic&id=" + filter_id, 
				success: function(result) {
					$('<div>').html(result).appendTo("#filter_forms");
				}
			});
		}
	});
	//allow all pre-generated buttons to be clickable
	$(".filter_preloaded").click( function(event, ui) {
		//remove the active class from all buttons
		$(".filter").removeClass('active');
		//toggle the filter clicked and make it active
		$(this).button('toggle');
		//collapse all filter options
		$(".filter-collapse").collapse("hide");
		//show only the filter options for the one clicked
		$("#" + $(this).val() ).collapse("show");	
	});
}