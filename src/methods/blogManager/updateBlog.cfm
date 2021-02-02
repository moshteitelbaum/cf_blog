<!---
	Method		:	updateBlog
	Description	:	Updates the specified blog.
	Input		:	string id			- The id of the blog.
					string name			- The name of the blog.
					string description	- The description of the blog.
	Output		:	Blog
--->

<cffunction name="updateBlog" returntype="Blog" output="false" description="Updates the specified blog.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog." />
	<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the blog." />
	<cfargument name="description" type="string" required="true" displayName="description" hint="The description of the blog." />


	<!---
		Declare local variables
	--->
	<cfset var qryUpdateBlog = "" />
	<cfset var blog = "" />
	<cfset var oldBlog = getBlogById( arguments.id ) />


	<cftransaction>

		<!---
			Query the database
		--->
		<cfquery name="qryUpdateBlog" datasource="#variables.datasource#">
			UPDATE
				blog
			SET
				name = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.name#" maxlength="100" />,
				description = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.description#" maxlength="1000" />
			WHERE
				id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>


		<!---
			Create an instance of a Blog object for the updated blog
		--->
		<!--- Create a Blog instance --->
		<cfset blog = createObject("component","cf-blog.Blog").init( argumentCollection = {
				"id" : arguments.id,
				"name" : arguments.name,
				"description" : arguments.description,
				"created" : oldBlog.getCreated(),
				"numPosts" : oldBlog.getNumPosts(),
				"blogManager" : this
			}) />

		<!--- Update the blog in the BlogManager --->
		<cfset variables.blogs[generateKey( blog.getId() )] = blog />

	</cftransaction>


	<!---
		Return Blog object
	--->
	<cfreturn blog />

</cffunction>
