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

<cfquery name="report_query" datasource="MEDICALDATA">
	SELECT * FROM saved_reports WHERE id = '#FORM.report_id#'
</cfquery>


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
	<script src="js/reports.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>

  </head>
<body>
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pageType="builder" activePage="output"></cfinvoke>

	<div class="row-fluid">
		<div class="container-fluid">
			<div hidden class="alert alert-dismissible fade in" id="error_alert">
				<a href="#" class="close" onclick="$('#error_alert').hide();" aria-label="close">&times;</a>
				<div id="error_alert_text"></div>
			</div>
			<h1>Output:</h1>
			<div class="col-lg-4">
				
				<!--- print detailed report info --->
				
				<cfinvoke component="app.builder.output" method="reportDetails" FilterBool="#deserializeJSON(FORM.query_string)#" GraphOptions="#deserializeJSON(FORM.report_type_string)#"></cfinvoke>				
					
				<div class="modal fade" id="saveReportModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
				  <div class="modal-dialog" role="document">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="ModalLabel">Save Report</h5>
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				        </button>
				      </div>
				      <div class="modal-body">
						<!--- form to insert data to database --->					
						<form name="saveForm" method="post">
							<div id="displaying">
								<label for="usr">Name:</label>
								<cfif FORM.report_id EQ 0>
									<input type="text" class="form-control" id="report_name" placeholder="Name of Report">
									<label for="comment">Description:</label>
	 								<textarea class="form-control" rows="5" id="report_comment" placeholder="Description or Comments"></textarea>
	 							<cfelse>
	 								<cfoutput query="report_query">
		 								<input type="text" class="form-control" id="report_name" placeholder="Name of Report" value="#report_query.name#">
										<label for="comment">Description:</label>
		 								<textarea class="form-control" rows="5" id="report_comment" placeholder="Description or Comments">#report_query.description#</textarea>
	 								</cfoutput>
								</cfif>
								<cfoutput>
 								<input type="hidden" id="report_type_string" name="report_type_string" value='#FORM.report_type_string#'/>
								<input type="hidden" id="query_string" name="query_string" value='#FORM.query_string#'/>
 								<br>
 								</cfoutput>
							</div>
						</form>
				      </div>
				      <div class="modal-footer">
				      	<cfif FORM.report_id EQ 0>
 							<!-- submit button will call JS function that uses AJAX to save report -->
 							<cfoutput><button type="button" id="save" class="btn btn-primary mb-2" data-dismiss="modal" onclick="saveReport(#FORM.report_id#)">Save Report</button></cfoutput>
 						<cfelse>
 							<cfoutput><button type="button" id="save" class="btn btn-primary mb-2" data-dismiss="modal" onclick="saveReport(#FORM.report_id#)">Update Report</button></cfoutput>
 							<cfoutput><button type="button" id="save" class="btn btn-primary mb-2" data-dismiss="modal" onclick="saveReport('0')">Save as New Report</button></cfoutput>
 						</cfif>
				      </div>
				    </div>
				  </div>
				</div>
					<button type="button" class="btn btn-primary btn-space" data-toggle="modal" data-target="#saveReportModal">Save Report</button>
					<button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#saved_reports_query.id#' onclick="$('#builder_form').submit();">Modify Report</button>
					<!-- <p> tag for spacing purposes -->
					<p>
					</p>


			</div>
			<div class="col-lg-8">
				<cftry>
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
					
					<cfinvoke component="app.builder.output" method="generateSQLQuery" FilterBool="#deserializeJSON(FORM.query_string)#" returnvariable="bigQuery"></cfinvoke>
					
					<cfloop array = #tableGroupBy# index ="gb">
						<div>
						
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
						
						<cfif #temp# != 0 >
						<h2> Graph for <cfoutput>#gb#</cfoutput> </h2>
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
								  	data.labels.push("Missing")
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
                        							return value;
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
												<cfset b = "Missing"/>
											</cfif>
						                    <td><cfoutput>#b#</cfoutput></td>
						                </cfloop>
						            </tr>
						    	</cfif>
						    </cfloop>
						</table>
					<cfelse>
						<h1>
							There are 0 instances that fall into these criteria. 
						</h1>
					</cfif>
					</div>
				</cfloop>
				
				<!--WE NEED TO HANDLE THIS USING view then inner join  -->
			<cfelseif #TableOptions["type"]# eq "Data"  >
				<cfset optionString = ""/>
				<cfset bigQ = "With temp as ( #bigQuery#)" />
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
				
				<cfset joinString = "#bigQ#select #optionString# from patients inner join temp on patients.id = temp.id"/>
				
				<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>
				<cfset MEDICALDATA = QueryExecute(#joinString#, [] ,qoptions)>
				
				<cfset temp = MEDICALDATA.recordCount > 
				<cfif #temp# !=0 >
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
										<cfset b = "Missing"/>
									</cfif>
				                    <td><cfoutput>#b#</cfoutput></td>
				                </cfloop>
				            </tr>
				    	</cfif>
				    </cfloop>
				</table>
				<cfelse>
						<h1>
							There are 0 instances that fall into these criteria. 
						</h1>
				</cfif>
				
								
			<!---output a message for any other graph not supported --->
			<Cfelseif #TableOptions["type"]# eq "Trend">
				<cfinvoke component="app.builder.output" method="TrendQuery" FilterBool="#deserializeJSON(FORM.query_string)#" returnvariable="bigQuery"></cfinvoke>
				<cfoutput>
					<cfset bigQ = "With temp as (#bigQuery#),"/>
					<cfset trendArray = arraynew(1)>
					<cfset i = 1 />
					<cfloop collection="#TableOptions#" item="item" >
						<cfset trendArray[i]= #TableOptions[item]# /> 
						<cfset i+=1 />
					</cfloop>
					<!-- end date,start start, sum or avg, trend, code -->
					<!---<cfdump var = #trendArray# />--->
					
					<cfset trendQuery = "temp1 as (select * from observations where code = '#trendArray[5]#' and date between '#trendArray[2]#' and '#trendArray[1]# ')"/>
					<cfset AQuery = " ,temp2 as (select temp1.*,temp.* from temp1 full join temp on temp.id = temp1.patient where temp1.patient is not null and temp.id is not null )"/>
					<cfset code = #trendArray[5]# />
					<cfif #code# eq '363406005'>
						<h1>Support for this graph type is not available yet and will be added in a future release.</h1>
					<cfelse>
						<cfif #trendArray[3]# eq "sum">
							<cfset perfectQuery= "#bigQ# #trendQuery# #AQuery# select datepart(month from date )as Month, datepart(year from date) as Year, (sum (cast(value as float))) as Sum from temp2 group by datepart(month from date ), datepart(year from date) order by datepart(year from date), datepart(month from date ) "/>
							<cfset var3 = "Sum" />	
						<cfelseif #trendArray[3]# eq "average">
							<cfset perfectQuery = "#bigQ# #trendQuery# #AQuery# select datepart(month from date )as Month, datepart(year from date) as Year, (avg (cast(value as float))) as Average from temp2 group by datepart(month from date ), datepart(year from date) order by datepart(year from date), datepart(month from date ) "/>
							<cfset var3 = "Average" />					
						</cfif>
					</cfif>
						<cfoutput >
							#perfectQuery#
						</cfoutput>
					<cfset qoptions = {result="myresult", datasource="MEDICALDATA", fetchclientinfo="yes"}>

					<cfset MEDICALDATA= QueryExecute(#perfectQuery#, [] ,qoptions)>
					
					<cfset temp = MEDICALDATA.recordCount >

				<!---Right here in table is followed by month year and sum or avg columns 
				based on that we have to create threee variables which can help us to convert rows into
				arrrays for chart.js  
				 --->
				 	<cfset var1 = "Month" />
				 	<cfset var2 = "Year"/>
				 	<!---Since var3 is dynamic, so we setup above when query has been created.  --->
					<cfset labels = ArrayNew(1)>
					<cfset values = ArrayNew(1)>
					<cfset colors = ArrayNew(1)>
						<cfloop index="i" from="1" to="#temp#">
							<cfoutput>
								
							    <cfset mystring1 = MEDICALDATA[#var1#][i]/>
							    <cfset mystring2 = MEDICALDATA[#var2#][i]/>
								<cfset a = #mystring1# &"/" & #mystring2# />
								
								<!---This is for captializing 1st letter of each word --->
								<cfset labels[i]= #a#>
								<cfset values[i]= MEDICALDATA[#var3#][i]>
								<CFSET color =FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16) & FormatBaseN(RandRange(0,255), 16)>
								<cfset colors[i] = #color#>
							</cfoutput>
						</cfloop>	
					<cfset var4 = "line" />
					<cfquery name="query" datasource="MEDICALDATA" >
    						SELECT distinct description 
    						FROM observations
    						where code = '#code#'; 
					</cfquery>
					<cfset x = #query["description"][1]# />
				</cfoutput>
				
				<cfif #temp# != 0 >
				<canvas id="myChart">
							<script type= "text/javascript" language="Javascript"> 
								/*converting coldfusion array into javascript */	
								<cfoutput>
								 var #ToScript(labels, "jsArray")#;
								 var #ToScript(values, "jArray")#;
								 var #ToScript(temp, "var1")#; 
								 var #ToScript(var4, "typeGraph")#;
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
								  	data.labels.push("Missing")
								  }
								  else{
								  	data.labels.push(jsArray[i])
								  }
								  data.total.push(jArray[i])
								  //data.colors.push(getRandomColor())
								}
								var ctx = document.getElementById("myChart").getContext('2d');
								
								var myChart = new Chart(ctx, {
								  type: typeGraph,
								  data: {
								    labels:data.labels,
								    datasets: [{
								    	label:' <cfoutput>#x#</cfoutput> Vs. Time',
								    	data : data.total,
								    	backgroundColor: getRandomColor()
								    }]

								  },
							        options: {
							            scales: {
							                yAxes: [{
							                    ticks: {
							                        min: 0,
							                        beginAtZero: true,
							                        callback: function(value, index, values) {
                        							return value;							                       
                    									}
							                    }
							                }]
							            },
							            elements: {
							            	line:{
							            		fill:false
							            	}
							            }
							        }
								});
							</script>
						</canvas>
				<TABLE id= "myTable" "myTable" class="table table-striped">
					<TR>
					    <TH>Date</TH>
					    <TH><cfoutput>#var3# </cfoutput></TH>
					</TR>
					<CFloop index = "i" from=1 to= #temp# >
					<TR>
					   <TD><cfoutput >
					   		#labels[i]#
					   </cfoutput></TD>
					    <TD><cfoutput >
					    	#decimalformat(values[i])#
					    </cfoutput></TD>
					</TR> 
					</Cfloop>


				</TABLE>
				<cfelse>
						<h1>
							There are 0 instances that fall into these criteria. 
						</h1>
				</cfif>
			</cfif>
		</div>
		<cfcatch>
			<!-- error message if error occurs -->
			<div class="alert alert-danger">
			  <strong>Error!</strong> There was an error in processing your report. Please try again later.
			</div>
		</cfcatch>
		</cftry>
		</div>
	</div>
	<!--- report type string and query string (json) to be sent to output page using post --->
	<form style="display: hidden" action="builder.cfm" method="POST" id="builder_form">
		<cfoutput>
		<input type="hidden" id="report_type_string" name="report_type_string" value="#URLEncodedFormat(FORM.report_type_string)#"/>
		<input type="hidden" id="query_string" name="query_string" value="#URLEncodedFormat(FORM.query_string)#"/>
		<input type="hidden" id="report_id" name="report_id" value='#FORM.report_id#'/>
		</cfoutput>
	</form>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
  </body>
</html>
