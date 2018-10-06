<cfif structKeyExists(form, 'submit')>

	<!---serverside validation--->
	<cfif len(trim(form.First)) NEQ "" AND len(trim(form.Last)) NEQ "" AND len(trim(form.User)) NEQ "" 
	      AND len(trim(form.Pass)) NEQ "">
	
		<cfscript>
			salt = "A41n9t0Q";
			password = "Password123";
			PBKDFalgorithm = "PBKDF2WithHmacSHA512";
			PassToEnc = "#form.Pass#";
			encryptionAlgorithm = "AES";
			PassKey = GeneratePBKDFKey(PBKDFalgorithm, password, salt, 4096, 128);
			encryptedPass = encrypt(PassToEnc, PassKey, encryptionAlgorithm, "Base64");
			writeOutput(encryptedPass);
		</cfscript>
		
		<cfset HashPass = encryptedPass/>
		<cfset UserSalt = salt/>
	
		<cfquery name="insert" datasource="MS_SQL_Server">
			INSERT INTO TestHash(FirstName, LastName, Username, Password, salt, Role)
			VALUES ('#form.First#', '#form.Last#', '#form.User#', '#HashPass#', '#UserSalt#', '1');
		</cfquery>
	
		<cfscript>
			salt = "A41n9t0Q";
			password = "Password123";
			PBKDFalgorithm = "PBKDF2WithHmacSHA512";
			PassToDec="#HashPass#";
			derivedKey = GeneratePBKDFKey(PBKDFalgorithm, password, salt, 4096, 128);
			decryptedData = decrypt(PassToDec, derivedKey, encryptionAlgorithm, "BASE64");
			writeoutput("Data After Decryption using PBKDF2: " & decryptedData);
		</cfscript>
		
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