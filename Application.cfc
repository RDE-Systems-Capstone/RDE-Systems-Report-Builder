<cfcomponent output="false">
	<cfset this.name = 'RDE_Login' />
	<cfset this.applicationTimeout = createTimespan(0,0,30,0) />
	<cfset this.sessionManagement = "yes" />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />
	<cfset this.setClientCookies = "yes" />
	<cfset this.datasource = 'MEDICALDATA' />
</cfcomponent>