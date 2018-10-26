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
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
		<script src="js/bootstrap.min.js"></script>
	
	</head>
	<body>
		<!-- navbar code -->
		<cfinvoke component="app.elements" method="outputHeader" pageType="login" activePage="login"></cfinvoke>
			<div class="row-fluid">		
				<div class="col-lg-4">
					<!-- left column -->
				</div>
				<!--- Login Form --->
				<div class="form-group col-lg-4 text-center">
				<cfform name="LoginForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
						<!-- center column -->
					<h1>Visual Report Builder</h1>
					<div class="well">
					<cfif structKeyExists(variables, 'isUserLoggedIn') AND isUserLoggedIn EQ false>
							  <div class="alert alert-danger alert-dismissible fade in">
								<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
								<strong>Error!</strong> The Username and/or Password you entered was invalid. Please try again. 
							  </div>
					</cfif>
					<h2>Please login:</h2>
					<br />
					<cfif structKeyExists(variables, 'aErrorMessages') AND NOT ArrayIsEmpty(aErrorMessages)>
						<cfoutput>
							<cfloop array="#aErrorMessages#" item="message">
								<p class="errorMessage">
									#message#
								</p>
							</cfloop>
						</cfoutput>
					</cfif>
						<!-- Username -->
						<div class="input-group">
							<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
							<cfinput type="text" name="User" id="User" class="form-control" placeholder="Username" required="true"
							         validateat="onSubmit" message="Please provide a username"/>
						</div>
						<br />
						<!-- password -->
						<div class="input-group">
							<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
							<cfinput type="password" name="Pass" id="Pass" required="true" class="form-control" placeholder="Password"
							         validateat="onSubmit" message="Please provide a password"/>
						</div>
						<br />
						<!-- login button -->
						<div>
							<cfinput type="submit" name="submit" id="sumbit" value="Login" class="btn btn-primary mb-2"/>
						</div>			
					</div>
				</cfform>
				</div>
				<div class="col-lg-4">
					<!-- Right column -->
				</div>
			</div>
			<!--- Footer --->
			<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
	</body>
</html>
