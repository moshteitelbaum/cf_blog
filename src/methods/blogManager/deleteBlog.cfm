<!---
	Method		:	deleteBlog
	Description	:	Deletes the specified blog.
	Input		:	string id			- The id of the blog.
	Output		:	void
--->

<cffunction name="deleteBlog" returntype="void" output="false" description="Deletes the specified blog.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog." />


	<!---
		Declare local variables
	--->
	<cfset var qryDeleteBlog = "" />
	<cfset var key = generateKey( arguments.id ) />


	<cftransaction>

		<!---
			Query the database
		--->
		<cfquery name="qryDeleteBlog" datasource="#variables.datasource#">
			UPDATE
				blog
			SET
				deleted = getDate()
			WHERE
				id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>


		<!--- Remove blog from BlogManager --->
		<cfset structDelete( variables.blogs, key ) />

	</cftransaction>

</cffunction>
