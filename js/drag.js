/*
JavaScript/JQuery code to support the drag/drop functionality for the 
report builder filters.
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/



//Allow drag and drop of filters to filter area
$(document).ready(function() { 	//only run once page is ready
	
	//allow drag and drop buttons
    $('.btn.verticalButton').draggable({
        cancel: false,
        connectToSortable: '.container',
        containment: 'document',
        helper: 'clone'
    });
	//display filters to the page depending on filters 
	//this code is for when filters are first added
    $(".filter_drop").droppable({
        drop: function (event, ui) {
			//Check if the added element is a filter or boolean logic
			if ($(ui.draggable).hasClass("filter")) {
				if ($(ui.draggable).attr('id') === "age_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=age"));
					filter_status.age = 1;
				} 
				else if ($(ui.draggable).attr('id') === "gender_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=gender"));
					filter_status.gender = 1;
				}
				else if ($(ui.draggable).attr('id') === "race_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=race"));
					filter_status.race = 1;
				}
				else if ($(ui.draggable).attr('id') === "ethnicity_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=ethnicity"));
					filter_status.ethnicity = 1;
				}
				else if ($(ui.draggable).attr('id') === "marital_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=marital"));
					filter_status.marital = 1;
				}
				else if ($(ui.draggable).attr('id') === "conditions_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=conditions"));
					filter_status.conditions = 1;
				}
				else if ($(ui.draggable).attr('id') === "observations_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=observations"));
					filter_status.observations = 1;
				}
				else if ($(ui.draggable).attr('id') === "medications_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=medications"));
					filter_status.medications = 1;
				}
			$(ui.draggable).attr('value', 1);
			var clone = $(ui.draggable).clone().appendTo(this);
			//make the new filter button added draggable as well
			clone.draggable({
				cancel: false,
				connectToSortable: '.container',
				containment: 'document',
				helper: 'clone'
			});
			}
			else if ($(ui.draggable).hasClass("logic")){
				//maybe add another well?
				var new_logic = document.createElement("div");
				new_logic.textContent = "boolean AND";
				new_logic.className = "well filter_drop";
				var new_logic = $("#chosen_filters").append(new_logic);
				new_logic.droppable();
				
			}
            //$(ui.draggable).remove();
        }
	
    });
});