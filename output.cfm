<!---
Code for report output page
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfparam name="session.loggedin" default="false" />
<cfif NOT session.loggedin>
  <cflocation url="index.cfm" addtoken="false">
</cfif>
<cfif NOT isDefined("FORM.report_type_string")>
	<cflocation url="builder.cfm" addtoken="false">
</cfif>

<!DOCTYPE html>
<html lang="en">
  <head>
	<title>Report Builder</title>
    <meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/drag.js"></script>
	<script src="js/forms.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>

  </head>
<body>
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pageType="builder" activePage="output"></cfinvoke>

	<div class="row">
		<!-- left column code-->
		<div class="col-lg-4">
			<h1>Output</h1>
			<div>
				<h2>Debug info:</h2>
				<!--- POSTed information is obtained from the superglobal variable FORM. 
					Information is sent in the following manner:
					report_type_string={json_object}
					query_string=[json_array] --->
				<!--- The two lines below just dump the data we got --->
				<cfoutput>#FORM.report_type_string#</cfoutput>
				<cfoutput>#FORM.query_string#</cfoutput>

				<h2>Graph options (struct) loop</h2>

				<!--- This will loop through the table options array --->
				<cfset TableOptions="#deserializeJSON(FORM.report_type_string)#">
				<cfloop collection = #TableOptions# item="item">
					<!--- Get the graph type --->
					<cfif #item# EQ "type">
						<cfset tableType = #TableOptions[item]#>
					</cfif>
					<cfif #item# EQ "group_by">
						<!--- Get the group by options --->
						<cfset tableGroupBy = #TableOptions[item]#>
					</cfif>
					<cfdump var="#item#">
					<cfdump var="#TableOptions[item]#">
					<br /> <!---add a break in between items for readability purposes --->
				</cfloop>
				<h2>Filter Options (array) loop</h2>

				<!--- And this code will loop through the array with the filters and boolean options 
					Each filter will have different options, but the one attribute they will all have in common is the "type". We can get the type using #item["type"]# and run code based on the type we get back.--->
				<cfset FilterBool="#deserializeJSON(FORM.query_string)#">
				<cfloop array = #FilterBool# item="item">
					<cfoutput>#item["type"]#</cfoutput>
					<cfdump var="#item#">
				</cfloop>
				</div>
			</div>
			<div class="col-lg-6 text-left">
				<cfset FiltersandBool="#deserializeJSON(FORM.query_string)#">

				<cfset queries= ArrayNew(1)>
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
				<cfset i = 1 />
				<cfset FilterBool="#deserializeJSON(FORM.query_string)#">
				<cfloop array = #FilterBool# item="item" >
					<!--  checking paramters -->
					<!--- Age, might be broken?? --->
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
			
			<!--- Code for table and query output --->
			<cfloop array = #tableGroupBy# index = "gb">
			<div>
				<h2> Graph for <cfoutput>#gb#</cfoutput> </h2>
				<cfset bigQuery= "">
				<cfloop array = #queries# index= "idx">
					<cfset bigQuery = #bigQuery#  & #idx# > 
				</cfloop>
				<cfoutput>#bigQuery#<br /></cfoutput>
				<cfoutput >
					
					<cfset var1= #gb# />
					<cfif var1 eq "age">
					<cfset countvar = age_min />
					<cfset cvar = age_min+9 />
					<cfif cvar+9 greater than age_max >
						<cfset diff =  #age_max# - #countvar# />
						<cfset cvar = countvar+diff />
						diff = #diff# <br> age_max = #age_max#  <br> cvar= #cvar#
					</cfif>
					<cfset caseString=""/>
					<cfoutput >
					<cfloop condition="cvar less than or equal to age_max ">
						<cfset caseString &= "when  age between #countvar# and #cvar# then '#countvar#-#cvar#'"/>
						<cfset countvar = (cvar+1) />
						<cfif cvar+10 greater than age_max >
							<cfset diff =  #age_max# - #cvar# />
							diff = #diff# <br> age_max = #age_max#  <br> cvar= #cvar#
							<cfif diff eq 0 >
								<cfbreak>
							<cfelse>
								<cfset cvar= cvar + diff />
							</cfif>
						<cfelse>
							<cfset cvar += 10 />
						</cfif>
					</cfloop>
					</cfoutput>
					<cfoutput >
						<br>#caseString# = caseString<br>
					</cfoutput>
					<cfset a = "WITH ages AS(SELECT id, (FLOOR (DATEDIFF(DD,patients.BIRTHDATE, GETDATE())/365.25)) as age FROM patients )"/>
					<cfset b= "(SELECT"/>
					<cfset c = "case #caseString# end"/>
					<cfset d = "as age_category"/>
					<cfset e = ",count(*) as total FROM ages where id in  (#bigQuery#) group by #c#)"/>  

					<cfset bigQ = "#a# #b# #c# #d# #e#" />
					<cfoutput> 
						#bigQ#
					</cfoutput>
					<cfset var1 = "age_category"/>
					<cfelse>
					<cfset bigQ = "select #var1#, count(distinct id) as total from patients where id in ( #bigQuery#) group by #var1# with rollup" />
					</cfif>
					<!---#bigQ# --->
				</cfoutput>
					<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>
					<cfset MEDICALDATA = QueryExecute(#bigQ#, [] ,qoptions)> 
						<!--- <cfdump var="#MEDICALDATA#" > --->
						<cfif var1 eq "age_category">
						<cfset temp = MEDICALDATA.recordCount > 
						<cfelse>
						<cfset temp = MEDICALDATA.recordCount-1 > 
						</cfif>


				<!--- code for charts --->
				<cfset var3 = #tableType# />
				<cfset labels = ArrayNew(1)>
				<cfset values = ArrayNew(1)>
				<cfset colors = ArrayNew(1)>
				<cfif var3 eq "bar">
					<cfloop index="i" from="1" to="#temp#">
						<cfoutput>
						<cfset labels[i]= MEDICALDATA[#var1#][i]>
						<cfset values[i]= MEDICALDATA["total"][i]>
						<CFSET color =FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16)>
						<cfset colors[i] = #color#>

					<!---	<cfset values[i] = Round ((#VAL(temp2)#*360)/#Val(Sum_data)#)>--->
						</cfoutput>
					</cfloop>
				</cfif>		
					<canvas id="myChart<cfoutput>#var1#</cfoutput>">
						<script type= "text/javascript" language="Javascript"> 
							/*converting coldfusion array into javascript */	
						<cfoutput>
						 var #ToScript(labels, "jsArray")#;
						 var #ToScript(values, "jArray")#;
						 var #ToScript (temp, "var1")#; 
						 var #ToScript(var3, "typeGraph")#;
						/* var #ToScript(colors, "color")#;*/
						 var tableArr= [];
						</cfoutput>

						var table = document.getElementById("myTable");
						var tableLen = var1;
						var data = {labels: [], total:[], colors:[]}
						function getRandomColor() {
						  var letters = '0123456789ABCDEF';
						  var color = '#';
						  for (var i = 0; i < 6; i++) {
						    color += letters[Math.floor(Math.random() * 16)];
						  }
						  return color;
						}

						for (var i = 0; i < tableLen; i++) {
						  data.labels.push(jsArray[i])
						  data.total.push(jArray[i])
						  data.colors.push(getRandomColor())
						}
						var ctx = document.getElementById("myChart<cfoutput>#var1#</cfoutput>").getContext('2d');
						
						var myChart = new Chart(ctx, {
						  type: typeGraph,
						  data: {
						    labels:data.labels,
						    datasets: [{
						    	label: "<cfoutput>#var1#</cfoutput>",
						    	data : data.total,
						    	backgroundColor: data.colors
						    }]

						  },
	        options: {
	            scales: {
	                yAxes: [{
	                    ticks: {
	                        min: 0,
	                        beginAtZero: true
	                    }
	                }]
	            }
	        }
						});
					</script>
				</canvas>
			</div>
			</cfloop>
				<table id = "myTable" class="table table-striped">
				<style>tr : {background-color:red} </style>
			    <cfloop from="0" to="#temp#" index="row">
			        <cfif row eq 0>
			            <tr>
			                <cfloop list="#MEDICALDATA.ColumnList#" index="column" delimiters=",">
			                    <th><cfoutput>#column#</cfoutput></th>  
			                </cfloop>
			            </tr>
			        <cfelse>
			            <tr>
			                <cfloop list="#MEDICALDATA.ColumnList#" index="column" delimiters=",">
			                    <td><cfoutput>#MEDICALDATA[column][row]#</cfoutput></td>
			                </cfloop>
			            </tr>
			    </cfif>
			    </cfloop>
				</table>
		</div>
	</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
  </body>
</html>
