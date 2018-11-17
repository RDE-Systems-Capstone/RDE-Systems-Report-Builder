<cfquery name="test_query" datasource="MEDICALDATA">
	SELECT * FROM saved_reports WHERE username = '#session.username#'
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
			<div class="col-lg-8">
			
				<!--- add page output here --->
				
			<h1>Saved Reports</h1>
			<table id="users" class="table table-striped">
				<tr><th>Name</th><th>Description</th><th>Query</th><th>User</th><th>Run Report</th></tr>
					<cfoutput query="test_query">
						<cfset query_json = deserializeJSON(#test_query.query_string#)>
						<tr>
							<td>#test_query.name#</td>
							<td>#test_query.description#</td>
							<cfloop array="#query_json#" index="idx">
								<cfif #idx.type# eq "filter_string">
									<td>#idx.string#</td>
								</cfif>
							</cfloop>
							<td>#test_query.username#</td>
							<td><button type="button" class="btn btn-primary btn-space" data-toggle="collapse" id='#test_query.id#' onclick="runSavedReport(#test_query.id#)">Run</button></td>
						</tr>
					</cfoutput>
			</table>

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