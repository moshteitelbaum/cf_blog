<!---
	Method		:	getBlogPostAuthorsFromDatabase
	Description	:	Gets the blog post authors from the database and returns them as an array of BlogUser objects.
	Input		:	string blogPostId	- The id of the blog post.
	Output		:	array
--->

<cffunction name="getBlogPostAuthorsFromDatabase" returntype="array" output="false" access="private" description="Gets the blog post authors from the database and returns them as an array of BlogUser objects.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />



	<!---
		Declare local variables
	--->
	<cfset var qryBlogPostAuthors = "" />
	<cfset var blogPostAuthors = [] />


	<!---
		Query the database
	--->
	<cfquery name="qryBlogPostAuthors" datasource="#variables.datasource#">
		SELECT
			blog_user.id,
			blog_user.name,
			blog_user.external_id
		FROM
			blog_post_author
			INNER JOIN blog_user
				ON blog_post_author.blog_user_id = blog_user.id
		WHERE
			blog_post_author.blog_post_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		ORDER BY
			blog_post_author.rank ASC
	</cfquery>



	<!---
		Create array of blog post authors
	--->
	<cfloop query="qryBlogPostAuthors">
		<cfset arrayAppend( blogPostAuthors, createObject("component","cf-blog.BlogUser").init( argumentCollection = {
				"id" : qryBlogPostAuthors.id,
				"name" : qryBlogPostAuthors.name,
				"externalId" : qryBlogPostAuthors.external_id
			}) ) />
	</cfloop>



	<!---
		Return the array
	--->
	<cfreturn blogPostAuthors />

</cffunction>
