<!---<cfquery 
	name="builder_query" datasource="MEDICALDATA">
	#preserveSingleQuotes(FORM.query_string)#
</cfquery>--->

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
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
	<script src="js/drag.js"></script>
	<script src="js/forms.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>

  </head>
<body>
<!-- Navbar code-->
	<nav class="navbar navbar-inverse">
	  <div class="container-fluid">
		<div class="navbar-header">
		  <a class="navbar-brand" href="#">
			<img src="images/rde_logo_white.png" width="auto" height="100%" alt="">
		  </a>
		</div>
		<ul class="nav navbar-nav">
			<li><a href="builder.cfm">Builder</a></li>
			<li class="active"><a href="output.cfm">Output</a></li>
			<li><a href="#">Saved Reports</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<li><a>Welcome <cfoutput>#session.FirstName# #session.LastName#</cfoutput></a></li>
			<li><a href="app/logout.cfm">Logout</a></li>
		</ul>
	  </div>
	</nav>

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
				 <cfif #item["type"]# == "age">
				 	<cfset  atype = "age">
					<cfset age_min= #item["min"]#>
					<cfset age_max= #item["max"]#>
					 <cfset MEDICALDATA = ageFunc(min = #age_min#, max = #age_max# )/>

					 <cfoutput >
					 	<cfset queries[i]=  "( " & #MEDICALDATA# &" ) " > 
					 </cfoutput>
				</cfif>  
				<cfif #item["type"]# == "gender">
				 	<cfset  atype = "gender">
				     <cfset var= #item["values"]#>
		
					<cfloop array =#var# item = "value" index = "name">
						<cfset variable = #value#>
					</cfloop>
					
					 <cfset MEDICALDATA = patientFunc(atype= #atype#, variable = #variable# )/>
					 <cfoutput>
					 	<cfset queries[i]=  "( " & #MEDICALDATA# &" ) " > 
					 </cfoutput>
				</cfif>
				
				<cfif #item["type"]# == "race">
				 	<cfset  atype = "race">
				 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				 	<cfset spacer = " "/>
				 	<cfset qual = "="/>
				 	<cfset quote = '''' >
					<cfset var= #item["values"]#>
					<cfset  j = 1>
					<cfloop array =#var# item = "value" index = "name">
						<cfset variable = #value#>
						<cfif j gt 1 >
							<cfset #MEDICALDATA# &= " or">
						</cfif>
						<cfset MEDICALDATA = #MEDICALDATA# & #spacer# & #atype# & #qual# & #quote# & #value# & #quote#>
						<cfset j+=1 /> 
					</cfloop>
					
					 	<cfset queries[i]=  "( " & #MEDICALDATA# &" ) " > 
				</cfif>				

				<cfif #item["type"]# == "ethnicity">
				 	<cfset  atype = "ethnicity">
				 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				 	<cfset spacer = " "/>
				 	<cfset qual = "="/>
				 	<cfset quote = '''' >
					<cfset var= #item["values"]#>
					<cfset  j = 1>
					<cfloop array =#var# item = "value" index = "name">
						<cfset variable = #value#>
						<cfif j gt 1 >
							<cfset #MEDICALDATA# &= " or">
						</cfif>
						<cfset MEDICALDATA = #MEDICALDATA# & #spacer# & #atype# & #qual# & #quote# & #value# & #quote#>
						<cfset j+=1 /> 
					</cfloop>
					
					 <cfoutput>
					 	<cfset queries[i]= "( " & #MEDICALDATA# &" ) " > 
					 </cfoutput>
				</cfif>					
				
				<cfif #item["type"]# == "marital">
				 	<cfset  atype = "marital">
				 	<cfset MEDICALDATA = aquery(tableName = "patients")/>
				 	<cfset spacer = " "/>
				 	<cfset qual = "="/>
				 	<cfset quote = '''' >
				 	
					<cfset var= #item["values"]#>
					<cfset  j = 1>
					<cfloop array =#var# item = "value" index = "name">
						<cfset variable = #value#>
						<cfif j gt 1 >
							<cfset #MEDICALDATA# &= " or">
						</cfif>
						<cfset MEDICALDATA = #MEDICALDATA# & #spacer# & #atype# & #qual# & #quote# & #value# & #quote# >
						<cfset j+=1 /> 
					</cfloop>
					<cfset queries[i] = "( " & #MEDICALDATA# &" ) " > 
				</cfif>	

				 <cfif #item["type"]# == "conditions">
				 	<cfset  atype = "conditions">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "conditions")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))" > 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 				
				
				
				 <cfif #item["type"]# == "observations">
				 	<cfset  atype = "observations">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					<cfset options= #item["options"]#>
					<cfset type= #item["type"]#>
					<cfset value= #item["value"]#>
					 <cfset MEDICALDATA = dquery(tableName = "observations")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & " and value" &" " & #options# & " " & #value# & "))" > 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 

				 <cfif #item["type"]# == "medications">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "medications")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))" > 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 

				 <cfif #item["type"]# == "immunizations">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "immunizations")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))"> 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 

				 <cfif #item["type"]# == "allergies">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "allergies")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))"> 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 

				 <cfif #item["type"]# == "encounters">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "encounters")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))"> 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 
				 <cfif #item["type"]# == "procedures">
				 	<cfset qual = "=" /> 
				 	<cfset spacer = " "/>
					<cfset id= #item["id"]#>
					 <cfset MEDICALDATA = dquery(tableName = "procedures")/> 
					 <cfset MEDICALDATA = "(select id from patients where id in (" & #MEDICALDATA# & #spacer# & "code" & #qual# & #id# & "))"> 
					 <cfoutput >
					 	<cfset queries[i]= #MEDICALDATA#>
					 </cfoutput>
				</cfif> 
				
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
		
		<cfloop array = #tableGroupBy# index = "gb">
		<div>
			<h2> Graph for <cfoutput>#gb#</cfoutput> </h2>
			<cfset bigQuery= "">
			<cfloop array = #queries# index= "idx">
				<cfset bigQuery = #bigQuery#  & #idx# > 
			</cfloop>
			<cfoutput >
				<cfset var1= #gb# />
				<cfset bigQ = "select #var1#, count(distinct id) as total from patients where id in ( #bigQuery#) group by #var1# with rollup" />
				<!---#bigQ# --->
			</cfoutput>
				<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>
				<cfset MEDICALDATA = QueryExecute(#bigQ#, [] ,qoptions)> 
					<!--- <cfdump var="#MEDICALDATA#" > --->
					
					<cfset temp = MEDICALDATA.recordCount-1 > 

				<cfscript>
					for (i=1; i<= temp ; i++){
						writeOutput (MEDICALDATA[#var1#][i]);
						writeOutput (":");
						writeOutput (MEDICALDATA["total"][i]);
						writeOutput ("<br/>");				
					}
				</cfscript>

			<table id = "myTable"border=1>
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

					  }
					});
				</script>
			</canvas>
		</div>
		</cfloop>
	</div>

  </body>
</html>
