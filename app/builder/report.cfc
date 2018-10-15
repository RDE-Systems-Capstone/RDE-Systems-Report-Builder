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
				class="form-control">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
			<cfselect
				name="value_options"
				id="value_options"
				class="form-control">
					<option value="greater">></option>
					<option value="less"><</option>
					<option value="equal">=</option>
			</cfselect>
			<input id="value_num" type="number" class="form-control" />
		</cfform>
	</cffunction>
	
	<!--- Output medications list --->
	<cffunction name="medicationsList" returntype="void">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output ethnicities dropdown menu --->
	<cffunction name="ethnicitiesList" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getEthnicities"
		returnvariable="allEthnicities"></cfinvoke>
		<cfform name="ethnicity_filter_form">
			<cfloop query="allEthnicities">
				<cfset ethnicity_desc="#reReplace('#ETHNICITY#',"(^[a-z])","\U\1","ALL")#">
				<cfset ethnicity_desc="#Replace('#ethnicity_desc#',"_"," ","all")#">
				<cfoutput>
					<label><cfinput type="checkbox" name="ethnicity" value="#ETHNICITY#">#ethnicity_desc#</label>
				</cfoutput>
			</cfloop>
		</cfform>
	</cffunction>
	
	<!---Output immunizations dropdown menu --->
	<cffunction name="immunizationsList" returntype="void">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output allergies dropdown menu --->
	<cffunction name="allergiesList" returntype="void">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output encounters dropdown menu --->
	<cffunction name="encountersList" returntype="void">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>
	
	<!---Output procedures dropdown menu --->
	<cffunction name="proceduresList" returntype="void">
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
				class="form-control">
					<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output trend graph options --->
	<cffunction name="trendOptions" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getObservations"
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

	<!---Output pie/donut graph options --->
	<cffunction name="pieOptions" returntype="void">
		<cfform name="pie_output">
			<cfselect
				name="pie_group"
				id="pie_group"
				message="Select a group"
				class="form-control">
				<option selected="true" disabled="disabled"> -- select an option -- </option>
				<option value="age">Age</option>
				<option value="gender">Gender</option>
				<option value="race">Race</option>
				<option value="ethnicity">Ethnicity</option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output Data table options --->
	<cffunction name="dataOptions" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getTableColumns"
		returnvariable="columns_list"></cfinvoke>
		<cfform name="data_output">
			<cfloop query="#columns_list#">
				<cfoutput>
					<label><cfinput type="checkbox" name="columns" value="#COLUMN_NAME#">#COLUMN_NAME#</label>
				</cfoutput>
			</cfloop>
		</cfform>
	</cffunction>
	
	<!---Output bar chart options --->
	<cffunction name="barOptions" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getTableColumns"
		returnvariable="columns_list"></cfinvoke>
		<cfform name="bar_output">
			<cfloop query="#columns_list#">
				<cfoutput>
					<label><cfinput type="checkbox" name="columns" value="#COLUMN_NAME#">#COLUMN_NAME#</label>
				</cfoutput>
			</cfloop>
		</cfform>
	</cffunction>

</cfcomponent>