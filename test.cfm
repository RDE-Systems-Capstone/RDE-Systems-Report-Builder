<cfif isDefined("FORM.UserLogin")>
 <cfinclude template="LoginCheck.cfm">
</cfif>



<html>
<head>
 <title>Please Log In</title>
</head>

<!--- Start our Login Form --->
<cfform action="#CGI.script_name#?#CGI.query_string#" name="LoginForm" method="post">
 <!--- Make the UserLogin and UserPassword fields required --->
 <input type="hidden" name="userLogin_required">
 <input type="hidden" name="userPassword_required">
 <!--- Use an HTML table for simple formatting --->
 <table border="0">
 <tr><th colspan="2" bgcolor="silver">Please Log In</th></tr>
 <tr>
 <th>Username:</th>
 <td>

 <!--- Text field for "User Name" --->
 <cfinput
 type="text"
 name="userLogin"
 size="20"
 value=""
 maxlength="100"
 required="Yes"
 message="Please type your Username first.">

 </td>
 </tr><tr>
 <th>Password:</th>
 <td>

 <!--- Text field for Password --->
 <cfinput
 type="password"
 name="userPassword"
 size="12"
 value=""
 maxlength="100"
 required="Yes"
 message="Please type your Password first.">

 <!--- Submit Button that reads "Enter" --->
 <input type="Submit" value="Enter">

 </td>
 </tr>
 </table>

</cfform>

</body>
</html>

<!-- <cfform name="loginform" action="#CGI.script_name#?#CGI.query_string#" method="Post">
	<table>
		<tr>
			<td>
				user name:
			</td>
			<td>
				<cfinput type="text" name="j_username" required="yes" message="A user name is required">
			</td>
		</tr>
		<tr>
			<td>
				password:
			</td>
			<td>
				<cfinput type="password" name="j_password" required="yes" message="A password is required">
			</td>
		</tr>
	</table>
	<br>
	<input type="submit" value="Log In">
</cfform> -->

<!-- <table>
						<tr>
							<td>
								Username: 
							</td>
							<td>
								<cfinput type="text" id="User" name="User"  />
							</td>
						</tr>
						<tr>
							<td>
								Password: 
							</td>
							<td>
								<cfinput type="password" id="Pass" name="Pass"  />
							</td>
						</tr>
						<tr>
							<td>
								<!--- testing submit functions --->
								
								<!--- Clears entry fields. why? --->
								<input type="submit" name="submit" value="Log In">
								</input>
								
								<!--- "redirecting" to different site --->
								
								<!--- works only with blank fields. why? --->
								<!-- 
								<input type="submit" value="Log In" onclick="testFunc()">
								</input>
								-->
							</td>
						</tr>
					</table> -->