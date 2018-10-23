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
		
	</cfif>
</cfif>

<html>
	<head>
		<link rel="stylesheet" href="css/bootstrap.css">
		<title>RDE Login Page</title>
		<style>
			body {
				height:100%;
       			background-image: url("images/background.jpg");
        		background-position: center;
   				background-repeat: no-repeat;
   				background-size: cover;
			}
		</style>
	
	</head>
	<body>
		<nav class="navbar navbar-default">
		<div class="container-fluid">
		<a class="navbar-brand" href="#">
			 <img src="images/rde_logo_white.png" width="auto" height="100%" alt="">
		</a>
		<ul class="nav navbar-nav">
			 <li class="active"><a href="#home">RDE Systems</a></li>
			 <li><a href="#home" onclick="location.href='http://rde.org/'">Home </a></li>
			 <li><a href="#contact">Support</a></li>
		</ul>
		 <ul class="nav navbar-nav navbar-right">
			 <li style="float:right"><a href="#home" onclick ="location.href='http://127.0.0.1:8500/rde/insert.cfm'">New Member?</a></li>
		</ul>
	</div>
	</nav>
		<p>
						
		<section>
			<center><font size="10"><b>RDE Login </b> </font>
					</p>
		
			<div class="col-md-5">
				<!-- left column -->
			</div>
			<!--- Login Form --->
			<cfform name="LoginForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
				<div class="form-group col-md-2">
					<!-- center column -->
				
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
						The Username and or Password you entered was invalid. Please try again.
					</p>
				</cfif>
					
					
					
					<p>
						<center>Username: <br>
						<cfinput type="text" name="User" id="User" class="form-control" required="true"
						         validateat="onSubmit" message="Please provide a username"/>
					</p>
					<p>
						<center>Password: <br>
						<cfinput type="password" name="Pass" id="Pass" required="true" class="form-control"
						         validateat="onSubmit" message="Please provide a password"/>
					</p>

					
					<p id="p1">
						
						<cfinput type="submit" name="submit" id="sumbit" value="Login" class="btn btn-primary mb-2"/>
						
					</p>
					
				</div>
			</cfform>
			<div class="col-md-5">
				<!-- Right column -->
			</div>
		</section>
		
		<p>
			
		</p>
	</body>
</html>
