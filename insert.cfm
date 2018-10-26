
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
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pageType="login" activePage="insert"></cfinvoke>
	<div class="row">
		<div class="col-lg-4">
			<!-- left column -->
		</div>

		<cfoutput>
		<div class="form-group col-lg-4 text-center">
			<!---Registration form--->
			<cfform name="RegisterForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
				<!--- Check for successful registration --->
				<cfif structKeyExists(form, 'submit')>

					<!---serverside validation--->
					<cfif len(trim(form.First)) NEQ "" AND len(trim(form.Last)) NEQ "" AND len(trim(form.User)) NEQ "" 
					      AND len(trim(form.Pass)) NEQ "">
					      
					    <cfset rand = generateSecureRandomString(length=64) />
					      
					    <cfscript>
							salt = '#rand#';
							PBKDFalgorithm = "PBKDF2WithHmacSHA512";
							PassKey = GeneratePBKDFKey(PBKDFalgorithm, Trim(form.Pass), salt, 4096, 128);
						</cfscript>
							
						<cfset HashPass = PassKey/>
						<cfset UserSalt = salt/>
					
						<!---Inserting Data into DB--->
						<cfquery name="insert" datasource="MEDICALDATA">
							INSERT INTO users(firstName, lastname, username, password, salt, role)
							VALUES ('#form.First#', '#form.Last#', '#form.User#', '#HashPass#', '#UserSalt#', '1');
						</cfquery>
					
						<!---Display user feedback--->		
						<div class="alert alert-success">
						  <strong>Success!</strong> Your account has been registered!
						</div>
					</cfif>
				</cfif>

				<h1>User Registration</h1>
				<div class="well">
					<div class="input-group">
						<span class="input-group-addon">First Name</span>
						<cfinput type="text" name="First" id="First" required="true" class="form-control" validateat="onSubmit" message="Please provide a first name"/>
					</div>
					<br />
					<div class="input-group">
						<span class="input-group-addon">Last Name</span>
						<cfinput type="text" name="Last" id="Last" required="true"
						         class="form-control" validateat="onSubmit" message="Please provide a last name"/>
					</div>
					<br />
					<div class="input-group">
						<span class="input-group-addon">Username</span>
						<cfinput type="text" name="User" id="User" required="true"
						         class="form-control" validateat="onSubmit" message="Please provide a username"/>
					</div>
					<br />
					<div class="input-group">
						<span class="input-group-addon">Password</span>
						<cfinput type="password" name="Pass" id="Pass" required="true"
						         class="form-control" validateat="onSubmit" message="Please provide a password"/>
					</div>
					<br />
					<div>
						<cfinput type="submit" name="submit" id="sumbit" value="Register" class="btn btn-primary mb-2" />
					</div>
				</div>
			</cfform>
		</div>
		</cfoutput>

		<div class="col-lg-4">
			<!-- Right column -->
		</div>
	</div>

	<!--- Footer --->
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>

	<!---generates random secure string--->
	<cffunction name="generateSecureRandomString" output="false">
		<cfargument name="length" type="numeric">
		<cfset var l = {}>

		<cfset l.generator = CreateObject("java", "java.security.SecureRandom")>

		<!---A list of unambiguous, URL-friendly characters--->
		<cfset l.validChars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'>
		<cfset l.string = ''>
		<cfloop index="l.i" from="1" to="#arguments.length#">
			<!---nextInt returns a number from 0 to n-1, so we need to add 1 to get valid ColdFusion string indexes--->
			<cfset l.pos = l.generator.nextInt( len(l.validChars) ) + 1>

			<cfset l.string &= Mid(l.validChars, l.pos, 1)>
		</cfloop>
		<cfreturn l.string />
	</cffunction>

	</body>
</html>
