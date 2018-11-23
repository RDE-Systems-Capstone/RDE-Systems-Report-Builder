/*
JavaScript/JQuery code to support the drag/drop functionality for the 
report builder filters.
RDE Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
*/

//Generate range silders for the age filter
function createAgeFilter(option, filter_id, age_min, age_max) {
	if (option === "between") {
		//Generate a range slider with two drag handles
		$( "#slider" + filter_id ).slider({
			range: true,
		    min: 0,
		    max: 150,
		    values: [ age_min, age_max ],
		    slide: function( event, ui ) {
		    	//update label for range filter on slide
	        	$( "#amount" + filter_id ).text( "Between: " + ui.values[ 0 ] + " and " + ui.values[ 1 ] );
	        	//Also update the filter button text as well. Moved from ageFilterUpdate function
	        	var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
				button.innerHTML = "Age BETWEEN " + ui.values[ 0 ] + ", " + ui.values[ 1 ];
	     	}
		});
		//initially add text to range slider label
		$( "#amount" + filter_id ).text( "Between: " + $( "#slider" + filter_id ).slider( "values", 0 ) + " and " + $( "#slider" + filter_id ).slider( "values", 1 ) );
		//Also update the filter button text as well on init. Moved from ageFilterUpdate function
		var button = $("#chosen_filters").find("[type='button'][value=" + filter_id + "]")[0];
		button.innerHTML = "Age BETWEEN " + $( "#slider" + filter_id ).slider( "values", 0 ) + ", " + $( "#slider" + filter_id ).slider( "values", 1 );
	}
};

//Allow drag and drop of filters to filter area
$(document).ready(function() { 	//only run once page is ready
	//function to preload data if report data is sent to builder page
	if (typeof report_type_preload != 'undefined' && typeof query_preload != 'undefined') {
		generateBuilderPage();
	}
	var sourceElement;
	
	//allow drag and drop buttons
    $('.btn.verticalButton').draggable({
        cancel: false,
        containment: 'document',
        helper: 'clone',
		start: function (event, ui) {
			sourceElement = $(this).closest('div').attr('id');
			$('.filter_drop').addClass("div-focus");
		},
		stop: function(event, ui) {
			$('.filter_drop').removeClass("div-focus");
		}
    });
	//display filters to the page depending on filters 
	//this code is for when filters are first added
    $(".filter_drop").droppable({
        drop: function (event, ui) {
        	//prevent default browser behavior
			if (sourceElement == "filters_list" || sourceElement == "filter_logic") {
				//generate a random ID number to associate form data with filter
				//this will allow us to support multiple versions of the same filter!
				var filter_id = Math.floor((Math.random() * 1000000) +1);
				
				//Check if the added element is a filter or boolean logic
				//if it's a filter use AJAX to pull a form to configure filter attributes
				if ($(ui.draggable).attr('id') === "age_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=age&id=" + filter_id, function() {
						createAgeFilter("between", filter_id, 20, 50);
					}));
				} 
				else if ($(ui.draggable).attr('id') === "gender_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=gender&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "race_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=race&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "ethnicity_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=ethnicity&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "marital_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=marital&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "conditions_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=conditions&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "observations_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=observations&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "medications_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=medications&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "immunizations_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=immunizations&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "allergies_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=allergies&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "encounters_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=encounters&id=" + filter_id));
				}
				else if ($(ui.draggable).attr('id') === "procedures_button") {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=procedures&id=" + filter_id));
				} 
				else if ( $(ui.draggable).hasClass('logic') ) {
					$("#filter_forms").append($('<div>').load("app/builder/filters.cfc?method=getFilterForm&filter=logic&id=" + filter_id));
				}
				$(ui.draggable).attr('value', filter_id);
				$(ui.draggable).removeClass("verticalButton");
				var clone = $(ui.draggable).clone().appendTo("#chosen_filters");

				//allow sorting of buttons
				$("#chosen_filters").sortable({
					cancel: '',
					helper: "clone",
					start: function (event, ui) {
						sourceElement = $(this).closest('div').attr('id');
					}
				});

    			//Allow toggling of buttons when clicked
    			//also trigger the collapse attribute of the filter's options so that the user can configure them
    			clone.click( function(event, ui) {
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
        }
	
    });
});
