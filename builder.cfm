<!--
Code for report builder page
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
-->

<cfparam name="session.loggedin" default="false" />
<cfif NOT session.loggedin>
  <cflocation url="index.cfm" addtoken="false">
</cfif>


<!DOCTYPE html>
<html lang="en">
  <head>
	<title>Report Builder</title>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/jquery-ui.css">
	<!-- Styling for range filters (age), makes it easier to see -->
	<style>
		.ui-slider-range { background: #729fcf; }
		.ui-slider-handle { border-color: #729fcf; }
		 { cursor: move; }
		.div-focus {
			box-shadow: 0 0 25px #66afe9;
		}
	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/drag.js"></script>
	<script src="js/forms.js"></script>
	<script src="js/preload_filters.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript" language="JavaScript">
	<cfoutput>
		<cfif structKeyExists(form, "report_type_string") and structKeyExists(form, "query_string")>
			var #toScript(URLDecode(FORM.report_type_string), "report_type_preload")#
			var #toScript(URLDecode(FORM.query_string), "query_preload")#
		</cfif>
	</cfoutput> 
	</script>
  </head>
<body>
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pageType="builder" activePage="builder"></cfinvoke>

	<!-- left column code-->
	<div class="row-fluid">
		<div class="container-fluid">
			<div class="row">
				<div class="col-lg-9">
					<h1>Report Builder</h1>
					
					<!-- Alert box to display errors -->
					  <div hidden class="alert alert-danger alert-dismissible fade in" id="error_alert">
						<a href="#" class="close" onclick="$('#error_alert').hide();" aria-label="close">&times;</a>
						<div id="error_alert_text"></div>
					  </div>
					<div class="row">
						<div class="form-group col-sm-4">
							<cfform name="report_type_form">
								<label for="report_type">Select report type:</label>
								<cfselect
									name="report_type"
									id="report_type"
									message="Select a type of report"
									class="form-control">
										<option selected="true" disabled="disabled"> -- select an option -- </option>
										<option value="trend">Trend Graph</option>
										<option value="pie">Pie Chart</option>
										<option value="doughnut">Doughnut Chart</option>
										<option value="bar">Bar Chart</option>
										<option value="data">Data Table</option>
								</cfselect>
							</cfform>
						</div>
					</div>


					<!-- filters will be dragged here
					as we add filters, JS code will make the filters unhidden-->
					<h1>Filters</h1>
					<div class="filter_drop well">
						<div id="chosen_filters" style="min-height: 50px; border: 1px dashed gray;"></div>
						<div id="filter_forms"></div>
						<p id="drop_text"><br>Drag and drop filters above to add them.</p>
						<p id="filter_instructions">Click on a filter to configure its options.</p>
					</div>
					
					<h1>Output</h1>
					<div id="output" style="width: 50%">
						<!-- graph output options will be displayed here -->
						<p>Choose a graph type to configure this section</p>
						<div hidden id="trend_output_div" class="output_div">
							<h3>Trend Graph</h3>
							<p>Select value to graph over time</p>
							<cfinvoke component="app.builder.report" method="trendOptions"></cfinvoke>
						</div>
						<div hidden id="pie_output_div" class="output_div">
							<h3>Pie Chart</h3>
							<p>Select field to group by:</p>
							<div class="checkbox">
								<cfinvoke component="app.builder.report" method="pieOptions"></cfinvoke>
							</div>
						</div>
						<div hidden id="bar_output_div" class="output_div">
							<h3>Bar Chart</h3>
							<p>Select field to group by:</p>
							<div class="checkbox">
								<cfinvoke component="app.builder.report" method="barOptions"></cfinvoke>
							</div>
						</div>
						<div hidden id="doughnut_output_div" class="output_div">
							<h3>Doughnut Chart</h3>
							<p>Select field to group by:</p>
							<div class="checkbox">
								<cfinvoke component="app.builder.report" method="doughnutOptions"></cfinvoke>
							</div>
						</div>
						<div hidden id="data_output_div" class="output_div">
							<h3>Data Table</h3>
							<p>Select columns to include</p>
							<div class="checkbox">
								<cfinvoke component="app.builder.report" method="dataOptions"></cfinvoke>
							</div>
						</div>
					</div>
					<br />
					<div>
					<button type="button" id= "submit" class="btn btn-primary btn-space" onclick="getFilters()">Submit</button>
					<form style="display: hidden" action="output.cfm" method="POST" id="form">
						<input type="hidden" id="report_type_string" name="report_type_string" value=""/>
						<input type="hidden" id="query_string" name="query_string" value=""/>
						<cfif isDefined("FORM.report_id")>
							<cfoutput><input type="hidden" id="report_id" name="report_id" value="#FORM.report_id#"/></cfoutput>
						<cfelse>
							<input type="hidden" id="report_id" name="report_id" value="0"/>
						</cfif>
					</form>
					</div>
				 </div>

				<!-- Available filters column code-->
				 <div class="col-lg-3">
				 	<h1>Available Filters</h1>
					<div id="filters_list">
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="age_button" value=0>Age</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="gender_button" value=0>Gender</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="race_button" value=0>Race</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="ethnicity_button" value=0>Ethnicity</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="marital_button" value=0>Marital Status</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="conditions_button" value=0>Conditions</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="observations_button" value=0>Observations</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="medications_button" value=0>Medications</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="immunizations_button" value=0>Immunizations</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="allergies_button" value=0>Allergies</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="encounters_button" value=0>Encounters</button>
						<button type="button" class="btn btn-primary btn-space filter" data-toggle="collapse" id="procedures_button" value=0>Procedures</button>
					</div>
					<h1>Boolean Logic</h1>
					<div id="filter_logic">
						<button type="button" class="btn btn-primary btn-space logic" data-toggle="collapse" id="l_paren" value=0>(</button>
						<button type="button" class="btn btn-primary btn-space logic" data-toggle="collapse" id="r_paren" value=0>)</button>
						<button type="button" class="btn btn-primary btn-space logic" data-toggle="collapse" id="and_box" value=0>AND</button>
						<button type="button" class="btn btn-primary btn-space logic" data-toggle="collapse" id="or_box" value=0>OR</button>
					</div>
				</div>
			 </div>
			</div>
		</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
  </body>
</html>
