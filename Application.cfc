<cfcomponent output="false">
	<cfset this.name = 'RDE_Report_Builder' />
	<cfset this.applicationTimeout = createTimespan(0,0,30,0) />
	<cfset this.sessionManagement = "yes" />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />
	<cfset this.setClientCookies = "yes" />
	<cfset this.datasource = 'MEDICALDATA' />
	<cfset this.mappings["/app"] = getDirectoryFromPath(getCurrentTemplatePath()) & "app/" />
	<cfsetting showdebugoutput="no" />
</cfcomponent>