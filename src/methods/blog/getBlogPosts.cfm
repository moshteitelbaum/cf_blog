<!---
	Method		:	getBlogPosts
	Description	:	Gets the specified number and offset of blog posts.
	Input		:	[numeric offset]	- The number of blog posts to skip before returning results.  Default is 0.
					[numeric limit]		- The maximum number of blog posts to return.  Default is 5.
					[string filter]		- A filter definition. ? = single character, * = multiple characters.
					[string tag]		- The name of the tag by which results should be filtered.
	Output		:	struct
--->

<cffunction name="getBlogPosts" returntype="struct" output="false" description="Gets the specified number and offset of blog posts.">

	<!---
		Define arguments
	--->
	<cfargument name="offset" type="numeric" required="false" default="0" displayName="offset" hint="The number of blog posts to skip before returning results.  Default is 0." />
	<cfargument name="limit" type="numeric" required="false" default="5" displayName="limit" hint="The maximum number of blog posts to return.  Default is 5." />
	<cfargument name="filter" type="string" required="false" default="" displayName="filter" hint="A filter definition. ? = single character, * = multiple characters." />
	<cfargument name="tag" type="string" required="false" default="" displayName="tag" hint="The name of the tag by which results should be filtered." />



	<!---
		Declare local variables
	--->
	<cfset var qryBlogPosts = "" />
	<cfset var blogPostAuthors = "" />
	<cfset var blogPostTags = "" />
	<cfset var blogPost = "" />
	<cfset var results = {
			"data" : [],
			"count" : 0,
			"hasPrevious" : false,
			"hasNext" : false,
			"rangeStart" : 0,
			"rangeEnd" : 0,
			"totalPosts" : 0
		} />
	<cfset var filterPattern = "" />



	<!---
		Process filter pattern
	--->
	<cfset filterPattern = replace(arguments.filter, "*", "%", "all") />
	<cfset filterPattern = replace(filterPattern, "?", "_", "all") />

	<cfif not len(filterPattern)>
		<cfset filterPattern = "%" />
	</cfif>



	<!---
		Query the database for the blog posts
	--->
	<cfquery name="qryBlogPosts" datasource="#variables.datasource#">
		SELECT
			blog_post.id,
			blog_post.blog_id,
			blog_post.title,
			blog_post.summary,
			blog_post.body,
			blog_post.url,
			blog_post.created,
			blog_post.last_modified,
			blog_post.published,
			row_number() OVER(ORDER BY blog_post.published ASC) AS blog_post_number,
			(
				SELECT
					count(blog_post.id)
				FROM
					blog_post
					<cfif len(arguments.tag)>
						INNER JOIN blog_post_tag
							ON blog_post.id = blog_post_tag.blog_post_id
						INNER JOIN blog_tag
							ON blog_post_tag.blog_tag_id = blog_tag.id
							AND blog_tag.tag = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tag#" />
					</cfif>
				WHERE
					blog_post.deleted IS NULL
					AND blog_post.published <= getDate()
			) AS total_posts
		FROM
			blog_post
			<cfif len(arguments.tag)>
				INNER JOIN blog_post_tag
					ON blog_post.id = blog_post_tag.blog_post_id
				INNER JOIN blog_tag
					ON blog_post_tag.blog_tag_id = blog_tag.id
					AND blog_tag.tag = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tag#" />
			</cfif>
		WHERE
			blog_post.deleted IS NULL
			AND blog_post.published <= getDate()
			<cfif len(arguments.filter)>
				AND (
						blog_post.title LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#filterPattern#%" />
						OR blog_post.summary LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#filterPattern#%" />
						OR blog_post.body LIKE <cfqueryparam cfsqltype="cf_sql_longnvarchar" value="%#filterPattern#%" />
					)
			</cfif>
		ORDER BY
			blog_post.published DESC
		OFFSET
			#val(arguments.offset)# ROWS
		FETCH
			NEXT #val(arguments.limit)# ROWS ONLY
	</cfquery>



	<!---
		If there are no results, return empty results
	--->
	<cfif qryBlogPosts.RecordCount eq 0>

		<cfreturn results />

	</cfif>



	<!---
		Set non-data result properties
	--->
	<cfset results.count = qryBlogPosts.RecordCount />
	<cfset results.rangeStart = qryBlogPosts.blog_post_number[qryBlogPosts.RecordCount] />
	<cfset results.rangeEnd = qryBlogPosts.blog_post_number[1] />
	<cfset results.hasPrevious = (results.rangeStart neq 1) />
	<cfset results.hasNext = (results.rangeEnd neq qryBlogPosts.total_posts) />
	<cfset results.totalPosts = qryBlogPosts.total_posts />



	<!---
		Create BlogPost instances from the database resultset and add them
		to the results and the Blog cache
	--->
	<cfloop query="qryBlogPosts">

		<!--- Generate key for the blog post --->
		<cfset key = variables.blogManager.generateKey( qryBlogPosts.id ) />


		<!--- Check if the blog post is already in cache --->
		<cfif structKeyExists(variables.blogPosts, key)>

			<!--- Get the in-cache blog post --->
			<cfset blogPost = variables.blogPosts[key] />

		<cfelse>

			<!--- Get the array of blog post authors --->
			<cfset blogPostAuthors = getBlogPostAuthorsFromDatabase( qryBlogPosts.id ) />

			<!--- Get the array of blog post tags --->
			<cfset blogPostTags = getBlogPostTagsFromDatabase( qryBlogPosts.id ) />

			<!--- Create blog post instance --->
			<cfset blogPost = createObject("component","cf-blog.BlogPost").init( argumentCollection = {
					"id" : qryBlogPosts.id,
					"title" : qryBlogPosts.title,
					"summary" : qryBlogPosts.summary,
					"body" : qryBlogPosts.body,
					"url" : qryBlogPosts.url,
					"created" : createDateTime(year(qryBlogPosts.created), month(qryBlogPosts.created), day(qryBlogPosts.created), hour(qryBlogPosts.created), minute(qryBlogPosts.created), second(qryBlogPosts.created)),
					"lastModified" : createDateTime(year(qryBlogPosts.last_modified), month(qryBlogPosts.last_modified), day(qryBlogPosts.last_modified), hour(qryBlogPosts.last_modified), minute(qryBlogPosts.last_modified), second(qryBlogPosts.last_modified)),
					"published" : createDateTime(year(qryBlogPosts.published), month(qryBlogPosts.published), day(qryBlogPosts.published), hour(qryBlogPosts.published), minute(qryBlogPosts.published), second(qryBlogPosts.published)),
					"authors" : blogPostAuthors,
					"tags" : blogPostTags
				}) />

			<!--- Add blog post to blogPosts struct --->
			<cfset variables.blogPosts[key] = blogPost />

		</cfif>

		<!--- Add blog post to results --->
		<cfset arrayAppend(results.data, blogPost) />

	</cfloop>



	<!---
		Return the results
	--->
	<cfreturn results />

</cffunction>
