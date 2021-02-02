<!---
	Method		:	getLatestBlogPost
	Description	:	Gets the most recently published blog post.
	Input		:	None
	Output		:	BlogPost
--->

<cffunction name="getLatestBlogPost" returntype="BlogPost" output="false" description="Gets the most recently published blog post.">

	<!---
		Declare local variables
	--->
	<cfset var key = variables.blogManager.generateKey( variables.latestBlogPostId ) />
	<cfset var qryLatestBlogPost = "" />
	<cfset var blogPostAuthors = "" />
	<cfset var blogPostTags = "" />
	<cfset var blogPost = "" />



	<!---
		Check if we already have the latest blog post cached
	--->
	<cfif (len(variables.latestBlogPostId)) and (structKeyExists(variables.blogPosts, key))>

		<!--- Return the cached blog post --->
		<cfreturn variables.blogPosts[key] />

	</cfif>



	<!---
		Query the database
	--->
	<cfquery name="qryLatestBlogPost" datasource="#variables.datasource#">
		SELECT
			TOP 1
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
			blog_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#this.getId()#" />
			AND published <= getDate()
			AND deleted IS NULL
		ORDER BY
			published DESC
	</cfquery>



	<!---
		If there was no match, throw an exception
	--->
	<cfif qryLatestBlogPost.RecordCount eq 0>

		<cfthrow
			type="NotFoundException"
			message="The specified item was not found." />

	</cfif>



	<!---
		Create a BlogPost instance from the database resultset and add it
		to the Blog cache
	--->
	<!--- Get the array of blog post authors --->
	<cfset blogPostAuthors = getBlogPostAuthorsFromDatabase( qryLatestBlogPost.id ) />

	<!--- Get the array of blog post tags --->
	<cfset blogPostTags = getBlogPostTagsFromDatabase( qryLatestBlogPost.id ) />

	<!--- Create blog post instance --->
	<cfset blogPost = createObject("component","cf-blog.BlogPost").init( argumentCollection = {
			"id" : qryLatestBlogPost.id,
			"title" : qryLatestBlogPost.title,
			"summary" : qryLatestBlogPost.summary,
			"body" : qryLatestBlogPost.body,
			"url" : qryLatestBlogPost.url,
			"created" : createDateTime(year(qryLatestBlogPost.created), month(qryLatestBlogPost.created), day(qryLatestBlogPost.created), hour(qryLatestBlogPost.created), minute(qryLatestBlogPost.created), second(qryLatestBlogPost.created)),
			"lastModified" : createDateTime(year(qryLatestBlogPost.last_modified), month(qryLatestBlogPost.last_modified), day(qryLatestBlogPost.last_modified), hour(qryLatestBlogPost.last_modified), minute(qryLatestBlogPost.last_modified), second(qryLatestBlogPost.last_modified)),
			"published" : createDateTime(year(qryLatestBlogPost.published), month(qryLatestBlogPost.published), day(qryLatestBlogPost.published), hour(qryLatestBlogPost.published), minute(qryLatestBlogPost.published), second(qryLatestBlogPost.published)),
			"authors" : blogPostAuthors,
			"tags" : blogPostTags
		}) />



	<!---
		Update internal state
	--->
	<!--- Add blog post to blogPosts struct --->
	<cfset variables.blogPosts[variables.blogManager.generateKey( blogPost.getId() )] = blogPost />

	<!--- Log the id of the latest blog post --->
	<cfset variables.latestBlogPostId = blogPost.getId() />



	<!---
		Return the blog post
	--->
	<cfreturn blogPost />

</cffunction>
