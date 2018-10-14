/*
JavaScript/JQuery code to support the drag/drop functionality for the 
report builder filters.
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

//Allow drag and drop of filters to filter area
$(document).ready(function() { 	//only run once page is ready
	var sourceElement;
	
	//allow drag and drop buttons
    $('.btn.verticalButton').draggable({
        cancel: false,
        connectToSortable: '.container',
        containment: 'document',
        helper: 'clone',
		start: function (event, ui) {
			sourceElement = $(this).closest('div').attr('id');
		}
    });
	//display filters to the page depending on filters 
	//this code is for when filters are first added
    $(".filter_drop").droppable({
        drop: function (event, ui) {
			if (sourceElement == "filters_list" || sourceElement == "filter_logic") {
				//generate a random ID number to associate form data with filter
				//this will allow us to support multiple versions of the same filter!
				var filter_id = Math.floor((Math.random() * 10000) +1);
				
				//Check if the added element is a filter or boolean logic
				if ($(ui.draggable).attr('id') === "age_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=age&id=" + filter_id));
					filter_status.age = 1;
				} 
				else if ($(ui.draggable).attr('id') === "gender_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=gender&id=" + filter_id));
					filter_status.gender = 1;
				}
				else if ($(ui.draggable).attr('id') === "race_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=race&id=" + filter_id));
					filter_status.race = 1;
				}
				else if ($(ui.draggable).attr('id') === "ethnicity_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=ethnicity&id=" + filter_id));
					filter_status.ethnicity = 1;
				}
				else if ($(ui.draggable).attr('id') === "marital_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=marital&id=" + filter_id));
					filter_status.marital = 1;
				}
				else if ($(ui.draggable).attr('id') === "conditions_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=conditions&id=" + filter_id));
					filter_status.conditions = 1;
				}
				else if ($(ui.draggable).attr('id') === "observations_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=observations&id=" + filter_id));
					filter_status.observations = 1;
				}
				else if ($(ui.draggable).attr('id') === "medications_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=medications&id=" + filter_id));
					filter_status.medications = 1;
				}
				$(ui.draggable).attr('value', filter_id);
				var clone = $(ui.draggable).clone().appendTo("#chosen_filters");

				//make the new filter button added draggable as well
				clone.draggable({
					cancel: false,
					connectToSortable: '.container',
					containment: 'document',
					helper: 'clone',
					start: function (event, ui) {
						sourceElement = $(this).closest('div').attr('id');
					}
				});
			} else {
				var clone = $(ui.draggable).clone().appendTo("#chosen_filters");

				//make the new filter button added draggable as well
				clone.draggable({
					cancel: false,
					connectToSortable: '.container',
					containment: 'document',
					helper: 'clone',
					start: function (event, ui) {
						sourceElement = $(this).closest('div').attr('id');
					}
				});
				$(ui.draggable).remove();
			}
        }
	
    });
});
