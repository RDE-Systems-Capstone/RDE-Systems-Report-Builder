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
	<div class="col-lg-10">
		<h1>Output</h1>
		<div>
			<h2>Debug info:</h2>
			<cfoutput>#FORM.report_type_string#</cfoutput>
			<cfoutput>#FORM.query_string#</cfoutput>
			<h2>CFDump of received report options:</h2>
			<cfdump var="#deserializeJSON(FORM.report_type_string)#">
			<h2>CFDump of received array:</h2>
			<cfdump var="#deserializeJSON(FORM.query_string)#">
		</div>
	</div>

	<!-- Right column code-->
	 <div class="col-lg-2">

	 </div>

  </body>
</html>
