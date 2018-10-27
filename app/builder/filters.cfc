<!--- Code to print out filters. Will be accessed using AJAX 

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfcomponent>
	<cfparam name="session.loggedin" default="false" />
	<cfif NOT session.loggedin>
	  <cflocation url="../../index.cfm" addtoken="false">
	</cfif>
	<cffunction name="getFilterForm" access="remote" returntype="void">
		<cfargument name="filter" type="string" required="yes">
			<!--- Age --->
			<cfif arguments.filter eq "age">
				<div id="age_filter">
					<cfoutput><form class="form-inline collapse filter-collapse" id="#arguments.id#">
						<h2>Age filter</h2>
						<label for="age_min">Between</label>
						<input type="number" id="age_min" min="0" max="120" step="1" value="20" class="form-control" onchange="ageFilterUpdate('#arguments.id#')" />
						<label for="age_max">and</label>
						<input type="number" id="age_max" min="0" max="120" step="1" value="50" class="form-control" onchange="ageFilterUpdate('#arguments.id#')" />
					</form></cfoutput>
				</div>

			<!--- Gender --->
			<cfelseif arguments.filter eq "gender">
				<div id="gender_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse checkbox">
						<h2>Gender filter</h2>
						<label><input type="checkbox" name="gender" value="M" onchange="checkboxFilterUpdate('#arguments.id#', 'gender', 'Gender: ')" />Male</label>
						<label><input type="checkbox" name="gender" value="F" onchange="checkboxFilterUpdate('#arguments.id#', 'gender', 'Gender: ')" />Female</label>
					</div></cfoutput>
				</div>
			
			<!--- Race filter --->
			<cfelseif arguments.filter eq "race">
				<div id="race_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse checkbox">
						<h2>Race filter</h2>
						<label><input type="checkbox" name="race" value="white" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />White</label>
						<label><input type="checkbox" name="race" value="black" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Black</label>
						<label><input type="checkbox" name="race" value="asian" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Asian</label>
						<label><input type="checkbox" name="race" value="hispanic" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Hispanic</label>
					</div></cfoutput>
				</div>
			
			<!--- Ethnicity filter --->
			<cfelseif arguments.filter eq "ethnicity">
				<div id="ethnicity_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse checkbox"></cfoutput>
						<h2>Ethnicity filter</h2>
						<cfinvoke component="app.builder.report" method="ethnicitiesList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
			
			<!--- Marital status filter --->
			<cfelseif arguments.filter eq "marital">
				<div id="marital_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse checkbox">
						<h2>Marital Status filter</h2>
						<label><input type="checkbox" name="marital" value="S" onchange="checkboxFilterUpdate('#arguments.id#', 'marital', 'Marital Status: ')" />Single</label>
						<label><input type="checkbox" name="marital" value="M" onchange="checkboxFilterUpdate('#arguments.id#', 'marital', 'Marital Status: ')" />Married</label>
					</div></cfoutput>
				</div>
			
			<!--- Conditions filter --->
			<cfelseif arguments.filter eq "conditions">
				<div id="conditions_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 100%"></cfoutput>
						<h2>Conditions filter</h2>
						<cfinvoke component="app.builder.report" method="conditionsList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
				
			<!--- Observations filter --->
			<cfelseif arguments.filter eq "observations">
				<div id="observations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 100%"></cfoutput>
						<h2>Observations filter</h2>
						<cfinvoke component="app.builder.report" method="observationsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Medications filter --->
			<cfelseif arguments.filter eq "medications">
				<div id="medications_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h2>Medications filter</h2>
						<cfinvoke component="app.builder.report" method="medicationsList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
				
			<!--- Immunizations filter --->
			<cfelseif arguments.filter eq "immunizations">
				<div id="immunizations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h2>Immunizations filter</h2>
						<cfinvoke component="app.builder.report" method="immunizationsList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
				
			<!--- allergies filter --->
			<cfelseif arguments.filter eq "allergies">
				<div id="allergies_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h2>Allergies filter</h2>
						<cfinvoke component="app.builder.report" method="allergiesList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
				
			<!--- encounters filter --->
			<cfelseif arguments.filter eq "encounters">
				<div id="encounters_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h2>Encounters filter</h2>
						<cfinvoke component="app.builder.report" method="encountersList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
				
			<!--- procedures filter --->
			<cfelseif arguments.filter eq "procedures">
				<div id="procedures_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h2>Procedures filter</h2>
						<cfinvoke component="app.builder.report" method="proceduresList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
			</cfif>
	</cffunction>
</cfcomponent>