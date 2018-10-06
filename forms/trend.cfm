<!--- Trend Output form --->

<cfquery name="observations_list">
    SELECT DISTINCT DESCRIPTION, CODE FROM observations ORDER BY DESCRIPTION
</cfquery>

<p>Select value to graph over time</p>
<cfform name="trend_output">
	<cfselect 
		name="trend_observation"
		query="observations_list"
		message="Select a value to graph"
		display="DESCRIPTION"
		value="CODE"
		class="form-control">
		<option selected="true" disabled="disabled"> -- select an option -- </option>
	</cfselect>
</cfform>