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
	FROM -patients- INNER JOIN -conditions- INNER JOIN -observations- INNER JOIN -medications- INNER JOIN -immunizations-<br />
	WHERE
</cfoutput>
<!--- Looping Through deserialized JSON Array --->
<cfloop array="#decodedArr#" index="i">
	<!--- Checking Type, display according output --->
	
	<!---Boolean Logic--->
	<cfif #i.type# eq "l_paren">
		<cfoutput >
			(
		</cfoutput>
		
	<cfelseif #i.type# eq "r_paren">
		<cfoutput >
			)
		</cfoutput>	
		
	<cfelseif #i.type# eq "and">
		<cfoutput >
			AND
		</cfoutput>
		
	<cfelseif #i.type# eq "or">
		<cfoutput >
			OR
		</cfoutput>	
		
	<!---Filter Options--->	
	<cfelseif #i.type# eq "age">
		<cfset minVal = #i.min#>
		<cfset maxVal = #i.max#>		
		<cfoutput >
			age BETWEEN #minVal# AND #maxVal#
		</cfoutput>

	<cfelseif #i.type# eq "gender">
		<!-- Array -->
		<cfset patientGender = #i.values#>
		<cfoutput >
			gender EQ (
		</cfoutput>
		
		<cfset myArr = #i.values#>
		<cfloop from="1" to="#arrayLen(myArr)#" index="j">
			<cfif #j# eq #arrayLen(myArr)#>
				<cfoutput >
					#myArr[j]# )
				</cfoutput>
			<cfelse>
				<cfoutput >
				 #myArr[j]# OR
				</cfoutput>
			</cfif>
		</cfloop>

	<cfelseif #i.type# eq "race">
		<!-- Array -->
		<cfoutput >
			race EQ (
		</cfoutput>
		
		<cfset myArr = #i.values#>
		<cfloop from="1" to="#arrayLen(myArr)#" index="j">
			<cfif #j# eq #arrayLen(myArr)#>
				<cfoutput >
					#myArr[j]# )
				</cfoutput>
			<cfelse>
				<cfoutput >
				 #myArr[j]# OR
				</cfoutput>
			</cfif>
		</cfloop>

	<cfelseif #i.type# eq "ethnicity">
	<!-- Array -->
		<cfoutput >
			ethnicity EQ (
		</cfoutput>
		
		<cfset myArr = #i.values#>
		<cfloop from="1" to="#arrayLen(myArr)#" index="j">
			<cfif #j# eq #arrayLen(myArr)#>
				<cfoutput >
					#myArr[j]# )
				</cfoutput>
			<cfelse>
				<cfoutput >
				 #myArr[j]# OR
				</cfoutput>
			</cfif>
		</cfloop>	
		
	<cfelseif #i.type# eq "marital">
		<!-- Array -->
		<cfoutput >
			marital EQ (
		</cfoutput>
		
		<cfset myArr = #i.values#>
		<cfloop from="1" to="#arrayLen(myArr)#" index="j">
			<cfif #j# eq #arrayLen(myArr)#>
				<cfoutput >
					#myArr[j]# )
				</cfoutput>
			<cfelse>
				<cfoutput >
				 #myArr[j]# OR
				</cfoutput>
			</cfif>
		</cfloop>
		
	<cfelseif #i.type# eq "conditions">
	<cfset cond = #i.id#>
		<cfoutput >
			conditions EQ #cond#
		</cfoutput>
		
	<cfelseif #i.type# eq "observations">
	<cfset observ = #i.id#>
	<cfset option = #i.options#>
		<cfif #option# eq 'greater'>
			<cfset opt = 'GT'>
		</cfif>
		<cfif #option# eq 'less'>
			<cfset opt = 'LT'>
		</cfif>
		<cfif #option# eq 'equal'>
			<cfset opt = 'GT'>
		</cfif>
	<cfset val = #i.value#>
		<cfoutput >
			observations EQ #observ# #opt# #val#
		</cfoutput>
		
	<cfelseif #i.type# eq "medications">
	<cfset meds = #i.id#>
		<cfoutput >
			medications EQ #meds#
		</cfoutput>
		
	<cfelseif #i.type# eq "immunizations">
		<cfset immun = #i.id#>
		<cfoutput >
			immunizations EQ #immun#
		</cfoutput>
		
	<cfelseif #i.type# eq "allergies">
		<cfset alerg = #i.id#>
		<cfoutput >
			allergies EQ #alerg#
		</cfoutput>	
		
	<cfelseif #i.type# eq "encounters">
		<cfset encoun = #i.id#>
		<cfoutput >
			encounters EQ #encoun#
		</cfoutput>
		
	<cfelseif #i.type# eq "procedures">
		<cfset proced = #i.id#>
		<cfoutput >
			procedures EQ #proced#
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
		<a href="builder.cfm">
			Builder
		</a>
		<p>
			
		</p>
		<p>
			
		</p>
		<a href="app/logout.cfm">
			Logout
		</a>
	</body>
</html>