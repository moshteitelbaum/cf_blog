<!---
	Method		:	getBlogPostById
	Description	:	Gets the specified blog post, by id.
	Input		:	string id			- The id of the blog post.
	Output		:	BlogPost
--->

<cffunction name="getBlogPostById" returntype="BlogPost" output="false" description="Gets the specified blog post, by id.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />



	<!---
		Declare local variables
	--->
	<cfset var qryBlogPost = "" />
	<cfset var blogPostAuthors = "" />
	<cfset var blogPostTags = "" />
	<cfset var blogPost = "" />
	<cfset var key = variables.blogManager.generateKey( arguments.id ) />



	<!---
		Check if we already have the blog post in cache
	--->
	<cfif structKeyExists(variables.blogPosts, key)>

		<!--- The blog post is already in cache so just return it --->
		<cfreturn variables.blogPosts[ key ] />

	</cfif>



	<!---
		The blog post is not in cache so query the database for it
	--->
	<cfquery name="qryBlogPost" datasource="#variables.datasource#">
		SELECT
			id,
			blog_id,
			title,
			summary,
			body,
			url,
			created,
			last_modified,
			published
		FROM
			blog_post
		WHERE
			id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
	</cfquery>



	<!---
		If there was no match, throw an exception
	--->
	<cfif qryBlogPost.RecordCount eq 0>

		<cfthrow
			type="NotFoundException"
			message="The specified item was not found." />

	</cfif>



	<!---
		Create a BlogPost instance from the database resultset and add it
		to the Blog cache
	--->
	<!--- Get the array of blog post authors --->
	<cfset blogPostAuthors = getBlogPostAuthorsFromDatabase( qryBlogPost.id ) />

	<!--- Get the array of blog post tags --->
	<cfset blogPostTags = getBlogPostTagsFromDatabase( qryBlogPost.id ) />

	<!--- Create blog post instance --->
	<cfset blogPost = createObject("component","cf-blog.BlogPost").init( argumentCollection = {
			"id" : qryBlogPost.id,
			"title" : qryBlogPost.title,
			"summary" : qryBlogPost.summary,
			"body" : qryBlogPost.body,
			"url" : qryBlogPost.url,
			"created" : createDateTime(year(qryBlogPost.created), month(qryBlogPost.created), day(qryBlogPost.created), hour(qryBlogPost.created), minute(qryBlogPost.created), second(qryBlogPost.created)),
			"lastModified" : createDateTime(year(qryBlogPost.last_modified), month(qryBlogPost.last_modified), day(qryBlogPost.last_modified), hour(qryBlogPost.last_modified), minute(qryBlogPost.last_modified), second(qryBlogPost.last_modified)),
			"published" : createDateTime(year(qryBlogPost.published), month(qryBlogPost.published), day(qryBlogPost.published), hour(qryBlogPost.published), minute(qryBlogPost.published), second(qryBlogPost.published)),
			"authors" : blogPostAuthors,
			"tags" : blogPostTags
		}) />

	<!--- Add blog post to blogPosts struct --->
	<cfset variables.blogPosts[variables.blogManager.generateKey( blogPost.getId() )] = blogPost />



	<!---
		Return the BlogPost object
	--->
	<cfreturn blogPost />

</cffunction>
