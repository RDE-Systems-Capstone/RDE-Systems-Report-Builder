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
		<cfoutput>
			<p>
				Registered!
			</p>
		</cfoutput>
	</cfif>
</cfif>
<html>
<head>
	
<link rel="stylesheet" href="css/bootstrap.css">
		<title>User Registration</title>
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
		<nav class="navbar navbar-default">
			<div class="container-fluid">
			<a class="navbar-brand" href="#">
				 <img src="images/rde_logo_white.png" width="auto" height="100%" alt="">
			</a>
			<ul class="nav navbar-nav">
				 <li class="active"><a href="index.cfm#home">RDE Systems</a></li>
				 <li><a href="#home" onclick="location.href='http://rde.org/'">Home </a></li>
				 <li><a href="#contact">Support</a></li>
			</ul>
			 
			</div>
		</nav>
						
			<div class="col-lg-4">
				<!-- left column -->
			</div>
	<cfoutput>
	<!---Registration form--->
	<cfform name="RegisterForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
		<div class="form-group col-lg-4 text-center">
			<h1>
				User Registration
			</h1>
			<div class="well">
				<h2>
					Please Enter the Following:
				</h2>
				<br />
			<p>
				<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
				
				<cfinput type="text" name="First" id="First" required="true" class="form-control" placeholder="First Name"
				         validateat="onSubmit" message="Please provide a first name"/>
				</div>
			</p>
			<p>
				<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
				
				<cfinput type="text" name="Last" id="Last" required="true" class="form-control" placeholder="Last Name"
				         validateat="onSubmit" message="Please provide a last name"/>
				</div>
			</p>
			<p>
				<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
				 
				<cfinput type="text" name="User" id="User" class="form-control" placeholder="Username" required="true"
						         validateat="onSubmit" message="Please provide a username"/>
				</div>
			</p>
			<p>
				<div class="input-group">
						<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
				
				<cfinput type="password" name="Pass" id="Pass" required="true" class="form-control" placeholder="Password"
						         validateat="onSubmit" message="Please provide a password"/>
				</div>
			</p>
			<p id="p1">
				<cfinput type="submit" name="submit" id="sumbit" value="Register"/>
			</p>
			</div>
		</div>
	</cfform>
</cfoutput>	
<div class="col-lg-4">
				<!-- Right column -->
			</div>
</body>
</html>

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
	<cfreturn l.string>
</cffunction>
