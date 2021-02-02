<!---
	Method		:	getDatasource
	Description	:	Gets the name of the datasource.
	Input		:	none
	Output		:	string
--->

<cffunction name="getDatasource" returntype="string" output="false" access="package" description="Gets the name of the datasource.">

	<!---
		Return the name of the datasource
	--->
	<cfreturn variables.datasource />

</cffunction>
