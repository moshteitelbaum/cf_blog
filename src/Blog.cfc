<!---
	Blog.cfc
--->

<cfcomponent displayName="Blog" output="false" accessors="true">

	<!--- Define properties --->
	<cfproperty name="id" type="string" required="true" displayName="id" hint="The id of the blog." />
	<cfproperty name="name" type="string" required="true" displayName="name" hint="The name of the blog." />
	<cfproperty name="description" type="string" required="true" displayName="description" hint="The description of the blog." />
	<cfproperty name="created" type="date" required="true" displayName="created" hint="The date and time at which the blog was created." />
	<cfproperty name="numPosts" type="numeric" required="true" displayName="numPosts" hint="The number of posts associated with the blog." />

	<!---
		Define variables
	--->
	<cfset variables.blogManager = "" />
	<cfset variables.datasource = "" />
	<cfset variables.blogPosts = {} />
	<cfset variables.blogTags = [] />
	<cfset variables.blogUsers = [] />
	<cfset variables.latestBlogPostId = "" />



	<!---
	***********************************************************************************************
		Constructor method definition
	***********************************************************************************************
	--->

	<cffunction name="init" returnType="Blog" output="false" access="public">

		<!---
			Define arguments
		--->
		<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog." />
		<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the blog." />
		<cfargument name="description" type="string" required="true" displayName="description" hint="The description of the blog." />
		<cfargument name="created" type="date" required="true" displayName="created" hint="The date and time at which the blog was created." />
		<cfargument name="numPosts" type="numeric" required="true" displayName="numPosts" hint="The number of posts associated with the blog." />
		<cfargument name="blogManager" type="BlogManager" required="true" displayname="blogManager" hint="The BlogManager." />


		<!---
			Set properties
		--->
		<cfset setId( arguments.id ) />
		<cfset setName( arguments.name ) />
		<cfset setDescription( arguments.description ) />
		<cfset setCreated( arguments.created ) />
		<cfset setNumPosts( arguments.numPosts ) />

		<cfset variables.blogManager = arguments.blogManager />
		<cfset variables.datasource = variables.blogManager.getDatasource() />


		<!---
			Get the latest blog post
		--->
		<cftry>
			<cfset getLatestBlogPost() />

			<cfcatch type="NotFoundException">
				<!--- There are no blog posts yet --->
			</cfcatch>
		</cftry>


		<!---
			Return a reference to the Blog object
		--->
		<cfreturn this />

	</cffunction>


	<!---
	***********************************************************************************************
		Private method definitions
	***********************************************************************************************
	--->

	<!---
		Method		:	getBlogPostAuthorsFromDatabase
		Description	:	Gets the blog post authors from the database and returns them as an array of BlogUser objects.
		Input		:	string blogPostId	- The id of the blog post.
		Output		:	array
	--->
	<cfinclude template="methods/blog/getBlogPostAuthorsFromDatabase.cfm" />

	<!---
		Method		:	getBlogPostTagsFromDatabase
		Description	:	Gets the blog post tags from the database and returns them as an array of BlogTag objects.
		Input		:	string blogPostId	- The id of the blog post.
		Output		:	array
	--->
	<cfinclude template="methods/blog/getBlogPostTagsFromDatabase.cfm" />



	<!---
	***********************************************************************************************
		Public method definitions
	***********************************************************************************************
	--->

	<!---
		Method		:	createBlogPost
		Description	:	Creates a new blog post.
		Input		:	string title		- The title of the blog post.
						string summary		- The summary of the blog post.
						string body			- The body of the blog post.
						string url			- The url of the blog post.
						date published		- The publication date/time of the blog post.
						[array authorIds]	- The authors of the blog post, in the order in which they should be ranked.
						[array tagIds]		- The tags associated with the blog post.
		Output		:	BlogPost
	--->
	<cfinclude template="methods/blog/createBlogPost.cfm" />

	<!---
		Method		:	createBlogTag
		Description	:	Creates a new blog tag.
		Input		:	string tag			- The tag.
		Output		:	BlogTag
	--->
	<cfinclude template="methods/blog/createBlogTag.cfm" />

	<!---
		Method		:	createBlogUser
		Description	:	Creates a new blog user.
		Input		:	string name			- The name of the user.
						string externalId	- The user's id from the external user management system.
		Output		:	BlogUser
	--->
	<cfinclude template="methods/blog/createBlogUser.cfm" />

	<!---
		Method		:	deleteBlogPost
		Description	:	Deletes the specified blog post.
		Input		:	string id			- The id of the blog post.
		Output		:	void
	--->
	<cfinclude template="methods/blog/deleteBlogPost.cfm" />

	<!---
		Method		:	getBlogPostById
		Description	:	Gets the specified blog post, by id.
		Input		:	string id			- The id of the blog post.
		Output		:	BlogPost
	--->
	<cfinclude template="methods/blog/getBlogPostById.cfm" />

	<!---
		Method		:	getBlogPosts
		Description	:	Gets the specified number and offset of blog posts.
		Input		:	[numeric offset]	- The number of blog posts to skip before returning results.  Default is 0.
						[numeric limit]		- The maximum number of blog posts to return.  Default is 5.
						[string filter]		- A filter definition. ? = single character, * = multiple characters.
						[string tag]		- The name of the tag by which results should be filtered.
		Output		:	struct
	--->
	<cfinclude template="methods/blog/getBlogPosts.cfm" />

	<!---
		Method		:	getBlogTags
		Description	:	Gets all blog tags.
		Input		:	None
		Output		:	array
	--->
	<cfinclude template="methods/blog/getBlogTags.cfm" />

	<!---
		Method		:	getBlogUsers
		Description	:	Gets all blog users.
		Input		:	None
		Output		:	array
	--->
	<cfinclude template="methods/blog/getBlogUsers.cfm" />

	<!---
		Method		:	getLatestBlogPost
		Description	:	Gets the most recently published blog post.
		Input		:	None
		Output		:	BlogPost
	--->
	<cfinclude template="methods/blog/getLatestBlogPost.cfm" />


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
	<cfinclude template="methods/blog/updateBlogPost.cfm" />

</cfcomponent>
