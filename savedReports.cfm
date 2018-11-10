<!DOCTYPE html>
<html lang="en">
<head>
	<title>
		Report Builder
	</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/jquery-ui.css">
	<!-- Styling for range filters (age), makes it easier to see -->
	<style>
		.ui-slider-range { background: #729fcf; }
		.ui-slider-handle { border-color: #729fcf; }
		.verticalButton { cursor: move; }
		.div-focus {
		box-shadow: 0 0 20px #66afe9;
		}
	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js">

	</script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js">

	</script>
	<script src="js/drag.js">

	</script>
	<script src="js/forms.js">

	</script>
	<script src="js/bootstrap.min.js">

	</script>
</head>
<body>
	<!-- Navbar code-->
	<cfinvoke component="app.elements" method="outputHeader" pagetype="builder" activepage="builder">
	</cfinvoke>
	<div class="row-fluid">
		<div class="container-fluid">
			<div class="col-lg-4">
			
				<!--- add page output here --->
				
					<cfoutput >
						<h1>
							Temporary Page Output
						</h1>
					</cfoutput>
				
				<!--- end page output here --->
				
			</div>
		</div>
	</div>
	<cfinvoke component="app.elements" method="outputFooter"></cfinvoke>
</body>