<!-----------------------------------------------------------------------Author 	    :	Luis MajanoDate        :	August 21, 2006Description :	This is a cfc that contains method implementations for the base	cfc's eventhandler and plugin.Modification History:08/21/2006 - Created-----------------------------------------------------------------------><cfcomponent name="sharedlibrary" hint="This is the shared library cfc. Method implementations here are used as facades from the eventhandler and the plugin base cfc's" output="false" extends="coldbox.system.controller"><!------------------------------------------- CONSTRUCTOR ------------------------------------------->	<cffunction name="init" access="public" returntype="any" output="false">		<cfreturn this>	</cffunction><!------------------------------------------- PUBLIC ------------------------------------------->	<!--- ************************************************************* --->	<cffunction name="getMyPlugin" access="public" hint="Get a custom plugin" returntype="any" output="false">		<!--- ************************************************************* --->		<cfargument name="plugin" type="string" hint="The Plugin object's name to instantiate" required="true" >		<!--- ************************************************************* --->		<cftry>			<cfreturn CreateObject("component", "#getSetting("MyPluginsLocation")#.#trim(arguments.plugin)#").init()>			<cfcatch type="any">				<cfthrow type="Framework.InvalidPluginInstantiationException" message="Framework.getPlugin: Error Instantiating Plugin Object (#getSetting("MyPluginsLocation")#.#trim(arguments.plugin)#)" detail="#cfcatch.Message# #cfcatch.detail#">			</cfcatch>		</cftry>	</cffunction>	<!--- ************************************************************* --->		<!--- ************************************************************* --->	<cffunction name="getDatasource" access="public" output="false" returnType="any" hint="I will return to you a datasourceBean according to the name of the datasource you wish to get from the configstruct (config.xml)">		<!--- ************************************************************* --->		<cfargument name="name" type="string" hint="The name of the datasource to get from the configstruct (name property in the config.xml)">		<!--- ************************************************************* --->		<cfset var datasources = getSetting("Datasources")>		<!--- Check for the datasources structure --->		<cfif structIsEmpty(datasources) >			<cfthrow type="Framework.eventhandler.DatasourceStructureEmptyException" message="There are no datasources defined for this application.">		</cfif>		<!--- Try to get the correct datasources --->		<cfif structKeyExists(datasources, arguments.name)>			<cfreturn getPlugin("beanFactory").create("coldbox.system.beans.datasource").init(datasources[arguments.name])>		<cfelse>			<cfthrow type="Framework.eventhandler.DatasourceNotFoundException" message="The datasource: #arguments.name# is not defined.">		</cfif>			</cffunction>	<!--- ************************************************************* --->		<!--- ************************************************************* --->	<cffunction name="filterQuery" access="public" returntype="query" hint="Filters a query by the given value" output="false">		<!--- ************************************************************* --->		<cfargument name="qry" 			type="query" 	required="yes" hint="Query to filter">		<cfargument name="field" 		type="string" 	required="yes" hint="Field to filter on">		<cfargument name="value" 		type="string" 	required="yes" hint="Value to filter on">		<cfargument name="cfsqltype" 	type="string" 	required="no" default="cf_sql_varchar" hint="The cf sql type of the value.">		<!--- ************************************************************* --->		<cfset var qryNew = QueryNew("")>		<cfquery name="qryNew" dbtype="query">			SELECT *				FROM arguments.qry				WHERE #trim(arguments.field)# = <cfqueryparam cfsqltype="#trim(arguments.cfsqltype)#" value="#trim(arguments.value)#">		</cfquery>		<cfreturn qryNew>	</cffunction>	<!--- ************************************************************* --->		<!--- ************************************************************* --->	<cffunction name="sortQuery" access="public" returntype="query" hint="Sorts a query by the given field" output="false">		<!--- ************************************************************* --->		<cfargument name="qry" 			type="query" 	required="yes" hint="Query to sort">		<cfargument name="sortBy" 		type="string" 	required="yes" hint="Sort by column(s)">		<cfargument name="sortOrder" 	type="string" 	required="no" default="ASC" hint="ASC/DESC">		<!--- ************************************************************* --->		<cfset var qryNew = QueryNew("")>		<!--- Validate sortOrder --->		<cfif not reFindnocase("(asc|desc)", arguments.sortOrder)>			<cfthrow type="Framework.sharedLibrary.InvalidSortOrderException" message="The sortOrder you sent in: #arguments.sortOrder# is not valid. Valid sort orders are ASC|DESC">		</cfif>		<cfquery name="qryNew" dbtype="query">			SELECT *				FROM arguments.qry				ORDER BY #trim(Arguments.SortBy)# #Arguments.SortOrder#		</cfquery>		<cfreturn qryNew>	</cffunction>	<!--- ************************************************************* --->		<!--- ************************************************************* --->	<cffunction name="getfwLocale" access="public" output="false" returnType="string" hint="Get the default locale string used in the framework.">		<cfswitch expression="#getSetting("LocaleStorage")#">			<cfcase value="session" >				<cfif not structKeyExists(session,"DefaultLocale")>					<cfset getPlugin("i18n").setfwLocale(getSetting("DefaultLocale"))>				</cfif>				<cfreturn session.DefaultLocale>			</cfcase>			<cfcase value="client">				<cfif not structKeyExists(client,"DefaultLocale")>					<cfset getPlugin("i18n").setfwLocale(getSetting("DefaultLocale"))>				</cfif>				<cfreturn client.DefaultLocale>			</cfcase>			<cfdefaultcase>				<cfthrow type="Framework.plugins.i18N.DefaultSettingsInvalidException" message="The default settings in your config are blank. Please make sure you create the i18n elements.">			</cfdefaultcase>		</cfswitch>	</cffunction>	<!--- ************************************************************* --->	<!------------------------------------------- PRIVATE -------------------------------------------></cfcomponent>