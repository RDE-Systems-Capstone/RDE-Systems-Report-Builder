<cfcomponent displayname="report_builder">
	<!--- Function to get list of observations --->
	<cffunction name="getObservations" returntype="query">
		<cfquery name="observations_list">
			SELECT DISTINCT DESCRIPTION, CODE, UNITS FROM observations ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn observations_list>
	</cffunction>

	<!--- Function to get list of ethnicities --->
	<cffunction name="getEthnicities" returntype="query">
		<cfquery name="ethnicity_list">
			SELECT DISTINCT ETHNICITY FROM patients ORDER BY ETHNICITY
		</cfquery>
		<cfreturn ethnicity_list>
	</cffunction>

	<cffunction name="getTableColumns" returntype="query">
		<cfquery name="columns_list">
			EXEC sp_columns patients
		</cfquery>
		<cfreturn columns_list>
	</cffunction>

	<!--- Function to get list of conditions --->
	<cffunction name="getConditions" returntype="query">
		<cfquery name="condition_list">
			SELECT DISTINCT CODE, DESCRIPTION FROM conditions ORDER BY DESCRIPTION
		</cfquery>
		<cfreturn condition_list>
	</cffunction>

	<!---Output conditions dropdown menu --->
	<cffunction name="conditionsList" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getConditions"
		returnvariable="allConditions"></cfinvoke>
		<cfform name="condition_filter_form">
			<cfselect
				name="condition"
				query="allConditions"
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

	<!---Output trend graph options --->
	<cffunction name="trendOptions" returntype="void">
		<cfinvoke 	component="app.builder.report"
		method="getObservations"
		returnvariable="observations_list"></cfinvoke>
		<cfform name="trend_output">
				<cfselect
				name="trend_observation"
				query="observations_list"
				message="Select a value to graph"
				display="DESCRIPTION"
				value="CODE"
				class="form-control">
				<option selected="true" disabled="disabled"> -- select an option -- </option>
			</cfselect>
		</cfform>
	</cffunction>

	<!---Output pie/donut graph options --->
	<cffunction name="pieOptions" returntype="void">
		<cfform name="pie_output">
			<cfselect
				name="pie_group"
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

</cfcomponent>