<!---
	Method		:	getBlogPostTagsFromDatabase
	Description	:	Gets the blog post tags from the database and returns them as an array of BlogTag objects.
	Input		:	string blogPostId	- The id of the blog post.
	Output		:	array
--->

<cffunction name="getBlogPostTagsFromDatabase" returntype="array" output="false" access="private" description="Gets the blog post tags from the database and returns them as an array of BlogTag objects.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />



	<!---
		Declare local variables
	--->
	<cfset var qryBlogPostTags = "" />
	<cfset var blogPostTags = [] />



	<!---
		Query the database
	--->
	<cfquery name="qryBlogPostTags" datasource="#variables.datasource#">
		SELECT
			blog_tag.id,
			blog_tag.tag
		FROM
			blog_post_tag
			INNER JOIN blog_tag
				ON blog_post_tag.blog_tag_id = blog_tag.id
		WHERE
			blog_post_tag.blog_post_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		ORDER BY
			blog_tag.tag ASC
	</cfquery>



	<!---
		Create array of blog post tags
	--->
	<cfloop query="qryBlogPostTags">
		<cfset arrayAppend( blogPostTags, createObject("component","cf-blog.BlogTag").init( argumentCollection = {
				"id" : qryBlogPostTags.id,
				"tag" : qryBlogPostTags.tag
			}) ) />
	</cfloop>



	<!---
		Return the array
	--->
	<cfreturn blogPostTags />

</cffunction>
