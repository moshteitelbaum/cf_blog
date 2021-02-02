<!---
	Method		:	getBlogsFromDatabase
	Description	:	Get blogs from the database and returns as a struct of Blog objects.
	Input		:	none
	Output		:	struct
--->

<cffunction name="getBlogsFromDatabase" returntype="struct" output="false" access="private" description="Get blogs from the database and returns as a struct of Blog objects.">

	<!---
		Declare local variables
	--->
	<cfset var qryBlogs = "" />
	<cfset var strBlogs = {} />
	<cfset var blog = "" />


	<!---
		Query the database
	--->
	<cfquery name="qryBlogs" datasource="#variables.datasource#">
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
			blog.deleted IS NULL
		GROUP BY
			blog.id,
			blog.name,
			blog.description,
			blog.created
	</cfquery>


	<!---
		Process the database resultset
	--->
	<cfloop query="qryBlogs">

		<!--- Create a Blog instance --->
		<cfset blog = createObject("component","cf-blog.Blog").init( argumentCollection = {
				"id" : qryBlogs.id,
				"name" : qryBlogs.name,
				"description" : qryBlogs.description,
				"created" : createDateTime(year(qryBlogs.created), month(qryBlogs.created), day(qryBlogs.created), hour(qryBlogs.created), minute(qryBlogs.created), second(qryBlogs.created)),
				"numPosts" : qryBlogs.num_posts,
				"blogManager" : this
			}) />

		<!--- Add blog to struct --->
		<cfset strBlogs[generateKey( blog.getId() )] = blog />

	</cfloop>


	<!---
		Return struct of Blog objects
	--->
	<cfreturn strBlogs />

</cffunction>
