<!---
Code for unified website elements
Built using Bootstrap/ColdFusion

RDE Systems Capstone Fall 2018
Group members: Vincent Abbruzzese, Christopher Campos, Joshua Pontipiedra, Priyankaben Shah
--->

<cfcomponent>
	<!--- outputHeader: Function to output a header --->
	<cffunction name="outputHeader" returntype="void">
		<cfargument name="pageType" type="string" required="true" />
		<cfargument name="activePage" type="string" required="true" />
			<!-- Begin outputing navbar code-->
			<nav class="navbar navbar-default">
			  <div class="container-fluid">
				<div class="navbar-header">
				  <a class="navbar-brand" href="https://www.rde.org/">
					<img src="images/rde_logo_white.png" width="auto" height="100%" alt="">
				  </a>
				</div>
				<ul class="nav navbar-nav">
					<!--- output different if login or builder page --->
					<cfif pageType eq "builder">
						<!---Builder page --->
						<!--- If statements to check active page and output active element appropiately --->
						<cfif activePage eq "builder">
							<li class="active">
						<cfelse>
							<li>
						</cfif><a href="builder.cfm">Builder</a></li>
						<cfif activePage eq "output">
							<li class="active">
						<cfelse>
							<li>
						</cfif>
						<a href="output.cfm">Output</a></li>
						<cfif activePage eq "saved_reports">
							<li class="active">
						<cfelse>
							<li>
						</cfif>
						<a href="#">Saved Reports</a></li>
					<cfelseif pageType eq "login">
						<!--- Login page --->
						<cfif activePage eq "login">
							<li class="active">
						<cfelse>
							<li>
						</cfif><a href="index.cfm">Report Builder</a></li>
						<li><a href="#contact">Support</a></li>
					</cfif>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<cfif pageType eq "builder">
						<!---Builder page --->
						<li><a>Welcome <cfoutput>#session.FirstName# #session.LastName#</cfoutput></a></li>
						<li><a href="app/logout.cfm">Logout</a></li>
					<cfelseif pageType eq "login">
						<!--- Login page --->
						<cfif activePage eq "insert">
							<li class="active" style="float:right">
						<cfelse>
							<li style="float:right">
						</cfif><a href="insert.cfm">New Member?</a></li>
					</cfif>
				</ul>
			  </div>
			</nav>
	</cffunction>

	<!--- Code for a footer --->
	<cffunction name="outputFooter">
		<!--- ugly breaks but it works... --->
		<br /><br /><br />
		<div class="row">
			<div class="container-fluid" style="position: static">
				<div class="panel panel-default">
	        		<div class="panel-body">
	        			Copyright &copy; 2018 <img alt="RDE Systems Logo" src="images/tinylogorde.png" width="25" height="18"> RDE Systems, LLC. All rights reserved.
		        	</div>
		    	</div>
			</div>
		</div>
	</cffunction>
</cfcomponent>