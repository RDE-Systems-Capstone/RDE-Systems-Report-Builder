<!---Logout--->
<!-- gives session undefined error when redirecting back to this page-->
<cfif structKeyExists(URL, 'logout')>
	<cfset createObject("component", 'app.Authentification').doLogout()/>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<!--- Processing Entered Data --->
<cfif structKeyExists(form, 'submit')>
	<!---Create instance of authentification service component--->
	<cfset authenticationService = createobject("component", 
	                                            'app.Authentification')/>
	<!---serverside validation--->
	<cfset aErrorMessages = authenticationService.validateUser(form.User, form.Pass)/>
	<cfif ArrayIsEmpty(aErrorMessages)>
		<!---Proceed to login--->
		<cfset isUserLoggedIn = authenticationService.doLogin(form.User, form.Pass)/>
		<cflocation url="builder.cfm" addtoken="false" >
	</cfif>
</cfif>
<style>
	section{
	background-color: lightblue;
	border: 1px solid white;
	border-radius: 1em;
	padding: 1em;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-right: -50%;
	transform: translate(-50%, -50%)
	}
	body{
	background-color: lightblue;
	border: 1px solid white;
	}
	h1{
	text-align: center;
	}
	#p1{
	text-align: center;
	}
	dl{
	text-align:center;
	}
	cfinput{
	text-align:center;
	}
	#submit{
	text-align:center;
	}
</style>
<html>
	<head>
		<img src="images/rde_logo.png" style = "float: left;" width="10%">
	</head>
	<body>
		<section>
		
			<!--- Login Form --->
			<cfform name="LoginForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
			
				<cfif structKeyExists(variables, 'aErrorMessages') AND NOT ArrayIsEmpty(aErrorMessages)>
					<cfoutput>
						<cfloop array="#aErrorMessages#" item="message">
							<p class="errorMessage">
								#message#
							</p>
						</cfloop>
					</cfoutput>
				</cfif>
				<cfif structKeyExists(variables, 'isUserLoggedIn') AND isUserLoggedIn EQ false>
					<p class="errorMessage">
						Username/Password are invalid. Please try again!
					</p>
				</cfif>
				
					<h1>
						Login
					</h1>
					<p>
						Username: 
						<cfinput type="text" name="User" id="User" required="true"
						         validateat="onSubmit" message="Please provide a username"/>
					</p>
					<p>
						Password: 
						<cfinput type="password" name="Pass" id="Pass" required="true"
						         validateat="onSubmit" message="Please provide a password"/>
					</p>
					<p id="p1">
						<cfinput type="submit" name="submit" id="sumbit" value="Login"/>
					</p>
					
				
			</cfform>
		</section>
	
		
		<p>
			
		</p>
	</body>
</html>