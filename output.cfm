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

	<div class="row-fluid">
		<div class="container-fluid">
			<h1>Output:</h1>
			<div class="col-lg-4">
				<!--- print detailed report info --->
				<cfinvoke component="app.builder.output" method="reportDetails" FilterBool="#deserializeJSON(FORM.query_string)#" GraphOptions="#deserializeJSON(FORM.report_type_string)#"></cfinvoke>
			</div>
			<div class="col-lg-8">
				<!--- POSTed information is obtained from the superglobal variable FORM. 
					Information is sent in the following manner:
					report_type_string={json_object}
					query_string=[json_array] --->

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
				</cfloop>

				<!--- Call the function that will generate SQL Query based on filters --->
				<cfinvoke component="app.builder.output" method="generateSQLQuery" FilterBool="#deserializeJSON(FORM.query_string)#" returnvariable="bigQuery"></cfinvoke>
			
				<!--- Code for table and query output --->
				<!--- check if type is bar.... we don't support other types of graphs yet --->
				
				
				<cfif #TableOptions["type"]# eq "bar" or  #TableOptions["type"]# eq "doughnut" or #TableOptions["type"]# eq "pie"  >
					<cfloop array = #tableGroupBy# index ="gb">
						<div>
							<h2> Graph for <cfoutput>#gb#</cfoutput> </h2>
						
						<cfset var1="#gb#"/>
						<!--- Group by age options --->
						<cfif var1 eq "age">
							<cfinvoke component="app.builder.output" method="getAgeParameters" FilterBool="#deserializeJSON(FORM.query_string)#" returnvariable="age_range"></cfinvoke>
							<cfset age_min="#age_range[1]#">
							<cfset age_max="#age_range[2]#">
							<cfinvoke component="app.builder.output" method="generateAgeQuery" age_min="#age_min#" age_max="#age_max#" bigQuery="#bigQuery#" returnvariable="bigQ"></cfinvoke>
							<cfset var1 = "AGE_CATEGORY"/>
						<cfelse>
						
							<!-- Anything other than age, a simpler query will suffice --->
							<cfset bigQ = "select #var1#, count(distinct id) as total from patients where id in ( #bigQuery#) group by #var1# with rollup" />
						</cfif>
						
						<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>
						<cfset MEDICALDATA = QueryExecute(#bigQ#, [] ,qoptions)>
						

<!---						<cfquery name = "MEDICALDATA" datasource="MEDICALDATA" >
							#Evaluate(BigQ)#
						</cfquery>--->
						<cfif var1 eq "AGE_CATEGORY">
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
									
									    <cfset mystring = MEDICALDATA[#var1#][i]/>
										<cfset a = Replace(mystring, "_", " ", "ALL")  />
									
									
									<cfset labels[i]= ReReplace(a ,"\b(\w)","\u\1","ALL")>
									<cfset values[i]= MEDICALDATA["total"][i]>
									<CFSET color =FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16)>
									<cfset colors[i] = #color#>
								</cfoutput>
							</cfloop>
						</cfif>	

						<cfif var3 eq "doughnut">
							<cfloop index="i" from="1" to="#temp#">
								<cfoutput>
									
									    <cfset mystring = MEDICALDATA[#var1#][i]/>
										<cfset a = Replace(mystring, "_", " ", "ALL")  />
									
									
									<cfset labels[i]= ReReplace(a ,"\b(\w)","\u\1","ALL")>
									<cfset values[i]= MEDICALDATA["total"][i]>
									<CFSET color =FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16)>
									<cfset colors[i] = #color#>
								</cfoutput>
							</cfloop>
						</cfif>	
						
						<cfif var3 eq "pie">
							<cfloop index="i" from="1" to="#temp#">
								<cfoutput>
									
									    <cfset mystring = MEDICALDATA[#var1#][i]/>
										<cfset a = Replace(mystring, "_", " ", "ALL")  />
									
									
									<cfset labels[i]= ReReplace(a ,"\b(\w)","\u\1","ALL")>
									<cfset values[i]= MEDICALDATA["total"][i]>
									<CFSET color =FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16)>
									<cfset colors[i] = #color#>
								</cfoutput>
							</cfloop>
						</cfif>	
						<canvas id="myChart<cfoutput>#var1#</cfoutput>">
							<script type= "text/javascript" language="Javascript"> 
								/*converting coldfusion array into javascript */	
								<cfoutput>
								 var #ToScript(labels, "jsArray")#;
								 var #ToScript(values, "jArray")#;
								 var #ToScript(temp, "var1")#; 
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
								  if (jsArray[i] == ""){
								  	data.labels.push("Undefined")
								  }
								  else{
								  	data.labels.push(jsArray[i])
								  }
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
							                        beginAtZero: true,
							                        callback: function(value, index, values) {
                        							return '$' + value;
                    									}
							                    }
							                }]
							            }
							        }
								});
							</script>
						</canvas>
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
						                	 <cfset mystring = #MEDICALDATA[column][row]#/>
											<cfset a = Replace(mystring, "_", " ", "ALL")  />
											<cfset b = ReReplace(a ,"\b(\w)","\u\1","ALL") />
											<cfif b eq ""> 
												<cfset b = "Undefined"/>
											</cfif>
						                    <td><cfoutput>#b#</cfoutput></td>
						                </cfloop>
						            </tr>
						    	</cfif>
						    </cfloop>
						</table>
					</div>
				</cfloop>
				
				<!--WE NEED TO HANDLE THIS USING view then inner join  -->
			<cfelseif #TableOptions["type"]# eq "Data"  >
			
				<cfquery name = "query" datasource="MEDICALDATA" >
					Drop view  if exists dbo.temp
				</cfquery>
				<cfset optionString = ""/>
				<cfset bigQ = "create view temp as ( #bigQuery#)" />
				<cfset  i = 0 />
				
				<cfloop array = #tableGroupBy# index ="gb">
					<cfif i eq 0 >
						<cfset temp1 = #gb#/>
						<cfset optionString &= "patients.#gb#"/>
					<cfelse>
						<cfset optionString &= ",patients.#gb#"/>	
					</cfif>
					<cfset i= 1/>
				</cfloop>
				
				<cfset joinString = "select #optionString# from patients inner join temp on patients.#temp1# = temp.#temp1#"/>
				
				<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>
				<cfset temp = QueryExecute(#bigQ#, [] ,qoptions)>
				
				<cfset MEDICALDATA = QueryExecute(#joinString#, [] ,qoptions)>
				
				<cfset temp = MEDICALDATA.recordCount > 
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
				                	 <cfset mystring = #MEDICALDATA[column][row]#/>
									<cfset a = Replace(mystring, "_", " ", "ALL")  />
									<cfset b = ReReplace(a ,"\b(\w)","\u\1","ALL") />
									<cfif b eq ""> 
										<cfset b = "Undefined"/>
									</cfif>
				                    <td><cfoutput>#b#</cfoutput></td>
				                </cfloop>
				            </tr>
				    	</cfif>
				    </cfloop>
				</table>
				
								
			<!---output a message for any other graph not supported --->
			<cfelse>
				<h1>Support for this graph type is not available yet and will be added in a future release.</h1>
			</cfif>
		</div>
		</div>
	</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
  </body>
</html>
