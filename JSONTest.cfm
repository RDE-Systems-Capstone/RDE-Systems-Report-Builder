<!--- deserialize JSON output --->
<cfset decodedArr = deserializeJSON(#FORM.query_string#)>
<cfoutput >
	<h2>Testing Looping Through JSON Array</h2>
	<h3>
		Faux SQL Query
	</h3>
</cfoutput>
<cfoutput >
	SELECT * <br />
	FROM -Insert Tables(s)- <br />
	WHERE
</cfoutput>
<!--- Looping Through deserialized JSON Array --->
<cfloop array="#decodedArr#" index="i">
	<!--- Checking Type, display according output --->
	<cfif #i.type# eq "l_paren">
		<cfoutput >
			(
		</cfoutput>

	<cfelseif #i.type# eq "age">
		<cfset minVal = #i.min#>
		<cfset maxVal = #i.max#>		
		<cfoutput >
			age BETWEEN #minVal# AND #maxVal#
		</cfoutput>

	<cfelseif #i.type# eq "and">
		<cfoutput >
			AND
		</cfoutput>

	<cfelseif #i.type# eq "gender">
		<!-- Array -->
		<cfset patientGender = #i.values#>
		<cfoutput >
			gender EQ gender(s)
		</cfoutput>

	<cfelseif #i.type# eq "r_paren">
		<cfoutput >
			)
		</cfoutput>

	<cfelseif #i.type# eq "or">
		<cfoutput >
			OR
		</cfoutput>

	<cfelseif #i.type# eq "race">
		<!-- Array -->
		<cfoutput >
			race EQ race(s)
		</cfoutput>

	<cfelseif #i.type# eq "ethnicity">
		<!-- Array -->
		<cfoutput >
			ethnicity EQ ehnicity/ies
		</cfoutput>
		
	<cfelseif #i.type# eq "marital">
		<!-- Array -->
		<cfoutput >
			marital EQ marital status
		</cfoutput>
		
	<cfelseif #i.type# eq "conditions">
		<cfoutput >
			conditions EQ condition(s)
		</cfoutput>
		
	<cfelseif #i.type# eq "observations">
		<cfoutput >
			observations EQ observation
		</cfoutput>
		
	<cfelseif #i.type# eq "medications">
		<cfoutput >
			medications EQ medication
		</cfoutput>
	</cfif>
</cfloop>

<html >
	<head>
		<h1>
			Original JSON Output
		</h1>
		
		<!--- Outputting this for reference --->
		<cfoutput >
			#FORM.query_string# <br />
			<p>
				<!-- break line -->
			</p>
		</cfoutput>
		<!--- Outputting cfdump for more reference --->
		<cfset FilterBool="#deserializeJSON(FORM.query_string)#">
			<cfloop array = #FilterBool# item="item">
				<cfoutput>#item["type"]#</cfoutput>
				<cfdump var="#item#">
			</cfloop>
	</head>
	<body>
		<br />
		<br />
		<a href="app/logout.cfm">
			Logout
		</a>
	</body>
</html>