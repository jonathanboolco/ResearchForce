class ForceCustomObject

	#define attributes
	@@attributes =  [
		:fullName,
		:actionOverrides,
		:articleTypeChannelDisplay,
		:businessProcesses,
		:customHelp,
		:customHelpPage,
		:customSettingsType,
		:customSettingsVisibility,
		:deploymentStatus,
		:deprecated,
		:description,
		:enableActivities,
		:enableDivisions,
		:enableEnhancedLookup,
		:enableFeeds,
		:enableHistory,
		:enableReports,
		:fieldSets,
		:fields,
		:gender,
		:household,
		:label,
		:listViews,
		:nameField,
		:pluralLabel,
		:namedFilters,
		:recordTypeTrackFeedHistory,
		:recordTypeTrackHistory,
		:recordTypes,
		:searchLayouts,
		:sharingModel,
		:sharingRecalculations,
		:startsWith,
		:validationRules,
		:webLinks
	]

	#create accessors
	@@attributes.each {|attr| attr_accessor attr}


	#method that print an xml representation of the objec
	def getMetadata

		String sXML = '<metadata xsi:type="ns2:CustomObject" xmlns:ns2="http://soap.sforce.com/2006/04/metadata">'
		@@attributes.each do |attr|

			value = send attr
			if(value != nil)

				if(attr.to_s == 'fields')
					value.each do |f|
						sXML+= f.getMetadata
					end
				else
					sXML+='<'+attr.to_s+'>'+value+'</'+attr.to_s+'>'
				end
			end

		end
		sXML+='</metadata>'
		
		puts sXML
		return sXML
		
	end


end