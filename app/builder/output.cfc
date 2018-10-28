<!---
Code for report output page - Functions
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfcomponent displayname="report_builder">
	<!--- Function generateSQLQuery takes in the JSON array from the report builder page and generates an array of queries to obtain the data required --->
	<cffunction name="generateSQLQuery" returntype="string">
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
		<!--- construct the final query --->
		<cfset bigQuery= "">
		<cfloop array = #queries# index= "idx">
			<cfset bigQuery = #bigQuery#  & #idx# > 
		</cfloop>
		<cfreturn bigQuery />
	</cffunction>

	<cffunction name="generateAgeQuery" returntype="string">
		<cfargument name="age_min" required="false" />
		<cfargument name="age_max" required="false" />
		<cfargument name="bigQuery" required="true" />
		<cfif isDefined ("age_min")>
			<cfset countvar = age_min />
			<cfset cvar = age_min+9 />
			<cfif cvar+9 greater than age_max >
				<cfset diff =  #age_max# - #countvar# />
				<cfset cvar = countvar+diff />
			</cfif>
		<cfelse>
			<Cfset age_min = 0/>
			<cfset countvar = age_min />
			<cfset cvar = age_min+9 />
			<cfset age_max = 150 />
		</cfif> 
		<cfset caseString=""/>
		<cfloop condition="cvar less than or equal to age_max ">
			<cfset caseString &= "when  age between #countvar# and #cvar# then '#countvar#-#cvar#'"/>
			<cfset countvar = (cvar+1) />
			<cfif cvar+10 greater than age_max >
				<cfset diff =  #age_max# - #cvar# />
				<cfif diff eq 0 >
					<cfbreak>
				<cfelse>
					<cfset cvar= cvar + diff />
				</cfif>
			<cfelse>
				<cfset cvar += 10 />
			</cfif>
		</cfloop>
		<cfset a = "WITH ages AS(SELECT id, (FLOOR (DATEDIFF(DD,patients.BIRTHDATE, GETDATE())/365.25)) as age FROM patients )"/>
		<cfset b= "(SELECT"/>
		<cfset c = "case #caseString# end"/>
		<cfset d = "as age_category"/>
		<cfset e = ",count(*) as total FROM ages where id in  (#bigQuery#) group by #c#)"/>  

		<cfset bigQ = "#a# #b# #c# #d# #e#" />
		<cfreturn bigQ />
	</cffunction>

	<cffunction name="getAgeParameters" returntype="array">
		<cfargument name="FilterBool" type="array" required="true"/>
			<cfset age_range=ArrayNew(1)>
			<cfset age_min="0">
			<cfset age_max="120">
			<cfloop array = #FilterBool# item="item" >
				<cfif #item["type"]# == "age">
					<cfset age_min= #item["min"]#>
					<cfset age_max= #item["max"]#>
				</cfif>
				<cfset age_range[1] = "#age_min#">
				<cfset age_range[2] = "#age_max#">
			</cfloop>
			<cfreturn age_range>
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