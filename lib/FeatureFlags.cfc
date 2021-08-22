component
	output = false
	hint = "I provide service methods for evaluating feature flag state for users."
	{

	/**
	* I initialize the feature flag service with the given class-loader.
	*/
	public void function init(
		required any classLoader,
		required string sdkKey
		) {

		variables.classLoader = arguments.classLoader;
		variables.sdkKey = arguments.sdkKey;

		// The LaunchDarkly client should be instantiated and stored as a single, shared
		// instance within your application. It will maintain a set of in-memory rules
		// that instantly synchronize with any changes made to the remote LaunchDarkly
		// dashboard in the background.
		variables.ldClient = classLoader
			.load( "com.launchdarkly.sdk.server.LDClient" )
			.init( sdkKey )
		;

		// When we check feature flag state against the LaunchDarkly client, we have to
		// call a type-aware method and provide a type-aware default value. As such, we
		// need to know the type of each feature flag key. To make this easier to define,
		// we'll create type-buckets which will then get collated as a single collection.
		// Within each of these buckets, the Struct key is the "feature flag key" and the
		// Struct value is the "default variation" to be used if there is a problem
		// communicating with the remote LaunchDarkly servers.
		variables.featureFlags = collateFeatureFlags({
			bool: {
				"demo-bool-variation": false
			},
			double: {
				// No double-variation feature flags at this time.
			},
			int: {
				// No int-variation feature flags at this time.
			},
			json: {
				"demo-json-variation": buildLdValue({
					which: "first"
				})
			},
			string: {
				"demo-string-variation": "first"
			}
		});

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I evaluate and return the targeted variation for the given feature flag and the
	* given user (with the given set of custom properties).
	*/
	public any function getFeature(
		required string featureKey,
		required string userKey,
		array userProperties = []
		) {

		var ldUser = buildLdUser( userKey, userProperties );
		var featureFlag = featureFlags[ featureKey ];

		return( getVariation( featureFlag, ldUser ) );

	}


	/**
	* I evaluate and return the targeted variation for all of the feature flags and the
	* given user (with the given set of custom properties).
	*/
	public struct function getFeatures(
		required string userKey,
		array userProperties = []
		) {

		var ldUser = buildLdUser( userKey, userProperties );

		var features = featureFlags.map(
			( featureKey, featureFlag ) => {

				return( getVariation( featureFlag, ldUser ) );

			}
		);

		return( features );

	}


	/**
	* I identify the user within the LaunchDarkly system. Returns the feature flag
	* variations for the given user.
	* 
	* NOTE: This is really just an alias for the getFeatures() method. In server-side
	* SDKs, the only impact of identifying users is that they are indexed in the
	* LaunchDarkly service. However, in most applications this is not needed because
	* users are automatically indexed when used for flag evaluation.
	*/
	public struct function identifyUser(
		required string userKey,
		array userProperties = []
		) {

		return( getFeatures( userKey, userProperties ) );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I build the LDUser instance for the given key / primary identifier and supporting
	* properties.
	*/
	private any function buildLdUser(
		required string userKey,
		required array userProperties
		) {

		// NOTE: Since the Builder class is a property of the LDUser class, we have to use
		// the special internal class "$" notation to access it.
		var ldUser = classLoader
			.load( "com.launchdarkly.sdk.LDUser$Builder" )
			// Key that uniquely-identifies the user / request / client. This value
			// should always be a String value. Casting to allow for calling context to
			// use numeric values (such as database auto-incrementing columns).
			.init( javaCast( "string", userKey ) )
		;

		for ( var userProperty in userProperties ) {

			// NOTE: There are other LDUser customer property methods available (such as
			// "private" methods for keeping data local). However, those aren't needed
			// for the applications I build - your mileage may vary.
			switch ( userProperty.name ) {
				case "country":
					ldUser.country( userProperty.value );
				break;
				case "email":
					ldUser.email( userProperty.value );
				break;
				case "firstName":
					ldUser.firstName( userProperty.value );
				break;
				case "ip":
				case "ipAddress":
					ldUser.ip( userProperty.value );
				break;
				case "lastName":
					ldUser.lastName( userProperty.value );
				break;
				case "name":
					ldUser.name( userProperty.value );
				break;
				default:
					ldUser.custom( userProperty.name, buildLDValue( userProperty.value ) );
				break;
			}

		}

		return( ldUser.build() );

	}


	/**
	* I build an LDValue instance for the given ColdFusion value.
	*/
	private any function buildLdValue( required any value ) {

		return( classLoader.load( "com.launchdarkly.sdk.LDValue" ).parse( serializeJson( value ) ) );

	}


	/**
	* I collate the various types into a single Struct of feature flags with an embedded
	* "type" property.
	*/
	private struct function collateFeatureFlags( required struct featureFlagsByType ) {

		var collation = {};

		for ( var type in featureFlagsByType ) {

			loop
				key = "local.featureKey"
				value = "local.defaultValue"
				struct = featureFlagsByType[ type ]
				{

				collation[ featureKey ] = {
					type: type,
					featureKey: featureKey,
					defaultValue: defaultValue
				};

			}

		}

		return( collation );

	}


	/**
	* I evaluate the given feature flag, extracting the variation targeted for the given
	* LanchDarkly user.
	*/
	private any function getVariation(
		required struct featureFlag,
		required any ldUser
		) {

		var featureType = featureFlag.type;
		var featureKey = featureFlag.featureKey;
		var defaultValue = featureFlag.defaultValue;

		switch ( featureType ) {
			case "bool":
				return( ldClient.boolVariation( featureKey, ldUser, defaultValue ) );
			break;
			case "double":
				return( ldClient.doubleVariation( featureKey, ldUser, defaultValue ) );
			break;
			case "int":
				return( ldClient.intVariation( featureKey, ldUser, defaultValue ) );
			break;
			case "json":
				return( deserializeJson( ldClient.jsonValueVariation( featureKey, ldUser, defaultValue ) ) );
			break;
			case "string":
				return( ldClient.stringVariation( featureKey, ldUser, defaultValue ) );
			break;
		}

	}

}
