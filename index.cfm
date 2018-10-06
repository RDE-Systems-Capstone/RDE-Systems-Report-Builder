<cfapplication name="cfcentral" sessionmanagement="true" sessiontimeout="#CreateTimeSpan(0,0,30,0)#"/>

<!---Handles logout--->
<cfif structKeyExists(URL, 'logout')>
	<cfset createObject("component", 'CF Projects.RDE Systems.app.Authentification').doLogout()/>
</cfif>
<!--- Processing Entered Data --->
<cfif structKeyExists(form, 'submit')>
	<!---Create instance of authentification service component--->
	<cfset authenticationService = createobject("component", 
	                                            'CF Projects.RDE Systems.app.Authentification')/>
	<!---serverside validation--->
	<cfset aErrorMessages = authenticationService.validateUser(form.User, form.Pass)/>
	<cfif ArrayIsEmpty(aErrorMessages)>
		<!---Proceed to login--->
		<cfset isUserLoggedIn = authenticationService.doLogin(form.User, form.Pass)/>
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
				<cfif structKeyExists(session, 'stLoggedInUser')>
					<!---display welcome--->
					<!-- <script type="text/javascript">
						window.open("/CF Projects/RDE Systems/Success.cfm", 'self');
					</script> -->
					
					<!--<p>
						<cfoutput>Welcome!</cfoutput>
					</p>
					<p>
						<a href="/CF Projects/RDE Systems/index.cfm?logout">
							Logout
						</a>
					</p> -->
					<cflocation url="/CF Projects/RDE Systems/Success.cfm" >
					
				<cfelse>
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
					<!---Different Login form--->
					<!-- 
					<dl>
						<dt>
							<label for="User">
								Username:
							</label>
						</dt>
						<dd>
							<cfinput type="text" name="User" id="User" required="true"
							         validateat="onSubmit" message="Please provide a username"/>
						</dd>
						<dt>
							<label for="Pass">
								Password:
							</label>
						</dt>
						<dd>
							<cfinput type="password" name="Pass" id="Pass" required="true"
							         validateat="onSubmit" message="Please provide a password"/>
						</dd>
					</dl>
					<p>
						<cfinput type="submit" name="submit" id="sumbit" value="Login"/>
					</p>
					-->
				</cfif>
			</cfform>
		</section>
	</head>
	<body>
		<p>
			debugging window: (will remove later)
		</p>
	</body>
</html>

<script>
	function testFunc(){
	var redirect=window.open("http://localhost:8500/CF%20Projects/RDE%20Systems/Landing.cfm","_self");
	}
</script>