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
					<cfoutput><div class="collapse filter-collapse" id="#arguments.id#">
					<h3>Age filter options:</h3>
					<label for="slider#arguments.id#" id="amount#arguments.id#"></label>
					<div id="slider#arguments.id#" style="width: 40%"></div>
					<br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button>
					</div></cfoutput>
				</div>

			<!--- Gender --->
			<cfelseif arguments.filter eq "gender">
				<div id="gender_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse">
						<h3>Gender filter options:</h3>
						<div class="checkbox"><label><input type="checkbox" name="gender" value="M" data-label="Male" onchange="checkboxFilterUpdate('#arguments.id#', 'gender', 'Gender: ')" />Male</label></div>
						<div class="checkbox"><label><input type="checkbox" name="gender" value="F" data-label="Female" onchange="checkboxFilterUpdate('#arguments.id#', 'gender', 'Gender: ')" />Female</label></div>
						<button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button>
					</div></cfoutput>
				</div>
			
			<!--- Race filter --->
			<cfelseif arguments.filter eq "race">
				<div id="race_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse">
						<h3>Race filter options:</h3>
						<div class="checkbox"><label><input type="checkbox" name="race" data-label="White" value="white" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />White</label></div>
						<div class="checkbox"><label><input type="checkbox" name="race" data-label="Black" value="black" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Black</label></div>
						<div class="checkbox"><label><input type="checkbox" name="race" data-label="Asian" value="asian" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Asian</label></div>
						<div class="checkbox"><label><input type="checkbox" name="race" data-label="Hispanic" value="hispanic" onchange="checkboxFilterUpdate('#arguments.id#', 'race', 'Race: ')" />Hispanic</label></div>
						<button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button>
					</div></cfoutput>
				</div>
			
			<!--- Ethnicity filter --->
			<cfelseif arguments.filter eq "ethnicity">
				<div id="ethnicity_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse"></cfoutput>
						<h3>Ethnicity filter options:</h3>
						<cfinvoke component="app.builder.report" method="ethnicitiesList" id="#arguments.id#"></cfinvoke>
						<cfoutput><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
			
			<!--- Marital status filter --->
			<cfelseif arguments.filter eq "marital">
				<div id="marital_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse">
						<h2>Marital Status filter</h2>
						<div class="checkbox"><label><input type="checkbox" name="marital" value="S" data-label="Single" onchange="checkboxFilterUpdate('#arguments.id#', 'marital', 'Marital Status: ')" />Single</label></div>
						<div class="checkbox"><label><input type="checkbox" name="marital" value="M" data-label="Married" onchange="checkboxFilterUpdate('#arguments.id#', 'marital', 'Marital Status: ')" />Married</label></div>
						<button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button>
					</div></cfoutput>
				</div>
			
			<!--- Conditions filter --->
			<cfelseif arguments.filter eq "conditions">
				<div id="conditions_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Conditions filter options:</h3>
						<cfinvoke component="app.builder.report" method="conditionsList" id="#arguments.id#"></cfinvoke>
						<cfoutput><br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- Observations filter --->
			<cfelseif arguments.filter eq "observations">
				<div id="observations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 100%"></cfoutput>
						<h3>Observations filter options:</h3>
						<cfinvoke component="app.builder.report" method="observationsList"></cfinvoke>
						<cfoutput><br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- Medications filter --->
			<cfelseif arguments.filter eq "medications">
				<div id="medications_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Medications filter options:</h3>
						<cfinvoke component="app.builder.report" method="medicationsList" id="#arguments.id#"></cfinvoke>
						<cfoutput><br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- Immunizations filter --->
			<cfelseif arguments.filter eq "immunizations">
				<div id="immunizations_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Immunizations filter options:</h3>
						<cfinvoke component="app.builder.report" method="immunizationsList" id="#arguments.id#"></cfinvoke>
						<cfoutput><br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- allergies filter --->
			<cfelseif arguments.filter eq "allergies">
				<div id="allergies_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Allergies filter options:</h3>
						<cfinvoke component="app.builder.report" method="allergiesList" id="#arguments.id#"></cfinvoke>
						<cfoutput><br /><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- encounters filter --->
			<cfelseif arguments.filter eq "encounters">
				<div id="encounters_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Encounters filter options:</h3>
						<cfinvoke component="app.builder.report" method="encountersList" id="#arguments.id#"></cfinvoke>
						<cfoutput><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>
				
			<!--- procedures filter --->
			<cfelseif arguments.filter eq "procedures">
				<div id="procedures_filter">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse" style="width: 50%"></cfoutput>
						<h3>Procedures filter options:</h3>
						<cfinvoke component="app.builder.report" method="proceduresList" id="#arguments.id#"></cfinvoke>
						<cfoutput><button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button></cfoutput>
					</div>
				</div>

			<!--- logical operator options --->
			<cfelseif arguments.filter eq "logic">
				<div id="logic_options">
					<cfoutput><div id="#arguments.id#"  class="collapse filter-collapse checkbox">
						<h3>Logical operator options:</h3>
						<button type="button" class="btn btn-danger" onclick="deleteFilter('#arguments.id#')">Delete filter</button>
					</div></cfoutput>
				</div>	
			</cfif>
	</cffunction>
</cfcomponent>