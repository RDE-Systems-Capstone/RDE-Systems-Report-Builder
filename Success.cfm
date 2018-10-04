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
	#p1{
	text-align:center;
	}
</style>
<cfoutput>
	<html>
		<head>
			<section>
				<h1>
					Success! (link report builder here)
				</h1>
				<p id="p1">
					<a href="/CF Projects/RDE Systems/index.cfm?logout">
						Logout
					</a>
				</p>
			</section>
		</head>
		<body>
			<p>
				debugging: (will remove later)
			</p>
		</body>
	</html>
</cfoutput>