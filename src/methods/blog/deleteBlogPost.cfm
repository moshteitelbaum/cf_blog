<!---
	Method		:	deleteBlogPost
	Description	:	Deletes the specified blog post.
	Input		:	string id			- The id of the blog post.
	Output		:	void
--->

<cffunction name="deleteBlogPost" returntype="void" output="false" description="Deletes the specified blog post.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />


	<!---
		Declare local variables
	--->
	<cfset var qryDeleteBlogPost = "" />
	<cfset var key = variables.blogManager.generateKey( arguments.id ) />


	<cftransaction>

		<!---
			Query the database
		--->
		<cfquery name="qryDeleteBlogPost" datasource="#variables.datasource#">
			UPDATE
				blog_post
			SET
				deleted = getDate()
			OUTPUT
				deleted.id
			WHERE
				id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>



		<!---
			Update internal state
		--->
		<!--- If there was matching blog post, decrement the number of blog posts --->
		<cfif qryDeleteBlogPost.RecordCount>
			<cfset this.setNumPosts( this.getNumPosts() - 1 ) />
		</cfif>

		<!--- Remove blog post from internal cache --->
		<cfset structDelete( variables.blogPosts, key ) />

		<!--- If the deleted blog post was the latest one, reset the internal record --->
		<cfif compareNoCase(arguments.id, variables.latestBlogPostId) eq 0>
			<cfset variables.latestBlogPostId = "" />
		</cfif>

	</cftransaction>

</cffunction>
