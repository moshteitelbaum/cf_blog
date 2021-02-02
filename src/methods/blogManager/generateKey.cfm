<!---
	Method		:	generateKey
	Description	:	Generates the key used to store blog objects in cache.
	Input		:	string id			- The id of the blog.
	Output		:	string
--->

<cffunction name="generateKey" returntype="string" output="false" access="package" description="Generates the key used to store blog objects in cache.">

	<!---
		Define arguments
	--->
	<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the blog." />


	<!---
		Declare local variables
	--->
	<cfset var key = reReplace(arguments.id, "[^A-Za-z0-9]", "", "all") />


	<!---
		Return the blog key
	--->
	<cfreturn key />

</cffunction>
