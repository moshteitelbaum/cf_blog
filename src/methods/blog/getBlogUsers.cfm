<!---
	Method		:	getBlogUsers
	Description	:	Gets all blog users.
	Input		:	None
	Output		:	array
--->

<cffunction name="getBlogUsers" returntype="array" output="false" description="Gets all blog users.">

	<!---
		Declare local variables
	--->
	<cfset var qryBlogUsers = "" />
	<cfset var blogUsers = [] />



	<!---
		Check if we already have the blog users in cache
	--->
	<cfif arrayLen(variables.blogUsers)>

		<!--- The blog users are already in cache so just return them --->
		<cfreturn variables.blogUsers />

	</cfif>



	<!---
		Query the database
	--->
	<cfquery name="qryBlogUsers" datasource="#variables.datasource#">
		SELECT
			id,
			name,
			external_id
		FROM
			blog_user
		WHERE
			name LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#filterPattern#" />
	</cfquery>



	<!---
		Populate the blogUsers array with a BlogUser object for each user
	--->
	<cfloop query="qryBlogUsers">
		<cfset arrayAppend( blogUsers, createObject("component","cf-blog.BlogUser").init( argumentCollection = {
				"id" : qryBlogUsers.id,
				"name" : qryBlogUsers.name,
				"externalId" : qryBlogUsers.external_id
			}) ) />
	</cfloop>

	<!--- Save the blog users to cache --->
	<cfset variables.blogUsers = blogUsers />



	<!---
		Return the array
	--->
	<cfreturn blogUsers />

</cffunction>
