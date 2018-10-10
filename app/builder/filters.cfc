<!--- Code to print out filters. Will be accessed using AJAX 

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfcomponent>
	<cffunction name="getFilterForm" access="remote" returntype="void">
		<cfargument name="filter" type="string" required="yes">
			<!--- Age --->
			<cfif arguments.filter eq "age">
				<div id="age_filter">
					<h2>Age filter</h2>
					<form class="form-inline">
						<label for="age_min">Between</label>
						<input type="number" id="age_min" min="0" max="120" step="1" value="20" class="form-control">
						<label for="age_max">and</label>
						<input type="number" id="age_max" min="0" max="120" step="1" value="50" class="form-control">
					</form>
				</div>

			<!--- Gender --->
			<cfelseif arguments.filter eq "gender">
				<div id="gender_filter">
					<h2>Gender filter</h2>
					<div id="gender_options" class="checkbox">
						<label><input type="checkbox" name="gender" value="M">Male</label>
						<label><input type="checkbox" name="gender" value="F">Female</label>
					</div>
				</div>
			
			<!--- Race filter --->
			<cfelseif arguments.filter eq "race">
				<div id="race_filter">
					<h2>Race filter</h2>
					<div id="race_options" class="checkbox">
						<label><input type="checkbox" name="race" value="white">White</label>
						<label><input type="checkbox" name="race" value="black">Black</label>
						<label><input type="checkbox" name="race" value="asian">Asian</label>
						<label><input type="checkbox" name="race" value="hispanic">Hispanic</label>
					</div>
				</div>
			
			<!--- Ethnicity filter --->
			<cfelseif arguments.filter eq "ethnicity">
				<div id="ethnicity_filter">
					<h2>Ethnicity filter</h2>
					<div id="ethnicity_options" class="checkbox">
						<cfinvoke component="app.builder.report" method="ethnicitiesList"></cfinvoke>
					</div>
				</div>
			
			<!--- Marital status filter --->
			<cfelseif arguments.filter eq "marital">
				<div id="marital_filter">
					<h2>Marital Status filter</h2>
					<div id="marital_options" class="checkbox">
						<label><input type="checkbox" name="marital" value="S">Single</label>
						<label><input type="checkbox" name="marital" value="M">Married</label>
					</div>
				</div>
			
			<!--- Observations filter --->
			<cfelseif arguments.filter eq "conditions">
				<div id="conditions_filter">
					<h2>Conditions filter</h2>
					<div style="width: 50%">
						<cfinvoke component="app.builder.report" method="conditionsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Observations filter --->
			<cfelseif arguments.filter eq "observations">
				<div id="observations_filter">
					<h2>Observations filter</h2>
					<div style="width: 50%">
						<cfinvoke component="app.builder.report" method="observationsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Medications filter --->
			<cfelseif arguments.filter eq "medications">
				<div id="medications_filter">
					<h2>Medications filter</h2>
					<div style="width: 50%">
						<cfinvoke component="app.builder.report" method="medicationsList"></cfinvoke>
					</div>
				</div>
			</cfif>
	</cffunction>
</cfcomponent>