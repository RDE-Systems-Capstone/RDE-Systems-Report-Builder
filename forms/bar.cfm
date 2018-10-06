<!--- Bar Chart Output form --->

<cfquery name="observations_list">
    SELECT DISTINCT DESCRIPTION, CODE FROM observations ORDER BY DESCRIPTION
</cfquery>

<p>Select value to graph</p>
<cfform name="pie_output">
	<p>Group by:</p>
	<cfselect 
		name="pie_group"
		message="Select a value to graph"
		class="form-control">
		<option selected="true" disabled="disabled"> -- select an option -- </option>
		<option value="age">Age</option>
		<option value="gender">Gender</option>
		<option value="ethnicity">Ethnicity</option>
		<option value="race">Race</option>
		<option value="marital">Marital</option>
	</cfselect>
</cfform>