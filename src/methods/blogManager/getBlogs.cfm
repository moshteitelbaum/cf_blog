<!---
	Method		:	getBlogs
	Description	:	Gets all blogs.
	Input		:	none
	Output		:	array
--->

<cffunction name="getBlogs" returntype="array" output="false" description="Gets all blogs.">

	<!---
		Declare local variables
	--->
	<cfset var arrBlogs = [] />
	<cfset var key = "" />


	<!---
		Iterate over the blogs in cache
	--->
	<cfloop collection="#variables.blogs#" item="key">

		<!--- Add the blog to the array --->
		<cfset arrayAppend( arrBlogs, variables.blogs[key] ) />

	</cfloop>


	<!---
		Return the array of blogs
	--->
	<cfreturn arrBlogs />

</cffunction>
