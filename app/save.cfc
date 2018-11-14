<cfcomponent output="false" >
	<cfparam name="form.report_name" default="#form.report_name#">
	<cfparam name="form.comment" default="#form.comment#">
	<cfparam name="form.JSON" default="#form.JSON#">
	<cfquery name="save_data" datasource="MEDICALDATA">
		INSERT INTO test(report_name, comment, JSON)
		VALUES ('#form.report_name#', '#form.comment#', '#form.JSON#');
	</cfquery>
</cfcomponent>