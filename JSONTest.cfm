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
<cfloop array="#decodedArr#" index="i">
	<cfif #i.type# eq "l_paren">
		<cfoutput >
			(
		</cfoutput>

	<cfelseif #i.type# eq "age">
		<cfoutput >
			age GT min AND LT max
		</cfoutput>

	<cfelseif #i.type# eq "and">
		<cfoutput >
			AND
		</cfoutput>

	<cfelseif #i.type# eq "gender">
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
		<cfoutput >
			race EQ race(s)
		</cfoutput>

	<cfelseif #i.type# eq "ethnicity">
		<cfoutput >
			ethnicity EQ ehnicity/ies
		</cfoutput>
		
	<cfelseif #i.type# eq "marital">
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
		
		<cfoutput >
			#FORM.query_string#
		</cfoutput>
	</head>
	<body>
		<br />
		<br />
		<a href="app/logout.cfm">
			Logout
		</a>
	</body>
</html>