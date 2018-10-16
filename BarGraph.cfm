<!-- cf form

<cfdump var= '#form#'/>

-->
<style>
	body{
	background-color: lightblue;
	}
	section{
	background-color: lightblue;
	border-radius: 1em;
	padding: 1em;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-right: -50%;
	transform: translate(-50%, -50%)
	}
	table {
    width: auto;
}
div{
	display : table-cell;
	text-align: center;
	vertical-align: middle;
	width: 500px;
	padding:5rem;
	height: 200px;
	margin:auto;
	border:3px solid # 73AD21;
	
}
</style>
<CFQUERY NAME="MEDICALDATA" DATASOURCE="MEDICALDATA">
select race, count(*) as total 
From patients
Group BY race with rollup;
</CFQUERY>
<cfset temp = MEDICALDATA.recordCount-1 > 

<!---<cfscript>
	for (i=1; i<= temp ; i++){
		writeOutput (MEDICALDATA["RACE"][i]);
		writeOutput (":");
		writeOutput (MEDICALDATA["total"][i]);
		writeOutput ("<br/>");				
	}
</cfscript>--->

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Query</title>
		<script src="jquery-2.1.4.min.js"></script>
		<script src="Chart.js"></script>
		<script src="https://cdnjs.com/libraries/Chart.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>
</head>

<body>
<div class= "right-half" >
<TABLE id= "myTable" CELLPADDING="3" CELLSPACING="0" width = "400" border="2">
<TR BGCOLOR="#888888">
    <TH>RACE</TH>
    <TH>TOTAL</TH>
</TR>
<CFOUTPUT QUERY="MEDICALDATA">
<TR BGCOLOR="##C0C0C0">
   <TD>#RACE#</TD>
    <TD>#TOTAL#</TD>
</TR> 
</CFOUTPUT>
<cfset Sum_data = MEDICALDATA ["total"][temp+1]>
<cfset temp1= MEDICALDATA["total"][1]>
<!--
<cfoutput> <cfset temp2 = ((#VAL(temp1)#*360)/#Val(Sum_data)#)>
	#Sum_data#, #temp2#, #temp1#<br>
 </cfoutput> 
 -->
</TABLE>
</div>

<cfset labels = ArrayNew(1)>
<cfset values = ArrayNew(1)>
<cfloop index="i" from="1" to="#temp#">
	<cfoutput>
	<cfset labels[i]= MEDICALDATA["RACE"][i]>
	<cfset temp2= MEDICALDATA["total"][i]>
	<cfset values[i] = Round ((#VAL(temp2)#*360)/#Val(Sum_data)#)>
	</cfoutput>
</cfloop>

<!---#ToScript(labels, "jsArray")#
#ToScript(values, "jArray")#--->
<!-- <cfwddx action="cfml2js" input="#labels#" output="returnString" topLevelVariable="returnArray">-->

<div class="left-half" width= "1500" height= "1500">
<canvas id="myChart" >
<script type= "text/javascript" language="Javascript"> 
	/*converting coldfusion array into javascript */	
<cfoutput>
 var #ToScript(labels, "jsArray")#;
 var #ToScript(values, "jArray")#;
 var tableArr= [];
</cfoutput>

var table = document.getElementById("myTable");
var tableLen = table.rows.length
var data = {labels: [], total:[] }

for (var i = 0; i < tableLen-1; i++) {
  data.labels.push(jsArray[i])
  data.total.push(jArray[i])
}
var ctx = document.getElementById("myChart").getContext('2d');
var myChart = new Chart(ctx, {
  type: 'bar',
  data: {
    labels:data.labels,
    datasets: [{
    	label: "Race ",
    	data : data.total,
      backgroundColor: [
        "#2ecc71",
        "#3498db",
        "#95a5a6",
        "#9b59b6"
      ]
    }]

  }
});
		</script>
		</div>
	</body>
</html>