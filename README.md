# cf_blog
by Mosh Teitelbaum ([moshteitelbaum.com][1])

cf_blog is a simple, headless blog system written in ColdFusion and MS SQL
Server.  It is the system I use on my personal website to manage my blog
posts and the current features are based on what I needed. I plan to
continue adding new features as time permits.  Suggestions are, of course,
welcome.

## Features

* Supports an unlimited number of blogs
* Includes basic caching of blogs, posts, tags, and authors
* Supports searching for matching blog posts by keyword and/or tag
* Supports multiple authors which can be tied to a user ID from an external user management system

## Setup

Dump the files somewhere in your code base and execute the `db/create_database.sql`
SQL script to create the tables, relationships, etc. in your database.

In your `Application.cfc` file, create a mapping to the "cf-blog" directory like:

	<cfset this.mappings["/cf-blog"] = "path/to/cf-blog" />

In the `onApplicationStart()` method of `Application.cfc`, add a permanent reference
to the BlogManager and, if you only have one blog, to that blog as well:

	<cfset application.blogManager = createObject("component","cf-blog.BlogManager").init("datasource_name") />
	<cfset application.blog = application.blogManager.getBlogByName("Name of my Blog") />

## Usage

cf_blog usage revolves around 5 types of blog-related objects:

* **BlogManager** - Allows for managing (create, update, delete, list, get) blogs.
* **Blog** - Represents a single blog and is the primary source for all blog-related functionality.
* **BlogPost** - Represents a single blog post.
* **BlogTag** - Represents a single blog tag.
* **BlogUser** - Represents a single blog user (author, commenter (future)).

### Create a new blog

	<cfset blog = application.blogManager.createBlog("Blog name", "blog description") />

### Update a blog

	<cfset blog = application.blogManager.updateBlog("Blog id", Blog name", "blog description") />

### Delete a blog

	<cfset application.blogManager.deleteBlog("Blog id") />

### Get all blogs

	<cfset blogArray = application.blogManager.getBlogs() />

### Get a specific blog

	<cfset blog = application.blogManager.getBlogById("Blog id") />

or

	<cfset blog = application.blogManager.getBlogByName("Blog name") />

### Get the number of blogs

	<cfset blogCount = application.blogManager.getBlogCount() />

### Create a new blog post

	<cfset blogPost = blog.createBlogPost( argumentCollection = {
			"title" : "The title",
			"summary" : "The summary",
			"body" : "The body",
			"url" : "The url (absolute or relative) to the blog post",
			"published" : "Date/time of publication",
			"authorIds" : "Optional array of blog user ids",
			"tagIds" : "Optional array of blog tag ids"
		}) />

### Update a blog post

	<cfset blogPost = blog.updateBlogPost( argumentCollection = {
			"id" : "The id of the blog post",
			"title" : "The title",
			"summary" : "The summary",
			"body" : "The body",
			"url" : "The url (absolute or relative) to the blog post",
			"published" : "Date/time of publication",
			"authorIds" : "Optional array of blog user ids",
			"tagIds" : "Optional array of blog tag ids"
		}) />

### Delete a blog post

	<cfset blog.deleteBlogPost("The id of the blog post") />

### Create a new blog tag

	<cfset blogTag = blog.createBlogTag( argumentCollection = {
			"tag" : "The tag"
		}) />

### Create a new blog user

	<cfset blogUser = blog.createBlogUser( argumentCollection = {
			"name" : "The name of the user as it should be displayed",
			"externalId" : "The id of the user within the external user management system"
		}) />

### Get multiple blog posts

	<cfset blogPosts = blog.getBlogPosts( argumentCollection = {
			"offset" : "Optional number of posts by which results should be offset from the newest post. Zero-based. Default is 0.",
			"limit" : "Optional maximum number of posts to return. Default is 5.",
			"filter" : "Optional string filter definition. ? = single character, * = multiple characters.",
			"tag" : "Optional name of the tag by which results should be filtered."
		}) />

Returns a struct with the following keys:

* **data** - An array of BlogPost objects.
* **count** - The number of blog posts returned.
* **hasPrevious** - Boolean indicating if there are any blog posts published before those in the current results.
* **hasNext** - Boolean indicating if there are any blog posts published after those in the current results.
* **rangeStart** - The number, out of all blog posts, of the newest blog post in the results.
* **rangeEnd** - The number, out of all blog posts, of the oldest blog post in the results.
* **totalPosts** - The total number of blog posts.

### Get a specific blog post

	<cfset blogPost = blog.getBlogPostById( argumentCollection = {
			"id" : "The blog post id"
		}) />

### Get the latest blog post

	<cfset blogPost = blog.getLatestBlogPost() />

### Get all blog tags

	<cfset blogTagArray = blog.getBlogTags() />

### Get all blog users

	<cfset blogUserArray = blog.getBlogUsers() />

## Examples

Create a new blog, add a post to it, and then display the post:

	<!--- Create a permanent reference to the BlogManager --->
	<cfset application.blogManager = createObject("component","cf-blog.BlogManager").init("datasource_name") />

	<!--- Create the new blog and add a tag and a user to it --->
	<cfset blog = application.blogManager.createBlog("CF Blog", "The ColdFusion blog.") />
	<cfset blogTag = blog.createBlogTag("ColdFusion") />
	<cfset blogUser = blog.createBlogUser( argumentCollection = {
			"name" : "Mosh Teitelbaum",
			"externalId" : "abc123"
		}) />

	<!--- Create a new blog post --->
	<cfset blogPost = blog.createBlogPost( argumentCollection = {
			"title" : "Hello World!",
			"summary" : "Saying hello to the world in my first blog post!",
			"body" : "Lorem ipsum...",
			"url" : "/blog/articles/hello-world/",
			"published" : now(),
			"authorIds" : [blogUser.getId()],
			"tagIds" : [blogTag.getId()]
		}) />

	<!--- Show the new blog post --->
	<cfoutput>
		<h2 class="blog-post-title">#blogPost.getTitle()#</h2>
		<p class="blog-post-body">#blogPost.getBody()#</p>
		<p class="blog-post-date">#dateFormat(blogPost.getPublished(), "mm/dd/yyyy")#</p>
	</cfoutput>

List the 5 newest blog posts:

	<!--- Get a reference to the blog --->
	<cfset blog = application.blogManager.getBlogByName("CF Blog") />

	<!--- Get the latest blog posts --->
	<cfset blogPosts = blog.getBlogPosts( argumentCollection = {
			"offset" : 0,
			"limit" : 5
		}) />

	<!--- Show the latest blog posts' summaries --->
	<cfloop array="#blogPosts.data#" item="blogPost">
		<cfoutput>
			<a href="#blogPost.getUrl()#">#blogPost.getTitle()#</a>
			<p>
				#blogPost.getSummary()#
			</p>
		</cfoutput>
	</cfloop>

	<!--- Show blog listing status --->
	Posts #blogPosts.rangeEnd# to #blogPosts.rangeStart# of #blogPosts.totalPosts#

	<!--- Show blog listing navigation --->
	<cfif blogPosts.hasNext>
		<a href="">Newer posts</a>
	</cfif>
	<cfif blogPosts.hasPrevious>
		<a href="">Older posts</a>
	</cfif>



[1]: https://moshteitelbaum.com
