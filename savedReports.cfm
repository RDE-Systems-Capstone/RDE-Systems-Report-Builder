<!---
Code for saved report page
Built using Bootstrap/ColdFusion/JQuery

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfparam name="session.loggedin" default="false" />
<cfif NOT session.loggedin>
  <cflocation url="index.cfm" addtoken="false">
</cfif>

<cfquery name="saved_reports_query" datasource="MEDICALDATA">
	SELECT * FROM saved_reports WHERE username = '#session.username#'
</cfquery>

<cfquery name="shared_reports_query" datasource="MEDICALDATA">
	SELECT * FROM saved_reports WHERE id IN ( SELECT report_id FROM shared_reports WHERE shared_with = '#session.username#' )
</cfquery>

<cfquery name="usernames_query" datasource="MEDICALDATA">
	SELECT username, firstName, lastname FROM users WHERE NOT username = '#session.username#'
</cfquery>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>
		Saved Reports
	</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/jquery-ui.css">
	<!-- Styling for range filters (age), makes it easier to see -->
	<style>
		.ui-slider-range { background: #729fcf; }
		.ui-slider-handle { border-color: #729fcf; }
		.verticalButton { cursor: move; }
		.div-focus {
		box-shadow: 0 0 20px #66afe9;
		}
	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js">

	</script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js">

	</script>
	<script src="js/drag.js">

	</script>
	<script src="js/forms.js">

	</script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/reports.js"></script>

	
</head>
<body>
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pagetype="builder" activepage="builder">
	</cfinvoke>
	<div class="row-fluid">
		<div class="container-fluid">
			<div hidden class="alert alert-dismissible fade in" id="error_alert">
				<a href="#" class="close" onclick="$('#error_alert').hide();" aria-label="close">&times;</a>
				<div id="error_alert_text"></div>
			</div>
			<div class="col-lg-12">
			
			<!--- add page output here --->
			<!--- following code will display the user's saved reports --->
				
			<h1>Saved Reports</h1>
			<div>
				<cfif saved_reports_query.recordcount GT 0>
					<p>This is a list of reports that you have created and saved.</p>
					<table id="users" class="table table-striped">
						<tr><th>Name</th><th>Type</th><th>Description</th><th>Information</th><th>Run Report</th><th>Share Report</th><th>Delete Report</th></tr>
							<cfoutput query="saved_reports_query">
								<!--- json retrieved from query with report options is converted to coldfusion data types --->
								<cfset query_json = deserializeJSON(#saved_reports_query.query_string#)>
								<cfset report_json = deserializeJSON(#saved_reports_query.report_type_string#)>
								<cfset report_type = "#deserializeJSON(saved_reports_query.report_type_string).type#" />
								<tr>
									<!--- for each report available output some information about it --->
									<td>#saved_reports_query.name#</td>
									<cfif report_type EQ "trend">
										<td>Trend Graph</td>
									<cfelseif report_type EQ "bar">
										<td>Bar Chart</td>
									<cfelseif report_type EQ "pie">
										<td>Pie Chart</td>
									<cfelseif report_type EQ "doughnut">
										<td>Doughnut Chart</td>
									<cfelseif report_type EQ "data">
										<td>Data Table</td>
									</cfif>
									<td>#saved_reports_query.description#</td>
									<td><a href="##" onclick="showReportInfo(#saved_reports_query.id#)">View More Information</a></td>
									<!--- will run saved report using JS function...passes json to output page similar to builder page --->
									<td><button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#saved_reports_query.id#' onclick="runSavedReport(#saved_reports_query.id#)">Run</button></td>
									<!--- JS function to share report... will use AJAX to call CFC and insert new shared report entry --->
									<td><button type="button" class="btn btn-primary btn-space" data-toggle="modal" data-target="##shareReportModal" onclick='$("##share_report_id").val(#saved_reports_query.id#)'>Share</button></td>
									<td><button type="button" class="btn btn-danger btn-space" data-toggle="modal" onclick="triggerDeleteWarning(#saved_reports_query.id#)">Delete</button></td>
								</tr>
							</cfoutput>
							<!--- hidden input field to store shared report id...so JS can access it --->
							<input type="hidden" id="share_report_id" value=""/>
					</table>
				<cfelse>
					<p>You have no reports saved.</p>
				</cfif>
			</div>

			<!--- following code will display the user's shared reports --->
			<h1>Shared Reports</h1>
			<cfif shared_reports_query.recordcount GT 0>
				<p>This is a list of reports that have been shared with you.</p>
				<table id="users" class="table table-striped">
					<tr><th>Name</th><th>Type</th><th>Description</th><th>Information</th><th>Owner</th><th>Run Report</th></tr>
						<cfoutput query="shared_reports_query">
							<!--- json retrieved from query with report options is converted to coldfusion data types --->
							<cfset query_json = deserializeJSON(#shared_reports_query.query_string#)>
							<cfset report_json = deserializeJSON(#shared_reports_query.report_type_string#)>
							<cfset report_type = "#deserializeJSON(shared_reports_query.report_type_string).type#" />
							<tr>
								<!--- for each report available output some information about it --->
								<td>#shared_reports_query.name#</td>
								<cfif report_type EQ "trend">
									<td>Trend Graph</td>
								<cfelseif report_type EQ "bar">
									<td>Bar Chart</td>
								<cfelseif report_type EQ "pie">
									<td>Pie Chart</td>
								<cfelseif report_type EQ "doughnut">
									<td>Doughnut Chart</td>
								<cfelseif report_type EQ "data">
									<td>Data Table</td>
								</cfif>
								<td>#shared_reports_query.description#</td>
								<td><a href="##" onclick="showReportInfo(#shared_reports_query.id#)">View More Information</a></td>
								<td>#shared_reports_query.username#</td>
								<!--- will run saved report using JS function...passes json to output page similar to builder page --->
								<td><button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#shared_reports_query.id#' onclick="runSharedReport(#shared_reports_query.id#)">Run</button></td>
							</tr>
						</cfoutput>
				</table>
			<cfelse>
				<p>You have no shared reports available.</p>
			</cfif>


			<div class="modal fade" id="shareReportModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title" id="ModalLabel">Share Report</h5>
			        <button type="button" class="close" data-dismiss="modal" onclick='$("#shareWarning").hide();' aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
					<div hidden class="alert alert-warning" id="shareWarning" role="alert">
						<a href="#" class="close" onclick='$("#shareWarning").hide();' aria-label="close">&times;</a>
						<div id="shareWarningText">
						</div>
					</div>
			        Share report with which user?
			        <form>
			        	<cfoutput>
						<select id="username_opt" class="form-control">
							<option selected="true" disabled="disabled"> -- select a username -- </option>
							<cfloop query="#usernames_query#">
								<option value="#username#">#username# (#firstName# #lastName#)</option>
							</cfloop>
						</select>
						</cfoutput>	
			        </form>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" onclick='$("#shareWarning").hide();' data-dismiss="modal">Cancel</button>
			        <button type="button" class="btn btn-primary" onclick="shareReport()">Share</button>
			      </div>
			    </div>
			  </div>
			</div>
			<!-- report info modal -->
			<div class="modal" id="reportInfoModal" tabindex="-1" role="dialog">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title">Report Information</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body" id="reportInfoModalBody">
			      	Loading...
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
			      </div>
			    </div>
			  </div>
			</div>
			<!-- ask the user if he or she really wants to delete the report.... -->
			<div class="modal" id="deleteModal" tabindex="-1" role="dialog">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h4 class="modal-title">Delete Report</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body" id="deleteModalBody">
			      	<p>Are you sure you want to delete this report? This action cannot be undone.</p>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
			        <button type="button" class="btn btn-danger" id="deleteReportButton" >Delete</button>
			      </div>
			    </div>
			  </div>
			</div>
			<!--- report type string and query string (json) to be sent to output page using post --->
			<form style="display: hidden" action="output.cfm" method="POST" id="form">
				<input type="hidden" id="report_type_string" name="report_type_string" value=""/>
				<input type="hidden" id="query_string" name="query_string" value=""/>
				<input type="hidden" id="report_id" name="report_id" value="0"/>
			</form>
				
			<!--- end page output here --->
				
			</div>
		</div>
	</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
</body>