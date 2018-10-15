<cfcomponent output="false">
	<cfset this.sessionManagement = true />
	<cfset this.clientManagement = true />
	
	
	<!---vaidate user mthd--->
	<cffunction name="validateUser" access="public" output="false" returntype="array">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
	
		<cfset var aErrorMessages = ArrayNew(1) />
		<!---validate user--->
		<cfif arguments.username eq ''>
			<cfset arrayAppend(aErrorMessages, 'Please provide a username.')>
		</cfif>
		<!---validate pass --->
		<cfif arguments.password eq ''>
			<cfset arrayAppend(aErrorMessages, 'Please provide a password.')>
		</cfif>
		
		<cfreturn aErrorMessages />
	
	</cffunction>
	<!---doLogin mthd--->
	<cffunction name="doLogin" access="public" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		<!---Create isUserLoggedIn var--->
		<cfset var isUserLoggedIn = false />
		
		<cfset tempvar = "#arguments.password#" />
		
		<!---Get data from DB--->
		<cfquery name="userLogin" datasource="MEDICALDATA" >
			SELECT users.username, users.password, users.role, users.salt, users.firstName, users.lastname
			FROM users
			WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<!--add if exists, go forward. else display error here.-->
		
		<cfscript>
			// Correct procedure for checking password on login
			salt = '#userLogin.salt#';
			PBKDFalgorithm = "PBKDF2WithHmacSHA512";
			PassKey = GeneratePBKDFKey(PBKDFalgorithm, Trim(form.Pass), salt, 4096, 128);
			writeOutput(PassKey); // check against database
		</cfscript>
		
		<cfset decPass = PassKey />
				
		<!---Check if query returns only one user--->
		<cfif compare(decPass, userLogin.password) eq 0>
		
			<!---Log user in--->
			<cflogin allowconcurrent="false" applicationtoken="test" idletimeout="300">
				<cfloginuser name="#userLogin.firstName# #userLogin.lastname#" password="#decPass#" roles="#userLogin.role#" >
				
			</cflogin>

			<!---Save user data in session scope--->
			<cfset session.stLoggedInUser = {'FirstName' = userLogin.FirstName, 'LastName' = userLogin.LastName} />
			<!---Change isUserLoggedIn to true--->
			<cfset var isUserLoggedIn = true />		
			
			<cflocation url="builder.cfm" addtoken="false" >
		
		<cfelse>
			<cfset var isUserLoggedIn = false />
		</cfif>
		<!---Return isUserLoggedIn var--->
		<cfreturn isUserLoggedIn />
	</cffunction>
	<!---doLogout mthd--->
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from session scope--->
		
		
		<cfloop item="name" collection="#cookie#">
			<cfcookie name="#name#"  expires="now">
		</cfloop>
		
		
		
		<!---logout user--->
		<cflogout />
		
	</cffunction>
	
	<!---Not sure if needed--->
	

</cfcomponent>