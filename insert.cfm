<!---Check if user clicked submit button--->
<cfif structKeyExists(form, 'submit')>

	<!---serverside validation--->
	<cfif len(trim(form.First)) NEQ "" AND len(trim(form.Last)) NEQ "" AND len(trim(form.User)) NEQ "" 
	      AND len(trim(form.Pass)) NEQ "">
	      
	      <cfset rand = generateSecureRandomString(length=64) />
	      
	      <cfscript>
			salt = '#rand#';
			PBKDFalgorithm = "PBKDF2WithHmacSHA512";
			PassKey = GeneratePBKDFKey(PBKDFalgorithm, Trim(form.Pass), salt, 4096, 128);
			//writeOutput(PassKey); // checking password
			writeOutput(salt); // checking salt
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
<cfoutput>
	<!---Registration form--->
	<cfform name="RegisterForm" action="#CGI.script_name#?#CGI.query_string#" method="Post">
		<section>
			<h1>
				User Registration
			</h1>
			<p>
				First Name: 
				<cfinput type="text" name="First" id="First" required="true"
				         validateat="onSubmit" message="Please provide a first name"/>
			</p>
			<p>
				Last Name:&nbsp
				<cfinput type="text" name="Last" id="Last" required="true"
				         validateat="onSubmit" message="Please provide a last name"/>
			</p>
			<p>
				Username:&ensp; 
				<cfinput type="text" name="User" id="User" required="true"
				         validateat="onSubmit" message="Please provide a username"/>
			</p>
			<p>
				Password:&ensp; 
				<cfinput type="password" name="Pass" id="Pass" required="true"
				         validateat="onSubmit" message="Please provide a password"/>
			</p>
			<p id="p1">
				<cfinput type="submit" name="submit" id="sumbit" value="Register"/>
			</p>
		</section>
	</cfform>
</cfoutput>

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