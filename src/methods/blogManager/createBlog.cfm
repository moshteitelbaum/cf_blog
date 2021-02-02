<!---
	Method		:	createBlog
	Description	:	Creates a new blog.
	Input		:	string name			- The name of the blog.
					string description	- The description of the blog.
	Output		:	Blog
--->

<cffunction name="createBlog" returntype="Blog" output="false" description="Creates a new blog.">

	<!---
		Define arguments
	--->
	<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the blog." />
	<cfargument name="description" type="string" required="true" displayName="description" hint="The description of the blog." />


	<!---
		Declare local variables
	--->
	<cfset var qryCreateBlog = "" />
	<cfset var blog = "" />


	<!---
		Query the database
	--->
	<cfquery name="qryCreateBlog" datasource="#variables.datasource#">
		INSERT INTO blog
		(
			id,
			name,
			description,
			created
		)
		OUTPUT
			inserted.id
		VALUES
		(
			newId(),
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.name#" maxlength="100" />,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#" maxlength="1000" />,
			getDate()
		)
	</cfquery>


	<!---
		Create an instance of a Blog object for the new blog
	--->
	<!--- Create a Blog instance --->
	<cfset blog = createObject("component","cf-blog.Blog").init( argumentCollection = {
			"id" : qryCreateBlog.id,
			"name" : arguments.name,
			"description" : arguments.description,
			"created" : now(),
			"numPosts" : 0,
			"blogManager" : this
		}) />

	<!--- Add blog to BlogManager --->
	<cfset variables.blogs[generateKey( blog.getId() )] = blog />


	<!---
		Return Blog object
	--->
	<cfreturn blog />

</cffunction>
