<!---
	Method		:	updateBlogPost
	Description	:	Updates the specified blog post.
	Input		:	string id			- The id of the blog post.
					string title		- The title of the blog post.
					string summary		- The summary of the blog post.
					string body			- The body of the blog post.
					string url			- The url of the blog post.
					date published		- The publication date/time of the blog post.
					[array authorIds]	- The authors of the blog post, in the order in which they should be ranked.
					[array tagIds]		- The tags associated with the blog post.
	Output		:	BlogPost
--->

<cffunction name="updateBlogPost" returntype="BlogPost" output="false" description="Updates the specified blog post.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog post." />
	<cfargument name="title" type="string" required="true" displayName="title" hint="The title of the blog post." />
	<cfargument name="summary" type="string" required="true" displayName="summary" hint="The summary of the blog post." />
	<cfargument name="body" type="string" required="true" displayName="body" hint="The body of the blog post." />
	<cfargument name="url" type="string" required="true" displayName="url" hint="The url of the blog post." />
	<cfargument name="published" type="date" required="true" displayName="published" hint="The publication date/time of the blog post." />
	<cfargument name="authors" type="array" required="false" default=[] displayName="authors" hint="The authors of the blog post, in the order in which they should be ranked." />
	<cfargument name="tags" type="array" required="false" default=[] displayName="tags" hint="The tags associated with the blog post." />



	<!---
		Declare local variables
	--->
	<cfset var qryUpdateBlogPost = "" />
	<cfset var qryDeleteBlogPostAuthors = "" />
	<cfset var qryAddBlogPostAuthor = "" />
	<cfset var rank = 1 />
	<cfset var qryDeleteBlogPostTags = "" />
	<cfset var qryAddBlogPostTag = "" />
	<cfset var blogPostAuthors = "" />
	<cfset var blogPostTags = "" />
	<cfset var blogPost = "" />



	<!---
		Query the database
	--->
	<cftransaction>

		<!--- Update the blog post --->
		<cfquery name="qryUpdateBlogPost" datasource="#variables.datasource#">
			UPDATE
				blog_post
			SET
				title = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.title#" maxlength="250" />,
				summary = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.summary#" maxlength="1000" />,
				body = <cfqueryparam cfsqltype="cf_sql_longnvarchar" value="#arguments.body#" />,
				url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.url#" maxlength="1024" />,
				last_modified = getDate(),
				published = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.published#" />
			WHERE
				id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>


		<!--- Delete current authors --->
		<cfquery name="qryDeleteBlogPostAuthors" datasource="#variables.datasource#">
			DELETE FROM
				blog_post_author
			WHERE
				blog_post_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>


		<!---
			Iterate over authors and associate them with the new blog post
		--->
		<cfloop array="#arguments.authors#" item="authorId">

			<!--- Associate author --->
			<cfquery name="qryAddBlogPostAuthor" datasource="#variables.datasource#">
				INSERT INTO blog_post_author
				(
					blog_post_id,
					blog_user_id,
					rank
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />,
					<cfqueryparam cfsqltype="cf_sql_idstamp" value="#authorId#" />,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="#rank#" />
				)
			</cfquery>

			<!--- Increment rank --->
			<cfset rank = rank + 1 />

		</cfloop>


		<!--- Delete current tags --->
		<cfquery name="qryDeleteBlogPostTags" datasource="#variables.datasource#">
			DELETE FROM
				blog_post_tag
			WHERE
				blog_post_id = <cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />
		</cfquery>


		<!---
			Iterate over tags and associate them with the new blog post
		--->
		<cfloop array="#arguments.tags#" item="tagId">

			<!--- Associate tag --->
			<cfquery name="qryAddBlogPostTag" datasource="#variables.datasource#">
				INSERT INTO blog_post_tag
				(
					blog_post_id,
					blog_tag_id
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_idstamp" value="#arguments.id#" />,
					<cfqueryparam cfsqltype="cf_sql_idstamp" value="#tagId#" />
				)
			</cfquery>

		</cfloop>

	</cftransaction>



	<!---
		Create BlogPost instance and add the updated blog post to the internal cache
	--->
	<!--- Get the array of blog post authors --->
	<cfset blogPostAuthors = getBlogPostAuthorsFromDatabase( arguments.id ) />

	<!--- Get the array of blog post tags --->
	<cfset blogPostTags = getBlogPostTagsFromDatabase( arguments.id ) />

	<!--- Create blog post instance --->
	<cfset blogPost = createObject("component","cf-blog.BlogPost").init( argumentCollection = {
			"id" : arguments.id,
			"title" : arguments.title,
			"summary" : arguments.summary,
			"body" : arguments.body,
			"url" : arguments.url,
			"created" : now(),
			"lastModified" : now(),
			"published" : createDateTime(year(arguments.published), month(arguments.published), day(arguments.published), hour(arguments.published), minute(arguments.published), second(arguments.published)),
			"authors" : blogPostAuthors,
			"tags" : blogPostTags
		}) />



	<!---
		Update internal state
	--->
	<!--- Update blog post in blogPosts struct --->
	<cfset variables.blogPosts[variables.blogManager.generateKey( blogPost.getId() )] = blogPost />



	<!---
		Return the new blog post
	--->
	<cfreturn blogPost />

</cffunction>
