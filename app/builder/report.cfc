<!---
Code for report builder page
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfcomponent displayname="report_builder">
	<cfparam name="session.loggedin" default="false" />
	<cfif NOT session.loggedin>
	  <cflocation url="../../index.cfm" addtoken="false">
	</cfif>
	<!--- Function to get list of observations --->
	<cffunction name="getObservations" returntype="query">
		<cfquery 
			name="observations_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT DESCRIPTION, CODE, UNITS FROM observations ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn observations_list>
	</cffunction>

	<cffunction name="getObservationsTrend" returntype="query">
		<cfquery 
			name="observations_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT DESCRIPTION, CODE, UNITS FROM observations where isnumeric(value) = 1 ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn observations_list>
	</cffunction>


	<!--- Function to get list of ethnicities --->
	<cffunction name="getEthnicities" returntype="query">
		<cfquery name="ethnicity_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT ETHNICITY FROM patients ORDER BY ETHNICITY
		</cfquery>
		<cfreturn ethnicity_list>
	</cffunction>

	<cffunction name="getTableColumns" returntype="query">
		<cfquery name="columns_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			EXEC sp_columns patients
		</cfquery>
		<cfreturn columns_list>
	</cffunction>

	<!--- Function to get list of conditions --->
	<cffunction name="getConditions" returntype="query">
		<cfquery name="condition_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM conditions ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn condition_list>
	</cffunction>
	
	<!--- Function to get list of medications --->
	<cffunction name="getMedications" returntype="query">
		<cfquery name="medication_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM medications ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn medication_list>
	</cffunction>
	
	<!--- Function to get list of immunizations --->
	<cffunction name="getImmunizations" returntype="query">
		<cfquery name="immunization_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM immunizations ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn immunization_list>
	</cffunction>
	
	<!--- Function to get list of allergies --->
	<cffunction name="getAllergies" returntype="query">
		<cfquery name="allergy_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM allergies ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn allergy_list>
	</cffunction>
	
	<!--- Function to get list of encounters --->
	<cffunction name="getEncounters" returntype="query">
		<cfquery name="encounter_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM encounters ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn encounter_list>
	</cffunction>
	
	<!--- Function to get list of procedures --->
	<cffunction name="getProcedures" returntype="query">
		<cfquery name="procedure_list"
			cachedWithin="#CreateTimeSpan(0,12,0,0)#">
			SELECT DISTINCT CODE, DESCRIPTION FROM procedures ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn procedure_list>
	</cffunction>

	<!---Output conditions dropdown menu --->
	<cffunction name="conditionsList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getConditions"
		returnvariable="allConditions"></cfinvoke>
		<cfform name="condition_filter_form">
			<cfselect
				name="condition"
				id="condition"
				query="allConditions"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select a condition"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'conditions', 'Conditions: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!--- Output observations list for filter --->
	<cffunction name="observationsList" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getObservations"
		returnvariable="allObservations"></cfinvoke>
		<cfform name="observations_filter_form" class="form-inline">
			<cfselect
				name="observations_opt"
				id="observations_opt"
				query="allObservations"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select an observation"
				class="form-control"
				onchange="observationsFilterUpdate('#id#')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
			<cfselect
				name="value_options"
				id="value_options"
				class="form-control"
				onchange="observationsFilterUpdate('#id#')">
					<option value="greater">></option>
					<option value="less"><</option>
					<option value="equal">=</option>
			</cfselect>
			<cfoutput>
			<input id="value_num" class="form-control" onchange="observationsFilterUpdate('#id#')" onkeypress="if (event.keyCode == 13){return false;}" value=0 />
			</cfoutput>
		</cfform>
	</cffunction>
	
	<!--- Output medications list --->
	<cffunction name="medicationsList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getMedications"
		returnvariable="allMedications"></cfinvoke>
		<cfform name="medication_filter_form">
			<cfselect
				name="medication_opt"
				id="medication_opt"
				query="allMedications"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select a condition"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'medications', 'Medications: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output ethnicities dropdown menu --->
	<cffunction name="ethnicitiesList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getEthnicities"
		returnvariable="allEthnicities"></cfinvoke>
		<cfform name="ethnicity_filter_form">
			<cfloop query="allEthnicities">
			<cfset ethnicity_desc = Replace(ETHNICITY, "_", " ", "ALL")  />
			<cfset ethnicity_desc = ReReplace(ethnicity_desc ,"\b(\w)","\u\1","ALL") />
				<cfoutput>
					<div class="checkbox"><label><cfinput type="checkbox" data-label="#ethnicity_desc#" name="ethnicity" value="#ETHNICITY#" onchange="checkboxFilterUpdate('#id#', 'ethnicity', 'Ethnicity: ')">#ethnicity_desc#</label></div>
				</cfoutput>
			</cfloop>
		</cfform>
	</cffunction>
	
	<!---Output immunizations dropdown menu --->
	<cffunction name="immunizationsList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getImmunizations"
		returnvariable="allImmunizations"></cfinvoke>
		<cfform name="immunization_filter_form">
			<cfselect
				name="immunization"
				id="immunization"
				query="allImmunizations"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select an immunization"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'immunizations', 'Immunizations: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output allergies dropdown menu --->
	<cffunction name="allergiesList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getAllergies"
		returnvariable="allallergies"></cfinvoke>
		<cfform name="allergy_filter_form">
			<cfselect
				name="allergy"
				id="allergy"
				query="allallergies"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select an allergy"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'allergies', 'Allergies: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output encounters dropdown menu --->
	<cffunction name="encountersList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getEncounters"
		returnvariable="allEncounters"></cfinvoke>
		<cfform name="encounter_filter_form">
			<cfselect
				name="encounter"
				id="encounter"
				query="allEncounters"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select an encounter"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'encounters', 'Encounters: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output procedures dropdown menu --->
	<cffunction name="proceduresList" returntype="void">
		<cfargument name="id" type=numeric required="true">
		<cfinvoke 	component="app.builder.report"
		method="getProcedures"
		returnvariable="allProcedures"></cfinvoke>
		<cfform name="procedure_filter_form">
			<cfselect
				name="procedure"
				id="procedure"
				query="allProcedures"
				queryPosition="below"
				value="CODE"
				display="DESCRIPTION"
				message="Select a procedure"
				class="form-control"
				onchange="dropdownFilterUpdate('#id#', 'procedures', 'Procedures: ')">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output trend graph options --->
	<cffunction name="trendOptions" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getObservationsTrend"
		returnvariable="observations_list"></cfinvoke>
		<div class="row">
			<cfform name="trend_output">
				<div class="col-sm-6">
				<cfselect
					name="trend_observation"
					id="trend_observation"
					query="observations_list"
					queryPosition="below"
					message="Select a value to graph"
					display="DESCRIPTION"
					value="CODE"
					class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
				</cfselect>
				</div>
				<div class="col-sm-4">
				<select id="trend_numbers" class="form-control">
					<option value="sum">Sum</option>
					<option value="average">Average</option>
				</select>
				</div>
			</cfform>
		</div>
		<div class="row">
			<div class="col-sm-6">
				<label>Start:</label><input class="form-control" id="trend_start_date" type="date" value="2016-01-01">
			</div>
			<div class="col-sm-4">
				<label>End:</label><input class="form-control" id="trend_end_date"  type="date" value="2016-12-31">
			</div>
		</div>

	</cffunction>

	<!---Output pie graph options --->
	<cffunction name="pieOptions" returntype="void">
		<cfform name="pie_output" id="pie_output">
			<label><cfinput type="checkbox" name="columns" value="AGE">Age</label>
			<label><cfinput type="checkbox" name="columns" value="GENDER">Gender</label>
			<label><cfinput type="checkbox" name="columns" value="RACE">Race</label>
			<label><cfinput type="checkbox" name="columns" value="ETHNICITY">Ethnicity</label>
			<label><cfinput type="checkbox" name="columns" value="MARITAL">Marital Status</label>
		</cfform>
	</cffunction>
	
	<!---Output donut graph options --->
	<cffunction name="doughnutOptions" returntype="void">
		<cfform name="doughnut_output">
			<label><cfinput type="checkbox" name="columns" value="AGE">Age</label>
			<label><cfinput type="checkbox" name="columns" value="GENDER">Gender</label>
			<label><cfinput type="checkbox" name="columns" value="RACE">Race</label>
			<label><cfinput type="checkbox" name="columns" value="ETHNICITY">Ethnicity</label>
			<label><cfinput type="checkbox" name="columns" value="MARITAL">Marital Status</label>
		</cfform>
	</cffunction>

	<!---Output Data table options --->
	<cffunction name="dataOptions" returntype="void">
		<cfform name="data_output" id="data_output">
			<label><cfinput type="checkbox" name="columns" value="ID">Patient ID</label>
			<label><cfinput type="checkbox" name="columns" value="PREFIX">Prefix</label>
			<label><cfinput type="checkbox" name="columns" value="FIRST">First Name</label>
			<label><cfinput type="checkbox" name="columns" value="LAST">Last Name</label>
			<label><cfinput type="checkbox" name="columns" value="SUFFIX">Suffix</label>
			<label><cfinput type="checkbox" name="columns" value="MAIDEN">Maiden Name</label>
			<label><cfinput type="checkbox" name="columns" value="BIRTHDATE">Birth Date</label>
			<label><cfinput type="checkbox" name="columns" value="DEATHDATE">Death Date</label>
			<label><cfinput type="checkbox" name="columns" value="ADDRESS">Address</label>
			<label><cfinput type="checkbox" name="columns" value="SSN">Social Security Number</label>
			<label><cfinput type="checkbox" name="columns" value="DRIVERS">Driver's License Number</label>
			<label><cfinput type="checkbox" name="columns" value="PASSPORT">Passport Number</label>
			<label><cfinput type="checkbox" name="columns" value="GENDER">Gender</label>
			<label><cfinput type="checkbox" name="columns" value="RACE">Race</label>
			<label><cfinput type="checkbox" name="columns" value="ETHNICITY">Ethnicity</label>
			<label><cfinput type="checkbox" name="columns" value="MARITAL">Marital Status</label>


		</cfform>
	</cffunction>
	
	<!---Output bar chart options --->
	<cffunction name="barOptions" returntype="void">
		<cfform name="bar_output" id="bar_output">
			<label><cfinput type="checkbox" name="columns" value="AGE">Age</label>
			<label><cfinput type="checkbox" name="columns" value="GENDER">Gender</label>
			<label><cfinput type="checkbox" name="columns" value="RACE">Race</label>
			<label><cfinput type="checkbox" name="columns" value="ETHNICITY">Ethnicity</label>
			<label><cfinput type="checkbox" name="columns" value="MARITAL">Marital Status</label>
		</cfform>
	</cffunction>

	<!--- get report query json string using report id --->
	<cffunction name="getreportQuery" returntype="void" access="remote">
		<cfargument name="id" type=numeric required="true">
		<cfquery name="report_data" datasource="MEDICALDATA">
			SELECT query_string FROM saved_reports WHERE id=<cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfoutput>#report_data.query_string#</cfoutput>
	</cffunction>

	<!--- get report type json string using report id --->
	<cffunction name="getreportType" returntype="void" access="remote">
		<cfargument name="id" type=numeric required="true">
		<cfquery name="report_data" datasource="MEDICALDATA">
			SELECT report_type_string FROM saved_reports WHERE id=<cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfoutput>#report_data.report_type_string#</cfoutput>
	</cffunction>

	<cffunction name="getreportInfo" returntype="void" access="remote">
		<cfargument name="id" type=numeric required="true">
		<cfquery name="report_data" datasource="MEDICALDATA">
			SELECT * FROM saved_reports WHERE id=<cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfoutput>
			<div>
				<p>Report name: #report_data.name#</p>
				<p>Report description: #report_data.description#</p>
				<cfset report_type = "#deserializeJSON(report_data.report_type_string).type#" />
				<cfset report_json = deserializeJSON(#report_data.report_type_string#) />
				<cfif report_type EQ "trend">
					<cfquery name="observation_name" datasource="MEDICALDATA">
						SELECT DISTINCT DESCRIPTION FROM observations WHERE CODE = '#report_json["observation_id"]#'
					</cfquery>
					<p>Report type: Trend Graph</p>
					<p>Observation: #observation_name.DESCRIPTION#</p>
					<p>Total values: #report_json["options"]#</p>
					<p>Start Date: #report_json["start_date"]#</p>
					<p>End Date: #report_json["end_date"]#</p>
				<cfelseif report_type EQ "bar">
					<p>Report type: Bar Chart</p>
					<p> Group by:
					<cfscript>
						WriteOutput(ArrayToList(#report_json["group_by"]#))
					</cfscript></p>
				<cfelseif report_type EQ "pie">
					<p>Report type: Pie Chart</p>
					<p> Group by:
					<cfscript>
						WriteOutput(ArrayToList(#report_json["group_by"]#))
					</cfscript></p>
				<cfelseif report_type EQ "doughnut">
					<p>Report type: Doughnut Chart</p>
					<p> Group by:
					<cfscript>
						WriteOutput(ArrayToList(#report_json["group_by"]#))
					</cfscript></p>
				<cfelseif report_type EQ "data">
					<p>Report type: Data Table</p>
					<p> Group by:
					<cfscript>
						WriteOutput(ArrayToList(#report_json["group_by"]#))
					</cfscript></p>
				</cfif>
				<p>Report query: 
				<cfloop array="#deserializeJSON(report_data.query_string)#" index="idx">
					<cfif #idx.type# eq "filter_string">
						<td>#idx.string#</td>
					</cfif>
				</cfloop>
				</p>
			</div>
		</cfoutput>
	</cffunction>

	<!--- function to save a report to the saved_reports table in the DB --->
	<cffunction name="saveReport" returntype="void" access="remote">
		<cfargument name="name" type="string" required="true">
		<cfargument name="report_id" type="numeric" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="query_string" type="string" required="true">
		<cfargument name="report_type_string" type="string" required="true">
		<cfif arguments.report_id EQ 0>
			<cftry>
				<cfquery name="report_data" datasource="MEDICALDATA">
					INSERT INTO saved_reports(name, description, query_string, report_type_string, username)
					VALUES (<cfqueryparam value='#decodefromUrl(arguments.name)#' cfsqltype="CF_SQL_NVARCHAR">, 
						<cfqueryparam value='#decodefromUrl(arguments.description)#' cfsqltype="CF_SQL_NVARCHAR">, 
						<cfqueryparam value='#decodefromUrl(arguments.query_string)#' cfsqltype="CF_SQL_NVARCHAR">, 
						<cfqueryparam value='#decodefromUrl(arguments.report_type_string)#' cfsqltype="CF_SQL_NVARCHAR">, 
						'#session.username#' )
				</cfquery>
				<cfoutput>true</cfoutput>
			<cfcatch>
				<cfoutput>false</cfoutput>
			</cfcatch>
			</cftry>
		<cfelse>
			<cftry>
				<cfquery name="report_data" datasource="MEDICALDATA">
					UPDATE saved_reports
					SET name = <cfqueryparam value='#decodefromUrl(arguments.name)#' cfsqltype="CF_SQL_NVARCHAR">, 
					description = <cfqueryparam value='#decodefromUrl(arguments.description)#' cfsqltype="CF_SQL_NVARCHAR">, 
					query_string = <cfqueryparam value='#decodefromUrl(arguments.query_string)#' cfsqltype="CF_SQL_NVARCHAR">, 
					report_type_string = <cfqueryparam value='#decodefromUrl(arguments.report_type_string)#' cfsqltype="CF_SQL_NVARCHAR">
					WHERE id = <cfqueryparam value='#arguments.report_id#' cfsqltype="CF_SQL_INTEGER">
				</cfquery>
				<cfoutput>true</cfoutput>
			<cfcatch>
				<cfoutput>false</cfoutput>
			</cfcatch>
			</cftry>

		</cfif>
	</cffunction>

	<!--- function to share a report by saving to the shared_reports table in the DB --->
	<cffunction name="shareReport" returntype="void" access="remote">
		<cfargument name="id" type="numeric" required="true">
		<cfargument name="shared_with" type="string" required="true">
		<cftry>
			<cfquery name="report_data" datasource="MEDICALDATA">
				INSERT INTO shared_reports(report_id, shared_with)
				VALUES (<cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER">, 
					<cfqueryparam value='#decodefromUrl(arguments.shared_with)#' cfsqltype="CF_SQL_NVARCHAR"> )
			</cfquery>
			<cfoutput>true</cfoutput>
		<cfcatch>
			<cfoutput>false</cfoutput>
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="deleteReport" returntype="void" access="remote">
		<cfargument name="id" type="numeric" required="true">
		<cftry>
			<!--- only allow the delete if the user is the report owner --->
			<cfquery name="delete_report_shares" datasource="MEDICALDATA">
				DELETE FROM shared_reports WHERE report_id IN 
				( SELECT id FROM saved_reports WHERE id = <cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER"> 
					AND username = '#session.username#' )
			</cfquery>
			<cfquery name="delete_report" datasource="MEDICALDATA">
				DELETE FROM saved_reports WHERE id = <cfqueryparam value='#arguments.id#' cfsqltype="CF_SQL_INTEGER"> and username = '#session.username#'
			</cfquery>
			<cfoutput>true</cfoutput>
		<cfcatch>
			<cfoutput>false</cfoutput>
		</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>