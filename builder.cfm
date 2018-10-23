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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/drag.js"></script>
	<script src="js/forms.js"></script>
	<script src="js/bootstrap.min.js"></script>
  </head>
<body>
<!-- Navbar code-->
	<nav class="navbar navbar-default">
	  <div class="container-fluid">
		<div class="navbar-header">
		  <a class="navbar-brand" href="https://www.rde.org/">
			<img src="images/rde_logo_white.png" width="auto" height="100%" alt="">
		  </a>
		</div>
		<ul class="nav navbar-nav">
			<li class="active"><a href="builder.cfm">Builder</a></li>
			<li><a href="output.cfm">Output</a></li>
			<li><a href="#">Saved Reports</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a>Welcome <cfoutput>#session.FirstName# #session.LastName#</cfoutput></a></li>
			<li><a href="app/logout.cfm">Logout</a></li>
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
			<p>Drag and drop filters here to add them.</p>
			<p>Click on a filter to configure its options.</p>
			<div id="chosen_filters"></div>
			<div id="filter_forms"></div>
		</div>
		
		<h1>Output</h1>
		<div id="output" style="width: 50%">
			<p>Choose a graph type to configure this section</p>
			<div hidden id="trend_output_div">
				<h3>Trend Graph</h3>
				<p>Select value to graph over time</p>
				<cfinvoke component="app.builder.report" method="trendOptions"></cfinvoke>
			</div>
			<div hidden id="pie_output_div">
				<h3>Pie Chart</h3>
				<p>Select field to group by:</p>
				<div class="checkbox">
					<cfinvoke component="app.builder.report" method="pieOptions"></cfinvoke>
				</div>
			</div>
			<div hidden id="bar_output_div">
				<h3>Bar Chart</h3>
				<p>Select field to group by:</p>
				<div class="checkbox">
					<cfinvoke component="app.builder.report" method="barOptions"></cfinvoke>
				</div>
			</div>
			<div hidden id="doughnut_output_div">
				<h3>Doughnut Chart</h3>
				<p>Select field to group by:</p>
				<div class="checkbox">
					<cfinvoke component="app.builder.report" method="doughnutOptions"></cfinvoke>
				</div>
			</div>
			<div hidden id="data_output_div">
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
		</form>
		</div>
	 </div>

	<!-- Available filters column code-->
	 <div class="col-lg-2">
		<div id="filters_list">
			<h1>Available Filters</h1>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="age_button" value=0>Age</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="gender_button" value=0>Gender</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="race_button" value=0>Race</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="ethnicity_button" value=0>Ethnicity</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="marital_button" value=0>Marital Status</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="conditions_button" value=0>Conditions</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="observations_button" value=0>Observations</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="medications_button" value=0>Medications</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="immunizations_button" value=0>Immunizations</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="allergies_button" value=0>Allergies</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="encounters_button" value=0>Encounters</button>
			<button type="button" class="btn btn-primary btn-space verticalButton filter" data-toggle="collapse" id="procedures_button" value=0>Procedures</button>
		</div>
		<div id="filter_logic">
			<h1>Boolean Logic</h1>
			<button type="button" class="btn btn-primary btn-space verticalButton logic" id="l_paren" value=0>(</button>
			<button type="button" class="btn btn-primary btn-space verticalButton logic" id="r_paren" value=0>)</button>
			<button type="button" class="btn btn-primary btn-space verticalButton logic" id="and_box" value=0>AND</button>
			<button type="button" class="btn btn-primary btn-space verticalButton logic" id="or_box" value=0>OR</button>
		</div>
	 </div>
  </body>
</html>
