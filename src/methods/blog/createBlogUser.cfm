<!---
	Method		:	createBlogUser
	Description	:	Creates a new blog user.
	Input		:	string name			- The name of the user.
					string externalId	- The user's id from the external user management system.
	Output		:	BlogUser
--->

<cffunction name="createBlogUser" returntype="BlogUser" output="false" description="Creates a new blog user.">

	<!---
		Define arguments
	--->
	<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the user." />
	<cfargument name="externalId" type="string" required="true" displayName="externalId" hint="The user's id from the external user management system." />



	<!---
		Declare local variables
	--->
	<cfset var qryCreateBlogUser = "" />
	<cfset var qryGetBlogUserByExternalId = "" />
	<cfset var userId = "" />
	<cfset var blogUser = "" />



	<!---
		Query the database
	--->
	<cftry>

		<!--- Try to add the new user --->
		<cfquery name="qryCreateBlogUser" datasource="#variables.datasource#">
			INSERT INTO blog_user
			(
				id,
				blog_id,
				name,
				external_id
			)
			OUTPUT
				inserted.id
			VALUES
			(
				newId(),
				<cfqueryparam cfsqltype="cf_sql_idstamp" value="#this.getId()#" />,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.name#" maxlength="200" />,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.externalId#" maxlength="100" />
			)
		</cfquery>

		<!--- Save the new id to a variables --->
		<cfset userId = qryCreateBlogUser.id />


		<!--- Catch any database errors which are likely due to trying to add a duplicate user --->
		<cfcatch type="database">

			<!--- Get the user's id --->
			<cfquery name="qryGetBlogUserByExternalId" datasource="#variables.datasource#">
				SELECT
					id
				FROM
					blog_user
				WHERE
					external_id = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.externalId#" />
			</cfquery>

			<!--- Save the id to a variables --->
			<cfset userId = qryGetBlogUserByExternalId.id />

		</cfcatch>

	</cftry>



	<!---
		Create BlogUser instance
	--->
	<cfset blogUser = createObject("component","cf-blog.BlogUser").init( argumentCollection = {
			"id" : userId,
			"name" : arguments.name,
			"externalId" : arguments.externalId
		}) />

	<!--- Add new user to cache --->
	<cfset arrayAppend(variables.blogUsers, blogUser) />



	<!---
		Return the new blog user
	--->
	<cfreturn blogUser />

</cffunction>
