<!---
	BlogPost.cfc
--->

<cfcomponent displayName="BlogPost" output="false" accessors="true">

	<!--- Define properties --->
	<cfproperty name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />
	<cfproperty name="title" type="string" required="true" displayName="title" hint="The title of the blog post." />
	<cfproperty name="summary" type="string" required="true" displayName="summary" hint="The summary of the blog post." />
	<cfproperty name="body" type="string" required="true" displayName="body" hint="The body of the blog post." />
	<cfproperty name="url" type="string" required="true" displayName="url" hint="The url of the blog post." />
	<cfproperty name="created" type="date" required="true" displayName="created" hint="The creation date/time of the blog post." />
	<cfproperty name="lastModified" type="date" required="true" displayName="lastModified" hint="The last modified date/time of the blog post." />
	<cfproperty name="published" type="date" required="true" displayName="published" hint="The publication date/time of the blog post." />
	<cfproperty name="authors" type="array" required="true" displayName="authors" hint="The authors of the blog post." />
	<cfproperty name="tags" type="array" required="true" displayName="tags" hint="The tags associated with the blog post." />



	<!---
	***********************************************************************************************
		Constructor method definition
	***********************************************************************************************
	--->

	<cffunction name="init" returnType="BlogPost" output="false" access="public">

		<!---
			Define arguments
		--->
		<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />
		<cfargument name="title" type="string" required="true" displayName="title" hint="The title of the blog post." />
		<cfargument name="summary" type="string" required="true" displayName="summary" hint="The summary of the blog post." />
		<cfargument name="body" type="string" required="true" displayName="body" hint="The body of the blog post." />
		<cfargument name="url" type="string" required="true" displayName="url" hint="The url of the blog post." />
		<cfargument name="created" type="date" required="true" displayName="created" hint="The creation date/time of the blog post." />
		<cfargument name="lastModified" type="date" required="true" displayName="lastModified" hint="The last modified date/time of the blog post." />
		<cfargument name="published" type="date" required="true" displayName="published" hint="The publication date/time of the blog post." />
		<cfargument name="authors" type="array" required="false" default=[] displayName="authors" hint="The authors of the blog post." />
		<cfargument name="tags" type="array" required="false" default=[] displayName="tags" hint="The tags associated with the blog post." />


		<!---
			Set properties
		--->
		<cfset setId( arguments.id ) />
		<cfset setTitle( arguments.title ) />
		<cfset setSummary( arguments.summary ) />
		<cfset setBody( arguments.body ) />
		<cfset setUrl( arguments.url ) />
		<cfset setCreated( arguments.created ) />
		<cfset setLastModified( arguments.lastModified ) />
		<cfset setPublished( arguments.published ) />
		<cfset setAuthors( arguments.authors ) />
		<cfset setTags( arguments.tags ) />


		<!---
			Return a reference to the BlogPost object
		--->
		<cfreturn this />

	</cffunction>

</cfcomponent>
