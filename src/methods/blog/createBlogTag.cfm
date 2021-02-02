<!---
	Method		:	createBlogTag
	Description	:	Creates a new blog tag.
	Input		:	string tag			- The tag.
	Output		:	BlogTag
--->

<cffunction name="createBlogTag" returntype="BlogTag" output="false" description="Creates a new blog tag.">

	<!---
		Define arguments
	--->
	<cfargument name="tag" type="string" required="true" displayName="tag" hint="The tag." />



	<!---
		Declare local variables
	--->
	<cfset var qryCreateBlogTag = "" />
	<cfset var qryGetBlogTagByName = "" />
	<cfset var tagId = "" />
	<cfset var blogTag = "" />



	<!---
		Query the database
	--->
	<cftry>

		<!--- Try to add the new tag --->
		<cfquery name="qryCreateBlogTag" datasource="#variables.datasource#">
			INSERT INTO blog_tag
			(
				id,
				blog_id,
				tag
			)
			OUTPUT
				inserted.id
			VALUES
			(
				newId(),
				<cfqueryparam cfsqltype="cf_sql_idstamp" value="#this.getId()#" />,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tag#" maxlength="100" />
			)
		</cfquery>

		<!--- Save the new id to a variables --->
		<cfset tagId = qryCreateBlogTag.id />


		<!--- Catch any database errors which are likely due to trying to add a duplicate tag --->
		<cfcatch type="database">

			<!--- Get the tag's id --->
			<cfquery name="qryGetBlogTagByName" datasource="#variables.datasource#">
				SELECT
					id
				FROM
					blog_tag
				WHERE
					tag = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tag#" />
			</cfquery>

			<!--- Save the id to a variables --->
			<cfset tagId = qryGetBlogTagByName.id />

		</cfcatch>

	</cftry>



	<!---
		Create BlogTag instance
	--->
	<cfset blogTag = createObject("component","cf-blog.BlogTag").init( argumentCollection = {
			"id" : tagId,
			"tag" : arguments.tag
		}) />

	<!--- Add new tag to cache --->
	<cfset arrayAppend(variables.blogTags, blogTag) />



	<!---
		Return the new blog tag
	--->
	<cfreturn blogTag />

</cffunction>
