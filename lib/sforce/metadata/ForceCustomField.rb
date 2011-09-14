class ForceCustomField

	#define attributes
	@@attributes =  [
		:fullName,
		:caseSensitive,
		:customDataType,
		:defaultValue,
		:deprecated,
		:description,
		:displayFormat,
		:escapeMarkup,
		:externalId,
		:formula,
		:formulaTreatBlanksAs,
		:label,
		:length,
		:maskChar,
		:maskType,
		:picklist,
		:populateExistingRows,
		:precision,
		:referenceTo,
		:relationshipLabel,
		:relationshipName,
		:relationshipOrder,
		:required,
		:restrictedAdminField,
		:scale,
		:startingNumber,
		:stripMarkup,
		:summarizedField,
		:summaryFilterItems,
		:summaryForeignKey,
		:summaryOperation,
		:trackFeedHistory,
		:trackHistory,
		:type,
		:unique,
		:visibleLines,
		:writeRequiresMasterRead
	]

	#create accessors
	@@attributes.each {|attr| attr_accessor attr}


	#method that print an xml representation of the objec
	def getMetadata

		String sXML = '<metadata xsi:type="ns2:CustomField" xmlns:ns2="http://soap.sforce.com/2006/04/metadata">'
		@@attributes.each do |attr|

			value = send attr
			if(value != nil)
				sXML+='<'+attr.to_s+'>'+value+'</'+attr.to_s+'>'
			end
		end
		sXML+='</metadata>'
		
		return sXML
	end


end