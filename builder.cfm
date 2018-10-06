<!--
Code for report builder page
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
-->

<cfinvoke 	component="app.builder.report" 
			method="getObservations"
			returnvariable="allObservations"></cfinvoke>
<cfinvoke 	component="app.builder.report" 
			method="getEthnicities"
			returnvariable="allEthnicities"></cfinvoke>
<cfinvoke 	component="app.builder.report" 
			method="getConditions"
			returnvariable="allConditions"></cfinvoke>


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
			<li class="active"><a href="#">Builder</a></li>
			<li><a href="#">Output</a></li>
			<li><a href="#">Saved Reports</a></li>
		</ul>
	  </div>
	</nav>
	
	<!-- left column code-->
	<div class="col-lg-10">
	  <h1>Report Builder</h1>
		<div class="form-group" style="width: 50%">
			<cfform name="report_type_form">
				<cfselect 
					name="report_type"
					message="Select a type of report"
					class="form-control">
						<option selected="true" disabled="disabled"> -- select an option -- </option>
						<option value="trend">Trend Graph</option>
						<option value="pie">Pie/Doughnut Chart</option>
						<option value="bar">Bar Chart</option>
						<option value="table">Data Table</option>
				</cfselect>
			</cfform>
		</div>
		
		
		<!-- filters will be dragged here
		as we add filters, JS code will make the filters unhidden-->
		<h1>Filters</h1>
		<div class="filter_drop well">
			<p>Drag and drop filters here to add them.</p>
				<!-- Age filter -->
				<div hidden id="age_filter">
					<h2>Age filter</h2>
					<form class="form-inline">
						<label for="age_min">Between</label>
						<input type="number" name="age_min" min="0" max="120" step="1" value="20" class="form-control">
						<label for="age_max">and</label>
						<input type="number" name="age_max" min="0" max="120" step="1" value="50" class="form-control">
					</form>
				</div>
				<!-- Gender filter -->
				<div hidden id="gender_filter">
					<h2>Gender filter</h2>
					<div class="checkbox">
						<label><input type="checkbox" name="gender" value="M">Male</label>
						<label><input type="checkbox" name="gender" value="F">Female</label>
					</div>
				</div>
				<!-- Race filter -->
				<div hidden id="race_filter">
					<h2>Race filter</h2>
					<div class="checkbox">
						<label><input type="checkbox" name="race" value="white">White</label>
						<label><input type="checkbox" name="race" value="black">Black</label>
						<label><input type="checkbox" name="race" value="asian">Asian</label>
						<label><input type="checkbox" name="race" value="hispanic">Hispanic</label>
					</div>
				</div>
				<div hidden id="ethnicity_filter">
					<h2>Ethnicity filter</h2>
					<div class="checkbox">
						<cfinvoke component="app.builder.report" method="ethnicitiesList"></cfinvoke>
					</div>
				</div>
				<div hidden id="marital_filter">
					<h2>Marital Status filter</h2>
					<input type="checkbox" name="marital" value="S"> Single<br>
					<input type="checkbox" name="marital" value="M"> Married<br>
				</div>
				<div hidden id="conditions_filter">
					<h2>Conditions filter</h2>
					<div class="checkbox">
						<cfinvoke component="app.builder.report" method="conditionsList"></cfinvoke>
					</div>
				</div>
			</div>
		
		<h1>Output</h1>
		<div id="output" style="width: 50%">
			<!-- Will be dynamically populated with JS -->
			<p>Select a report type to continue.</p>
		</div>
		<br />
		<div>
		<button type="button" class="btn btn-primary">Submit</button>
		</div>
	 </div>
	
	<!-- Available filters column code-->
	 <div class="col-lg-2">
	  <h1>Available Filters</h1>
	  <button type="button" class="btn verticalButton" id="age_button">Age</button>
	  <button type="button" class="btn verticalButton" id="gender_button">Gender</button>
	  <button type="button" class="btn verticalButton" id="race_button">Race</button>
	  <button type="button" class="btn verticalButton" id="ethnicity_button">Ethnicity</button>
	  <button type="button" class="btn verticalButton" id="marital_button">Marital Status</button>
	  <button type="button" class="btn verticalButton" id="conditions_button">Conditions</button>
	  <button type="button" class="btn verticalButton" id="observations_button">Observations</button>
	 </div>

  </body>
</html>
