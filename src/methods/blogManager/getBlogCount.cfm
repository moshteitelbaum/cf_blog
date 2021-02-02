<!---
	Method		:	getBlogCount
	Description	:	Gets the number of blogs.
	Input		:	none
	Output		:	numeric
--->

<cffunction name="getBlogCount" returntype="numeric" output="false" description="Gets the number of blogs.">

	<!---
		Return the number of blogs
	--->
	<cfreturn structCount( variables.blogs ) />

</cffunction>
