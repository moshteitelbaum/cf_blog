<!---
	Method		:	getBlogTags
	Description	:	Gets all blog tags.
	Input		:	None
	Output		:	array
--->

<cffunction name="getBlogTags" returntype="array" output="false" description="Gets all blog tags.">

	<!---
		Declare local variables
	--->
	<cfset var qryBlogTags = "" />
	<cfset var blogTags = [] />



	<!---
		Check if we already have the blog tags in cache
	--->
	<cfif arrayLen(variables.blogTags)>

		<!--- The blog tags are already in cache so just return them --->
		<cfreturn variables.blogTags />

	</cfif>



	<!---
		Query the database
	--->
	<cfquery name="qryBlogTags" datasource="#variables.datasource#">
		SELECT
			id,
			tag
		FROM
			blog_tag
	</cfquery>



	<!---
		Populate the blogTags array with a BlogTag object for each tag
	--->
	<cfloop query="qryBlogTags">
		<cfset arrayAppend( blogTags, createObject("component","cf-blog.BlogTag").init( argumentCollection = {
				"id" : qryBlogTags.id,
				"tag" : qryBlogTags.tag
			}) ) />
	</cfloop>

	<!--- Save the blog tags to cache --->
	<cfset variables.blogTags = blogTags />



	<!---
		Return the array
	--->
	<cfreturn blogTags />

</cffunction>
