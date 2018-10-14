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

//graph options
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
});

function getFilters() {
	//store filter params in array
	var filters_array = [];
	//also get the report type
	var report_options = {};
	report_options["type"] = $("#report_type").val();
	alert(JSON.stringify(report_options));
	var chosen_filters = $("#chosen_filters").children();
	if (chosen_filters.length !== 0) {
	}
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
			alert(JSON.stringify(age_array));
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
			filters_array.push(gender_array);
		}
		 else if (this.id == "race_button") {
			var race_array = {"type":"race"}
			race_array["values"] = [];
			var options = $("#" + this.value).find("[name='race']:checked").each(function() {
				race_array["values"].push(this.value)
			});
			filters_array.push(race_array);
		}
		 else if (this.id == "ethnicity_button") {
			var eth_array = {"type":"ethnicity"}
			eth_array["values"] = [];
			var options = $("#" + this.value).find("[name='ethnicity']:checked").each(function() {
				eth_array["values"].push(this.value)
			});
			filters_array.push(eth_array);
		}
		 else if (this.id == "marital_button") {
			var marital_array = {"type":"marital"}
			marital_array["values"] = [];
			var options = $("#" + this.value).find("[name='marital']:checked").each(function() {
				marital_array["values"].push(this.value)
			});
			filters_array.push(marital_array);
		}
		 else if (this.id == "conditions_button") {
			var conditions_array = {"type":"conditions"}
			conditions_array["value"] = [];
			var options = $("#" + this.value).find("[name='condition']").each(function() {
				conditions_array["value"].push(this.value)
			});
			filters_array.push(conditions_array);
		}
		 else if (this.id == "observations_button") {
			var observations_array = {"type":"observations"}
			observations_array["value"] = [];
			var options = $("#" + this.value).find("[name='observations_opt']").each(function() {
				observations_array["value"].push(this.value)
			});
			filters_array.push(observations_array);
		}
		 else if (this.id == "medications_button") {
			var medications_array = {"type":"medications"}
			medications_array["value"] = [];
			var options = $("#" + this.value).find("[name='medication_opt']").each(function() {
				medications_array["value"].push(this.value)
			});
			filters_array.push(medications_array);
		}
		else if (this.id == "l_paren") {
			var lparen_arr = {"type":"l_paren"}
			filters_array.push(lparen_arr);
			
		}
		else if (this.id == "r_paren") {
			var rparen_arr = {"type":"r_paren"}
			filters_array.push(rparen_arr);
			
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
	alert(JSON.stringify(filters_array));
	
	$("#query_string").val(JSON.stringify(filters_array));
	$("#report_type_string").val(JSON.stringify(report_options));
	//alert(query_string);
	$("#form").submit();

};

