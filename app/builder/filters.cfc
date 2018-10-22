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
					<cfoutput><form class="form-inline collapse" id="#arguments.id#"></cfoutput>
						<h2>Age filter</h2>
						<label for="age_min">Between</label>
						<input type="number" id="age_min" min="0" max="120" step="1" value="20" class="form-control" <cfoutput>onchange="ageFilterUpdate('#arguments.id#')"</cfoutput> />
						<label for="age_max">and</label>
						<input type="number" id="age_max" min="0" max="120" step="1" value="50" class="form-control" <cfoutput>onchange="ageFilterUpdate('#arguments.id#')"</cfoutput> />
					</form>
				</div>

			<!--- Gender --->
			<cfelseif arguments.filter eq "gender">
				<div id="gender_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse checkbox"></cfoutput>
						<h2>Gender filter</h2>
						<label><input type="checkbox" name="gender" value="M" <cfoutput>onchange="genderFilterUpdate('#arguments.id#')"</cfoutput> />Male</label>
						<label><input type="checkbox" name="gender" value="F" <cfoutput>onchange="genderFilterUpdate('#arguments.id#')"</cfoutput> />Female</label>
					</div>
				</div>
			
			<!--- Race filter --->
			<cfelseif arguments.filter eq "race">
				<div id="race_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse checkbox"></cfoutput>
						<h2>Race filter</h2>
						<label><input type="checkbox" name="race" value="white" <cfoutput>onchange="raceFilterUpdate('#arguments.id#')"</cfoutput> />White</label>
						<label><input type="checkbox" name="race" value="black" <cfoutput>onchange="raceFilterUpdate('#arguments.id#')"</cfoutput> />Black</label>
						<label><input type="checkbox" name="race" value="asian" <cfoutput>onchange="raceFilterUpdate('#arguments.id#')"</cfoutput> />Asian</label>
						<label><input type="checkbox" name="race" value="hispanic" <cfoutput>onchange="raceFilterUpdate('#arguments.id#')"</cfoutput> />Hispanic</label>
					</div>
				</div>
			
			<!--- Ethnicity filter --->
			<cfelseif arguments.filter eq "ethnicity">
				<div id="ethnicity_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse checkbox"></cfoutput>
						<h2>Ethnicity filter</h2>
						<cfinvoke component="app.builder.report" method="ethnicitiesList" id="#arguments.id#"></cfinvoke>
					</div>
				</div>
			
			<!--- Marital status filter --->
			<cfelseif arguments.filter eq "marital">
				<div id="marital_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse checkbox"></cfoutput>
						<h2>Marital Status filter</h2>
						<label><input type="checkbox" name="marital" value="S" <cfoutput>onchange="maritalFilterUpdate('#arguments.id#')"</cfoutput> />Single</label>
						<label><input type="checkbox" name="marital" value="M" <cfoutput>onchange="maritalFilterUpdate('#arguments.id#')"</cfoutput> />Married</label>
					</div>
				</div>
			
			<!--- Conditions filter --->
			<cfelseif arguments.filter eq "conditions">
				<div id="conditions_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 100%"></cfoutput>
						<h2>Conditions filter</h2>
						<cfinvoke component="app.builder.report" method="conditionsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Observations filter --->
			<cfelseif arguments.filter eq "observations">
				<div id="observations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 100%"></cfoutput>
						<h2>Observations filter</h2>
						<cfinvoke component="app.builder.report" method="observationsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Medications filter --->
			<cfelseif arguments.filter eq "medications">
				<div id="medications_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 50%"></cfoutput>
						<h2>Medications filter</h2>
						<cfinvoke component="app.builder.report" method="medicationsList"></cfinvoke>
					</div>
				</div>
				
			<!--- Immunizations filter --->
			<cfelseif arguments.filter eq "immunizations">
				<div id="immunizations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 50%"></cfoutput>
						<h2>Immunizations filter</h2>
						<cfinvoke component="app.builder.report" method="immunizationsList"></cfinvoke>
					</div>
				</div>
				
			<!--- allergies filter --->
			<cfelseif arguments.filter eq "allergies">
				<div id="allergies_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 50%"></cfoutput>
						<h2>Allergies filter</h2>
						<cfinvoke component="app.builder.report" method="allergiesList"></cfinvoke>
					</div>
				</div>
				
			<!--- encounters filter --->
			<cfelseif arguments.filter eq "encounters">
				<div id="encounters_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 50%"></cfoutput>
						<h2>Encounters filter</h2>
						<cfinvoke component="app.builder.report" method="encountersList"></cfinvoke>
					</div>
				</div>
				
			<!--- procedures filter --->
			<cfelseif arguments.filter eq "procedures">
				<div id="procedures_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse" style="width: 50%"></cfoutput>
						<h2>Procedures filter</h2>
						<cfinvoke component="app.builder.report" method="proceduresList"></cfinvoke>
					</div>
				</div>
			</cfif>
	</cffunction>
</cfcomponent>