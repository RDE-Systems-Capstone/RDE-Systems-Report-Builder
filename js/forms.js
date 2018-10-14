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

function getFilters() {
	//construct query
	var query_string = "";
	$("#chosen_filters").children().each(function() {
		//for age filter
		if (this.id == "age_button") {
			query_string += "AGE BETWEEN "
			$("#" + this.value).children().each(function() {
				if(this.id == "age_min") {
					query_string += this.value + " ";
				}
				if(this.id == "age_max") {
					query_string += "AND " + this.value;
				}
			})
		}
		//gender filter
		if (this.id == "gender_button") {
			query_string += "GENDER IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("[name='gender']:checked").map(function() {
				if (this.value == "M") {
					return this.value;
				}
				if (this.value == "F") {
					return this.value;
				}
			}).get().join(',');
			query_string += options;
		}
		//race filter
		if (this.id == "race_button") {
			query_string += "RACE IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("[name='race']:checked").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
		//ethnicity filter
		if (this.id == "ethnicity_button") {
			query_string += "ETHNICITY IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("[name='ethnicity']:checked").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
		//marital filter
		if (this.id == "marital_button") {
			query_string += "MARITAL IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("[name='marital']:checked").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
		//conditions filter
		if (this.id == "conditions_button") {
			query_string += "CONDITION IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("#condition").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
		//observations filter
		if (this.id == "observations_button") {
			query_string += "OBSERVATION IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("#observations_opt").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
			
		//medications filter
		if (this.id == "medications_button") {
			query_string += "MEDICATION IS "
			//use map function to create comma seperated list
			var options = $("#" + this.value).find("#medication_opt").map(function() {
				return this.value;
			}).get().join(',');
			query_string += options;
		}
		//and boolean operator
		if (this.id == "and_box") {
			query_string += " AND ";
		}
		//or boolean operator
		if (this.id == "or_box") {
			query_string += " OR ";
		}
		//left paren
		if (this.id == "l_paren") {
			query_string += "(";
		}
		
		//right paren
		if (this.id == "r_paren") {
			query_string += ")";
		}
	});
	alert(query_string);
};

