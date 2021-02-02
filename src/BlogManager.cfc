<!---
	BlogManager.cfc
--->

<cfcomponent displayname="BlogManager" output="false" accessors="true">

	<!---
		Define variables
	--->
	<cfset variables.datasource = "" />
	<cfset variables.blogs = {} />



	<!---
	***********************************************************************************************
		Constructor method definition
	***********************************************************************************************
	--->

	<cffunction name="init" returnType="BlogManager" output="false" access="public">

		<!--- Define arguments --->
		<cfargument name="datasource" type="string" required="true" displayname="datasource" hint="The name of the datasource." />


		<!--- Set properties --->
		<cfset variables.datasource = arguments.datasource />


		<!--- Initialize state --->
		<cftry>

			<!--- Load all blogs into cache --->
			<cfset variables.blogs = getBlogsFromDatabase() />

			<cfcatch type="all"></cfcatch>

		</cftry>


		<!--- Return a reference to the BlogManager object --->
		<cfreturn this />

	</cffunction>


	<!---
	***********************************************************************************************
		Private method definitions
	***********************************************************************************************
	--->

	<!---
		Method		:	getBlogsFromDatabase
		Description	:	Get blogs from the database and returns as a struct of Blog objects.
		Input		:	none
		Output		:	struct
	--->
	<cfinclude template="methods/blogManager/getBlogsFromDatabase.cfm" />


	<!---
	***********************************************************************************************
		Package method definitions
	***********************************************************************************************
	--->

	<!---
		Method		:	generateKey
		Description	:	Generates the key used to store blog objects in cache.
		Input		:	string id			- The id of the blog.
		Output		:	string
	--->
	<cfinclude template="methods/blogManager/generateKey.cfm" />


	<!---
		Method		:	getDatasource
		Description	:	Gets the name of the datasource.
		Input		:	none
		Output		:	string
	--->
	<cfinclude template="methods/blogManager/getDatasource.cfm" />


	<!---
	***********************************************************************************************
		Public method definitions
	***********************************************************************************************
	--->

	<!---
		Method		:	createBlog
		Description	:	Creates a new blog.
		Input		:	string name			- The name of the blog.
						string description	- The description of the blog.
		Output		:	Blog
	--->
	<cfinclude template="methods/blogManager/createBlog.cfm" />


	<!---
		Method		:	deleteBlog
		Description	:	Deletes the specified blog.
		Input		:	string id			- The id of the blog.
		Output		:	void
	--->
	<cfinclude template="methods/blogManager/deleteBlog.cfm" />


	<!---
		Method		:	getBlogById
		Description	:	Gets the specified blog, by id.
		Input		:	string id			- The id of the blog.
		Output		:	Blog
	--->
	<cfinclude template="methods/blogManager/getBlogById.cfm" />


	<!---
		Method		:	getBlogByName
		Description	:	Gets the specified blog, by name.
		Input		:	string name			- The name of the blog.
		Output		:	Blog
	--->
	<cfinclude template="methods/blogManager/getBlogByName.cfm" />


	<!---
		Method		:	getBlogCount
		Description	:	Gets the number of blogs.
		Input		:	none
		Output		:	numeric
	--->
	<cfinclude template="methods/blogManager/getBlogCount.cfm" />


	<!---
		Method		:	getBlogs
		Description	:	Gets all blogs.
		Input		:	none
		Output		:	array
	--->
	<cfinclude template="methods/blogManager/getBlogs.cfm" />


	<!---
		Method		:	updateBlog
		Description	:	Updates the specified blog.
		Input		:	string id			- The id of the blog.
						string name			- The name of the blog.
						string description	- The description of the blog.
		Output		:	Blog
	--->
	<cfinclude template="methods/blogManager/updateBlog.cfm" />

</cfcomponent>
