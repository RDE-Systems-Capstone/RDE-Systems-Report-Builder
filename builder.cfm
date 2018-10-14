<!--
Code for report builder page
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
-->


<!DOCTYPE html>
<html lang="en">
  <head>
	<title>Report Builder</title>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/drag.js"></script>
	<script src="js/forms.js"></script>
	<script src="js/bootstrap.min.js"></script>
  </head>
<body>
<!-- Navbar code-->
	<nav class="navbar navbar-inverse">
	  <div class="container-fluid">
		<div class="navbar-header">
		  <a class="navbar-brand" href="#">RDE</a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="builder.cfm">Builder</a></li>
			<li><a href="output.cfm">Output</a></li>
			<li><a href="#">Saved Reports</a></li>
		</ul>
	  </div>
	</nav>

	<!-- left column code-->
	<div class="col-lg-10">
		<h1>Report Builder</h1>
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
							<option value="pie">Pie/Doughnut Chart</option>
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
			<p>Drag and drop filters here to add them.</p>
			<div id="chosen_filters"></div>
		</div>
		<div id="filter_forms"></div>
		

		<h1>Output</h1>
		<div id="output" style="width: 50%">
			<p>Choose a graph type to configure this section</p>
			<div hidden id="trend_output_div">
				<p>Select value to graph over time</p>
				<cfinvoke component="app.builder.report" method="trendOptions"></cfinvoke>
			</div>
			<div hidden id="pie_output_div">
				<p>Select field to group by:</p>
				<cfinvoke component="app.builder.report" method="pieOptions"></cfinvoke>
			</div>
			<div hidden id="bar_output_div">
				<p>Work in progress</p>
				<!--- <cfinvoke component="app.builder.report" method="trendOptions"></cfinvoke> --->
			</div>
			<div hidden id="data_output_div">
				<p>Select columns to include</p>
				<div class="checkbox">
					<cfinvoke component="app.builder.report" method="dataOptions"></cfinvoke>
				</div>
			</div>
		</div>
		<br />
		<div>
		<button type="button" id= "submit" class="btn btn-primary" onclick="getFilters()">Submit</button>
		</div>
	 </div>

	<!-- Available filters column code-->
	 <div class="col-lg-2">
		<div id="filters_list">
			<h1>Available Filters</h1>
			<button type="button" class="btn verticalButton filter" id="age_button" value=0>Age</button>
			<button type="button" class="btn verticalButton filter" id="gender_button" value=0>Gender</button>
			<button type="button" class="btn verticalButton filter" id="race_button" value=0>Race</button>
			<button type="button" class="btn verticalButton filter" id="ethnicity_button" value=0>Ethnicity</button>
			<button type="button" class="btn verticalButton filter" id="marital_button" value=0>Marital Status</button>
			<button type="button" class="btn verticalButton filter" id="conditions_button" value=0>Conditions</button>
			<button type="button" class="btn verticalButton filter" id="observations_button" value=0>Observations</button>
			<button type="button" class="btn verticalButton filter" id="medications_button" value=0>Medications</button>
		</div>
		<div id="filter_logic">
			<h1>Boolean Logic</h1>
			<button type="button" class="btn verticalButton logic" id="l_paren" value=0>(</button>
			<button type="button" class="btn verticalButton logic" id="r_paren" value=0>)</button>
			<button type="button" class="btn verticalButton logic" id="and_box" value=0>AND</button>
			<button type="button" class="btn verticalButton logic" id="or_box" value=0>OR</button>
		</div>
	 </div>

	 <script>
  </body>
</html>
