<cfcomponent output="false">
	<!---vaidate user mthd--->
	<cffunction name="vaidateUser" access="public" output="false" returntype="array">
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
		
		<!---Get data from DB--->
		<cfquery name="userLogin">
			SELECT Login.Usr, Login.Pwd, Login.Role
			FROM Login
			WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" > AND <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" >
		</cfquery>
		
		<!---Check if query returns only one user--->
		<cfif userLogin.recordCount eq 1>
		
			<!---Log user in--->
			<cflogin >
				<cfloginuser name="#userLogin.Usr#" password="#userLogin.Pwd#" roles="#userLogin.Role#" >
			</cflogin>
			<!---Save user data in session scope--->
			<cfset session.stLoggedInUser = {'username' = userLogin.Usr} />
			<!---Change isUserLoggedIn to true--->
			<cfset var isUserLoggedIn = true />
		
		
		</cfif>
		<!---Return isUserLoggedIn var--->
		<cfreturn isUserLoggedIn />
	</cffunction>
	<!---doLogout mthd--->
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from session scope--->
		<cfset structdelete(session,'stLoggedInUser') />
		
		<!---logout user--->
		<cflogout />
		
	</cffunction>

</cfcomponent>