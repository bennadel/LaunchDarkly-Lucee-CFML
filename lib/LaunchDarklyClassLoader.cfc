component
	output = false
	hint = "I provide class loading methods for the LaunchDarkly server-side SDK."
	{

	/**
	* I initialize the class loader proxy.
	*/
	public void function init() {

		// NOTE: One of the coolest features of Lucee CFML is the fact that it can create
		// Java objects on-the-fly from a given set of JAR files and directories. I mean,
		// how awesome is that?! These JAR files were downloaded from Maven:
		// --
		// https://mvnrepository.com/artifact/com.launchdarkly/launchdarkly-java-server-sdk/5.6.2
		variables.jarPaths = [ expandPath( "/vendor/launchdarkly-5.6.2/" ) ];

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I load the given class out of the local LaunchDarkly JAR paths.
	*/
	public any function load( required string className ) {

		return( createObject( "java", className, jarPaths ) );

	}

}
