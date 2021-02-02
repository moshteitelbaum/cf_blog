<!---
	Method		:	getBlogByName
	Description	:	Gets the specified blog, by name.
	Input		:	string name			- The name of the blog.
	Output		:	Blog
--->

<cffunction name="getBlogByName" returntype="Blog" output="false" description="Gets the specified blog, by name.">

	<!---
		Define arguments
	--->
	<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the blog." />


	<!---
		Declare local variables
	--->
	<cfset var key = "" />
	<cfset var qryBlog = "" />
	<cfset var blog = "" />


	<!---
		Check if we already have the blog in cache
	--->
	<!--- Iterate over blogs in cache --->
	<cfloop collection="#variables.blogs#" item="key">

		<!--- Check if current blog matches the specified name --->
		<cfif compareNoCase( variables.blogs[key].getName(), arguments.name ) eq 0>

			<!--- We found a match, so return the blog --->
			<cfreturn variables.blogs[key] />

		</cfif>

	</cfloop>


	<!---
		The blog is not in cache so query the database for it
	--->
	<cfquery name="qryBlog" datasource="#variables.datasource#">
		SELECT
			blog.id,
			blog.name,
			blog.description,
			blog.created,
			count(blog_post.id) AS num_posts
		FROM
			blog
			LEFT JOIN blog_post
				ON blog.id = blog_post.blog_id
				AND blog_post.deleted IS NULL
				AND blog_post.published <= getDate()
		WHERE
			blog.name = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.name#" />
		GROUP BY
			blog.id,
			blog.name,
			blog.description,
			blog.created
	</cfquery>


	<!---
		If there was no match, throw an exception
	--->
	<cfif qryBlog.RecordCount eq 0>

		<cfthrow
			type="NotFoundException"
			message="The specified item was not found." />

	</cfif>


	<!---
		Create a Blog instance from the database resultset and add it
		to the BlogManager cache
	--->
	<cfset blog = createObject("component","cf-blog.Blog").init( argumentCollection = {
			"id" : qryBlog.id,
			"name" : qryBlog.name,
			"description" : qryBlog.description,
			"created" : createDateTime(year(qryBlog.created), month(qryBlog.created), day(qryBlog.created), hour(qryBlog.created), minute(qryBlog.created), second(qryBlog.created)),
			"numPosts" : qryBlog.num_posts,
			"blogManager" : this
		}) />

	<!--- Add blog to blogs struct --->
	<cfset variables.blogs[generateKey( blog.getId() )] = blog />


	<!---
		Return the Blog object
	--->
	<cfreturn blog />

</cffunction>
