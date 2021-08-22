
# Using The LaunchDarkly Feature Flag Java SDK With Lucee CFML 5

by [Ben Nadel][ben-nadel]

The LaunchDarkly Feature Flag SaaS (Software as a Service) is the bee's knees. I literally can't imagine building a user-facing product without it. I [started using LaunchDarkly back in my Adobe ColdFusion 10 days][blog-2943]; but, now that I develop primarily on Lucee CFML 5.x, I wanted to quickly revisit what a vastly-simplified setup would look like thanks to [Lucee's ability to load JAR files on-the-fly][blog-3651].

## Running Lucee CFML Locally

I built this using [CommandBox][command-box]. To start the server, I ran this from the root directory of this repository:

```sh
# Boot-up the CommandBox CLI.
box

# Start of the Lucee CFML server for this repository.
server start

# Copy the Lucee configuration into the current server context
# (mainly to set up the Admin password as "password").
cfconfig import ./.cfconfig.json
```

I also copied my LaunchDarkly project SDK key into a new file, `./config/production.json`, which is a copy of the `./config/template.json` template.

## Resources

* [Ben Nadel's blog posts on LaunchDarkly](https://www.google.com/search?q=site%3Abennadel.com+launchdarkly).
* [Maven download page for LaunchDarkly 5.6.2 JAR files](https://mvnrepository.com/artifact/com.launchdarkly/launchdarkly-java-server-sdk/5.6.2).
* [LaunchDarkly Java SDK JavaDocs](https://launchdarkly.github.io/java-server-sdk/). 


[ben-nadel]: https://www.bennadel.com/

[blog-2943]: https://www.bennadel.com/blog/2943-using-launchdarkly-with-coldfusion-and-javaloader.htm "Read article: Using LaunchDarkly With ColdFusion And JavaLoader"

[blog-3651]: https://www.bennadel.com/blog/3651-dynamically-loading-java-classes-from-jar-files-using-createobject-in-lucee-5-3-2-77.htm "Read article: Dynamically Loading Java Classes From JAR Files Using CreateObject() In Lucee 5.3.2.77"

[command-box]: https://www.ortussolutions.com/products/commandbox
