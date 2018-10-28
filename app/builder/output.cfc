<cfcomponent displayname="report_builder">
	<!--- Function generateSQLQuery takes in the JSON array from the report builder page and generates an array of queries to obtain the data required --->
	<cffunction name="generateSQLQuery" returntype="array">
		<cfargument name="FilterBool" type="array" required="true"/>
		<!--- New array to store the queries generated --->
		<cfset queries= ArrayNew(1)>
		<cfset i = 1 />
		<cfloop array = #FilterBool# item="item" >
			<!--  checking paramters -->
			<!--- age --->
			<cfif #item["type"]# == "age">
			 	<cfset  atype = "age">
				<cfset age_min= #item["min"]#>
				<cfset age_max= #item["max"]#>
				 <cfset MEDICALDATA = ageFunc(min = #age_min#, max = #age_max# )/>

				 <cfoutput >
				 	<cfset queries[i]=  "(  #MEDICALDATA#  ) " > 
				 </cfoutput>
			</cfif>  

			<!--- Gender --->
			<cfif #item["type"]# == "gender">
			 	<cfset  atype = "gender">
			     <cfset var= #item["values"]#>

				<cfloop array =#var# item = "value" index = "name">
					<cfset variable = #value#>
				</cfloop>
				
				 <cfset MEDICALDATA = patientFunc(atype= #atype#, variable = #variable# )/>
				 <cfoutput>
				 	<cfset queries[i]=  "(  #MEDICALDATA#  ) " > 
				 </cfoutput>
			</cfif>
			
			<!--- Race filter --->
			<cfif #item["type"]# == "race">
			 	<cfset  atype = "race">
			 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				<cfset var= #item["values"]#>
				<cfset  j = 1>
				<cfloop array =#var# item = "value" index = "name">
					<cfset variable = #value#>
					<cfif j gt 1 >
						<cfset #MEDICALDATA# &= " or">
					</cfif>
					<cfset MEDICALDATA = "#MEDICALDATA# #atype#='#value#'">
					<cfset j+=1 /> 
				</cfloop>
				
				 	<cfset queries[i]=  "(  #MEDICALDATA# ) " > 
			</cfif>				

			<!--- Ethnicity filter --->
			<cfif #item["type"]# == "ethnicity">
			 	<cfset  atype = "ethnicity">
			 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				<cfset var= #item["values"]#>
				<cfset  j = 1>
				<cfloop array =#var# item = "value" index = "name">
					<cfset variable = #value#>
					<cfif j gt 1 >
						<cfset #MEDICALDATA# &= " or">
					</cfif>
					<cfset MEDICALDATA = "#MEDICALDATA# #atype#='#value#'">
					<cfset j+=1 /> 
				</cfloop>
				
				 <cfoutput>
				 	<cfset queries[i]= "(  #MEDICALDATA#  ) " > 
				 </cfoutput>
			</cfif>					
			
			<!--- Marital status --->
			<cfif #item["type"]# == "marital">
			 	<cfset  atype = "marital">
			 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				<cfset var= #item["values"]#>
				<cfset  j = 1>
				<cfloop array =#var# item = "value" index = "name">
					<cfset variable = #value#>
					<cfif j gt 1 >
						<cfset #MEDICALDATA# &= " or">
					</cfif>
					<cfset MEDICALDATA = "#MEDICALDATA# #atype#='#value#'">
					<cfset j+=1 /> 
				</cfloop>
				<cfset queries[i] = "(  #MEDICALDATA# ) " > 
			</cfif>	

			<!--- Conditions --->
			 <cfif #item["type"]# == "conditions">
			 	<cfset  atype = "conditions">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "conditions")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#' ))" > 
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 				
			
			<!--- Observations --->
			 <cfif #item["type"]# == "observations">
			 	<cfset  atype = "observations">
				<cfset id= #item["id"]#>
				<!--- Set operator based on builder output --->
				<cfif #item["options"]# == "greater">
					<cfset options= ">">
				<cfelseif #item["options"]# == "equal">
					<cfset options= "=">
				<cfelseif #item["options"]# == "less">
					<cfset options= "<">
				</cfif>
				<cfset type= #item["type"]#>
				<cfset value= #item["value"]#>
				 <cfset MEDICALDATA = dquery(tableName = "observations")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in (#MEDICALDATA# code='#id#' and value#options##value# ))" > 
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 

			<!--- Medications --->
			 <cfif #item["type"]# == "medications">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "medications")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#'))" > 
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 

			<!--- Immunizations --->
			 <cfif #item["type"]# == "immunizations">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "immunizations")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#' ))" >  
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 

			<!--- Allergies --->
			 <cfif #item["type"]# == "allergies">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "allergies")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#' ))" >  
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 

			<!--- Encounters --->
			 <cfif #item["type"]# == "encounters">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "encounters")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#'))" > 
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif>
			<!--- Procedures ---> 
			 <cfif #item["type"]# == "procedures">
				<cfset id= #item["id"]#>
				 <cfset MEDICALDATA = dquery(tableName = "procedures")/> 
				 <cfset MEDICALDATA = "(select id from patients where id in ( #MEDICALDATA# code='#id#' ))" > 
				 <cfoutput >
				 	<cfset queries[i]= #MEDICALDATA#>
				 </cfoutput>
			</cfif> 
			
			<!--- Boolean logic --->
			<cfif #item["type"]# == "and" >
				<cfset queries[i] = " intersect " />
			</cfif>

			<cfif #item["type"]# == "or" >
				<cfset queries[i] = " union " />
			</cfif>	

			<cfif #item["type"]# == "l_paren" >
				<cfset queries[i] = "(" />
			</cfif>	

			<cfif #item["type"]# == "r_paren" >
				<cfset queries[i] = ")" />
			</cfif>	
			
			<cfoutput>
				<!--- #queries[i]#<br> --->
			</cfoutput>
			<cfset i+=1 /> 
		</cfloop>
		<cfreturn queries />
	</cffunction>

	<cffunction name="dquery" access="public" returntype="string" >
		<cfargument name="tableName"  type = "string"/> 
		<cfset name = "select patient from #arguments.tableName# where" > 
		<cfreturn name  />
	</cffunction>
				
	<cffunction name="aquery" access="public" returntype="string" >
		<cfargument name="tableName"  type = "string"/> 
		<cfset name = "select id from #arguments.tableName# where" > 
		<cfreturn name  />
	</cffunction>

	<cffunction name="ageFunc" access="public" returntype="string" >
		<cfargument name="min" type="integer" >
		<cfargument name="max" type="integer" >
		<cfset query= "select id from patients where #arguments.min# <= (FLOOR (DATEDIFF(DD,patients.BIRTHDATE, GETDATE())/365.25)) and  #arguments.max # >= (FLOOR (DATEDIFF(DD,patients.BIRTHDATE, GETDATE())/365.25))">
		<cfreturn query />
	</cffunction>

	<cffunction name="patientFunc" access="public" retuntype = "string" >
		<cfargument name = "atype" type="string">
		<cfargument name="variable" type= "string" >
		<cfset query = "select id from patients where #arguments.atype# = '#variable#'">
		<cfreturn query />
	</cffunction>
</cfcomponent>