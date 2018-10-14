<!--- Code to perform logout --->
<cflock scope="Session" timeout="10" type="exclusive">
      <cfset structclear(session)>
</cflock>
<cflocation url="../index.cfm" addtoken="false">