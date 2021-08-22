component
	output = false
	hint = "I define the application settings and event handlers."
	{

	// Define application settings.
	this.name = "LaunchDarklyLuceeCFMLDemo";
	this.applicationTimeout = createTimeSpan( 0, 1, 0, 0 );
	this.sessionManagement = false;
	this.clientManagement = false;
	this.setClientCookies = false;
	this.scopeCascading = "strict";
	this.localMode = "modern";
	this.regex = {
		engine: "java"
	};

	// Define mappings to files outside of the webroot.
	this.mappings = {
		"/lib": "../lib/",
		"/vendor": "../vendor/"
	};

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I get called once at the start of the Lucee CFML application. This method is
	* implicitly blocking and single-threaded.
	*/
	public void function onApplicationStart() {

		var config = deserializeJson( fileRead( "../config/production.json" ) );

		application.launchDarklyClassLoader = new lib.LaunchDarklyClassLoader();

		application.featureFlags = new lib.FeatureFlags(
			classLoader = application.launchDarklyClassLoader,
			sdkKey = config.launchDarkly.sdkKey
		);

	}


	/**
	* I get called once at the start of each HTTP request to a Lucee CFML script.
	*/
	public void function onRequestStart() {

		// The "init" flag restarts the ColdFusion application, which is needed since
		// the FeatureFlags ColdFusion component gets cached in memory.
		if ( url.keyExists( "init" ) ) {

			applicationStop();
			location( "/index.cfm" );

		}

	}

}
