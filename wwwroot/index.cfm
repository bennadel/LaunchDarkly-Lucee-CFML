<cfscript>

	// Get all of the feature flag variations targeted to the given user (with the given
	// set of custom properties).
	// --
	// NOTE: The LaunchDarkly client acts as RULES ENGINE that synchronizes all of the
	// targeting information defined in the remote dashboard with its in-memory data
	// structures. As such, in order to target a user based on a set of properties, you
	// MUST PROVIDE THOSE PROPERTIES at the time you evaluate the feature flags in the
	// application code. Think of this process as invoking a PURE FUNCTION - all inputs
	// must be provided to the variation evaluation algorithm.
	features = application.featureFlags.getFeatures(
		userKey = "user-12345",
		userProperties = [
			{
				name: "name",
				value: "Ben Nadel"
			},
			{
				name: "role",
				value: "admin"
			},
			{
				name: "favoriteMovies",
				value: [ "Terminator 2", "Running Man", "Twins", "True Lies" ]
			}
		]
	);

</cfscript>
<cfoutput>

	<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8" />
		<title>
			Using The LaunchDarkly Feature Flag Java SDK With Lucee CFML 5
		</title>
	</head>
	<body>

		<h1>
			Using The LaunchDarkly Feature Flag Java SDK With Lucee CFML 5
		</h1>

		<p>
			Here are the feature flags targeted at the current user as of
			#now().timeFormat( "HH:mm:ss TT" )#:
		</p>

		<cfdump
			var="#features#"
			label="Feature Flags"
		/>

	</body>
	</html>

</cfoutput>
