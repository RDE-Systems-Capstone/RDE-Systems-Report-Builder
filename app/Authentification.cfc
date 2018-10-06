<cfcomponent output="false">
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
		
		<cfset tempvar = "#arguments.password#">
		
		<cfscript>
			salt="A41n9t0Q";
	      	password="Password123";
	      	PBKDFalgorithm ="PBKDF2WithHmacSHA512";
	      	PassToEnc="#tempvar#";
	      	encryptionAlgorithm="AES";
	      	PassKey=GeneratePBKDFKey(PBKDFalgorithm ,password ,salt,4096,128);	      	
	      	decryptedData = encrypt(PassToEnc, PassKey, encryptionAlgorithm, "Base64" );
		</cfscript>
		
		<cfset decPass = decryptedData />
		<cfdump var="#decPass#" />
		
		<!---Get data from DB--->
		<cfquery name="userLogin" datasource="MS_SQL_Server" >
			SELECT TestHash.Username, TestHash.Password, TestHash.Role
			FROM TestHash
			WHERE Username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" /> AND Password = <cfqueryparam value="#decPass#" cfsqltype="cf_sql_varchar" />
		</cfquery>
				
		<!---Check if query returns only one user--->
		<cfif userLogin.recordCount eq 1>
		
			<!---Log user in--->
			<cflogin >
				<cfloginuser name="#userLogin.Username#" password="#userLogin.Password#" roles="#userLogin.Role#" >
			</cflogin>
			<!---Save user data in session scope--->
			<cfset session.stLoggedInUser = {'username' = userLogin.Username} />
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