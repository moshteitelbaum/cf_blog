<!---
	BlogUser.cfc
--->

<cfcomponent displayName="BlogUser" output="false" accessors="true">

	<!--- Define properties --->
	<cfproperty name="id" type="string" required="true" displayName="id" hint="The id of the user." />
	<cfproperty name="name" type="string" required="true" displayName="name" hint="The name of the user." />
	<cfproperty name="externalId" type="string" required="true" displayName="externalId" hint="The external id of the user." />



	<!---
	***********************************************************************************************
		Constructor method definition
	***********************************************************************************************
	--->

	<cffunction name="init" returnType="BlogUser" output="false" access="public">

		<!---
			Define arguments
		--->
		<cfargument name="id" type="string" required="true" displayName="id" hint="The id of the user." />
		<cfargument name="name" type="string" required="true" displayName="name" hint="The name of the user." />
		<cfargument name="externalId" type="string" required="true" displayName="externalId" hint="The external id of the user." />


		<!---
			Set properties
		--->
		<cfset setId( arguments.id ) />
		<cfset setName( arguments.name ) />
		<cfset setExternalId( arguments.externalId ) />


		<!---
			Return a reference to the BlogUser object
		--->
		<cfreturn this />

	</cffunction>

</cfcomponent>
