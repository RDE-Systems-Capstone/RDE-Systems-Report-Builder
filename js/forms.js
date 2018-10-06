/*
JavaScript/JQuery code to support DOM manipulation of builder page
*/

//Allow drag and drop of filters to filter area
$(document).ready(function() { 	//only run once page is ready
	//Load output section based on report chosen
	$("#report_type").change(function() {
		if ($("#report_type").val() === "trend") {
			$("#trend_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		if ($("#report_type").val() === "pie") {
			$("#trend_output_div").attr('hidden', true);
			$("#pie_output_div").removeAttr('hidden');
			$("#bar_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		if ($("#report_type").val() === "bar") {
			$("#trend_output_div").attr('hidden', true);
			$("#bar_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#data_output_div").attr('hidden', true);
		}
		if ($("#report_type").val() === "data") {
			$("#trend_output_div").attr('hidden', true);
			$("#data_output_div").removeAttr('hidden');
			$("#pie_output_div").attr('hidden', true);
			$("#bar_output_div").attr('hidden', true);
		}
	});
});

