<cfif structKeyExists(form, 'submit')>
	<cfset createObject("component", 'CF Projects.RDE Systems.app.Authentification').doLogout()/>
	<cflocation url="/CF Projects/RDE Systems/index.cfm" addtoken="false">
</cfif>

<cfif not isUserLoggedIn()>
	<cflocation url="/CF Projects/RDE Systems/index.cfm"/>
	<cfabort/>
</cfif>
<style>
	body{
	background-color: lightblue;
	}
	section{
	background-color: lightblue;
	border-radius: 1em;
	padding: 1em;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-right: -50%;
	transform: translate(-50%, -50%)
	}
	#p1{
	text-align:center;
	}
</style>

<cfoutput>
	<html>
		<head>
			<img src="images/rde_logo.png" style="float: left;" width="10%">
		</head>
		<body>
			<section>
				<h1>
					Success! (link report builder here)
				</h1>
				<!---Display welcome message for logged in user--->
				<!-- 
				<p>
					<cfoutput>Welcome ## ##!</cfoutput>
				</p>
				-->
				<cfform name="Logout" action="#CGI.script_name#?#CGI.query_string#" method="Post">
					<p id="p1">
						<!--using href to go back to index.cfm?logout gives session undefined error -->
						<a href="/CF Projects/RDE Systems/index.cfm?logout">
							Logout
						</a>
						<!-- 
						<cfinput type="submit" name="submit" id="sumbit" value="Log Out"/>
						-->
					</p>
				</cfform>
			</section>
			
			<p>
			</p>
		</body>
	</html>
</cfoutput>