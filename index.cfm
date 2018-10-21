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
<style>
	body,html {
		height:100%;
        background-image: url("images/background.jpg");
        background-position: center;
   		background-repeat: no-repeat;
   		background-size: cover;
        } 
    ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: #333;
}

li {
    float: left;
}

li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
}

li a:hover:not(.active) {
    background-color: #111;
}

.active {
    background-color: #4CAF50;
}
	section{
	border-radius: 1em;
	padding: 1em;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-right: -50%;
	transform: translate(-50%, -50%)
	}
	
	.button {
    background-color: #4CAF50;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
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
	<title>RDE Login Page</title>
	
	<body>
		<ul>
			 <li><img src="images/rde_logo_white.png" height="43" width="62"></li>
			 <li><a href="#home">RDE Systems</a></li>
			 <li><a href="#home">Home</a></li>
			 <li><a href="#contact">Support</a></li>
			 <li style="float:right"><a href="#home" onclick ="location.href='http://127.0.0.1:8500/rde/insert.cfm'">New Member?</a></li>
</ul>
		<p>
						
		<section>
			<center><font size="10"><b>RDE Login </b> </font>
					</p>
		
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
						The Username and or Password you entered was invalid. Please try again.
					</p>
				</cfif>
					
					
					
					<p>
						<center>Username: <br>
						<cfinput type="text" name="User" id="User" required="true"
						         validateat="onSubmit" message="Please provide a username"/>
					</p>
					<p>
						<center>Password: <br>
						<cfinput type="password" name="Pass" id="Pass" required="true"
						         validateat="onSubmit" message="Please provide a password"/>
					</p>

					
					<p id="p1">
						
						<cfinput type="submit" name="submit" id="sumbit" value="Login" />
						
					</p>
					
				
			</cfform>
		</section>
		
		<p>
			
		</p>
	</body>
</html>
