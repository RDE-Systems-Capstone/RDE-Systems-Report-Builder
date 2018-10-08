component {
    this.name = "RDEReportBuilder";
    this.datasource = "MEDICALDATA";
    this.sessionManagement = true;
	this.applicationtimeout="#CreateTimeSpan(0,0,30,0)#";
	this.appBasePath = getDirectoryFromPath(getCurrentTemplatePath());

	function onRequestStart() {
		setting showDebugOutput="no"
	}
 }