<!--- Define application variables --->
<cfapplication 
name="ReportBuilder" 
datasource="MEDICALDATA"
sessionmanagement="true" 
sessiontimeout="#CreateTimeSpan(0,0,30,0)#"
>

<cfsetting
showDebugOutput=no
>