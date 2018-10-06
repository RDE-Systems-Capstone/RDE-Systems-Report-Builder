<cfcomponent displayname="report_builder">
	<!--- Function to get list of observations --->
	<cffunction name="getObservations" returntype="query">
		<cfquery name="observations_list">
			SELECT DISTINCT DESCRIPTION, CODE FROM observations ORDER BY DESCRIPTION
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
		<cfform>
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
		<cfform>
			<cfloop query="allEthnicities">
				<cfset ethnicity_desc="#reReplace('#ETHNICITY#',"(^[a-z])","\U\1","ALL")#">
				<cfset ethnicity_desc="#Replace('#ethnicity_desc#',"_"," ","all")#">
				<cfoutput>
					<label><cfinput type="checkbox" name="ethnicity" value="#ETHNICITY#">#ethnicity_desc#</label>
				</cfoutput>
			</cfloop>
		</cfform>
	</cffunction>
	
</cfcomponent>