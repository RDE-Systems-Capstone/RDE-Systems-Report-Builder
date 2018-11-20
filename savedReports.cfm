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
	SELECT username FROM users
</cfquery>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>
		Report Builder
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
						<tr><th>Name</th><th>Description</th><th>Type</th><th>Query</th><th>Run Report</th><th>Share Report</th></tr>
							<cfoutput query="saved_reports_query">
								<!--- json retrieved from query with report options is converted to coldfusion data types --->
								<cfset query_json = deserializeJSON(#saved_reports_query.query_string#)>
								<cfset report_json = deserializeJSON(#saved_reports_query.report_type_string#)>
								<tr>
									<!--- for each report available output some information about it --->
									<td>#saved_reports_query.name#</td>
									<td>#saved_reports_query.description#</td>
									<td>#report_json.type#</td>
									<cfloop array="#query_json#" index="idx">
										<cfif #idx.type# eq "filter_string">
											<td>#idx.string#</td>
										</cfif>
									</cfloop>
									<!--- will run saved report using JS function...passes json to output page similar to builder page --->
									<td><button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#saved_reports_query.id#' onclick="runSavedReport(#saved_reports_query.id#)">Run</button></td>
									<!--- JS function to share report... will use AJAX to call CFC and insert new shared report entry --->
									<td><button type="button" class="btn btn-primary btn-space" data-toggle="modal" data-target="##shareReportModal" onclick='$("##share_report_id").val(#saved_reports_query.id#)'>Share</button></td>
								</tr>
							</cfoutput>
							<!--- hidden input field to store shared report id...so JS can access it --->
							<input type="hidden" id="share_report_id" value=""/>
					</table>
				<cfelse>
					<p>You have no reports saved.</p>
				</cfif>
			</div>
			<h1>Shared Reports</h1>
			<cfif shared_reports_query.recordcount GT 0>
				<p>This is a list of reports that have been shared with you.</p>
				<table id="users" class="table table-striped">
					<tr><th>Name</th><th>Description</th><th>Type</th><th>Query</th><th>User</th><th>Run Report</th></tr>
						<cfoutput query="shared_reports_query">
							<!--- json retrieved from query with report options is converted to coldfusion data types --->
							<cfset query_json = deserializeJSON(#shared_reports_query.query_string#)>
							<cfset report_json = deserializeJSON(#shared_reports_query.report_type_string#)>
							<tr>
								<!--- for each report available output some information about it --->
								<td>#shared_reports_query.name#</td>
								<td>#shared_reports_query.description#</td>
								<td>#report_json.type#</td>
								<cfloop array="#query_json#" index="idx">
									<cfif #idx.type# eq "filter_string">
										<td>#idx.string#</td>
									</cfif>
								</cfloop>
								<td>#shared_reports_query.username#</td>
								<!--- will run saved report using JS function...passes json to output page similar to builder page --->
								<td><button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#saved_reports_query.id#' onclick="runSavedReport(#shared_reports_query.id#)">Run</button></td>
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
			        <h5 class="modal-title" id="ModalLabel">Share Report</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        Share report with which user?
			        <cfform>
						<cfselect
							name="username_opt"
							id="username_opt"
							query="usernames_query"
							queryPosition="below"
							value="username"
							display="username"
							message="Select a username"
							class="form-control">
								<option selected="true" disabled="disabled"> -- select a username -- </option>
						</cfselect>
			        </cfform>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="shareReport()">Save changes</button>
			      </div>
			    </div>
			  </div>
			</div>
			<!--- report type string and query string (json) to be sent to output page using post --->
			<form style="display: hidden" action="output.cfm" method="POST" id="form">
				<input type="hidden" id="report_type_string" name="report_type_string" value=""/>
				<input type="hidden" id="query_string" name="query_string" value=""/>
			</form>
				
			<!--- end page output here --->
				
			</div>
		</div>
	</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
</body>