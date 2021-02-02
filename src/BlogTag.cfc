<!---
	BlogTag.cfc
--->

<cfcomponent displayName="BlogTag" output="false" accessors="true">

	<!--- Define properties --->
	<cfproperty name="id" type="string" required="true" displayName="id" hint="The id of the tag." />
	<cfproperty name="tag" type="string" required="true" displayName="tag" hint="The tag." />



	<!---
	***********************************************************************************************
		Constructor method definition
	***********************************************************************************************
	--->

	<cffunction name="init" returnType="BlogTag" output="false" access="public">

		<!---
			Define arguments
		--->
		<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the tag." />
		<cfargument name="tag" type="string" required="true" displayName="tag" hint="The tag." />


		<!---
			Set properties
		--->
		<cfset setId( arguments.id ) />
		<cfset setTag( arguments.tag ) />


		<!---
			Return a reference to the BlogTag object
		--->
		<cfreturn this />

	</cffunction>

</cfcomponent>
