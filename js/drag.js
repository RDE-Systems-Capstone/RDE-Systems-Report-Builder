/*
JavaScript/JQuery code to support the drag/drop functionality for the 
report builder filters.
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
	//display filters to the page depending on filters dragged
    $(".filter_drop").droppable({
        drop: function (event, ui) {
			if ($(ui.draggable).attr('id') === "age_button") {
				$("#age_filter").removeAttr('hidden')
			} 
			if ($(ui.draggable).attr('id') === "gender_button") {
				$("#gender_filter").removeAttr('hidden')
			}
			if ($(ui.draggable).attr('id') === "race_button") {
				$("#race_filter").removeAttr('hidden')
			}
			if ($(ui.draggable).attr('id') === "ethnicity_button") {
				$("#ethnicity_filter").removeAttr('hidden')
			}
			if ($(ui.draggable).attr('id') === "marital_button") {
				$("#marital_filter").removeAttr('hidden')
			}
			if ($(ui.draggable).attr('id') === "conditions_button") {
				$("#conditions_filter").removeAttr('hidden')
			}
            //$(ui.draggable).remove();
			$(ui.draggable).attr('value', 1);
			$("#chosen_filters").append($(ui.draggable));
        }
    });
});