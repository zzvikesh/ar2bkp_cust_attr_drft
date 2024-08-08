@EndUserText.label: 'Projection of ZM_R_CustomerAIMSTP'

@AccessControl: {
    authorizationCheck: #NOT_REQUIRED
    //,privilegedAssociations: ['_CreatedByUserContactCard', '_LastChangedByUserContactCard']
}

-- Header Info (List and Object Page)
@UI.headerInfo: { typeName: 'Customer',
                  typeNamePlural: 'Customers',
                  //imageUrl: 'ImageURL',

                  title:{ value: 'Customer', type: #STANDARD, label: 'Testing' },
                  description: { value: 'CustomerName', type: #STANDARD, label: 'Testing' }
                 }
@ObjectModel:{ semanticKey: ['Customer',
                             'SalesOrganization',
                             'DistributionChannel',
                             'Division' ] }
@Search.searchable: true
define root view entity ZD_C_CustomerAIMSM
  provider contract transactional_query
  as projection on ZD_R_CustomerAIMSTP
{

      /* Object Page Annotations */

      @UI.facet: [
      // Object Page Header
      {
      id              : 'idSalesOrg',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqSalesOrg',
      position        : 10
      },
      {
      id              : 'idDistrChannel',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqDistrChannel',
      position        : 20
      },
      {
      id              : 'idDivision',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqDivision',
      position        : 30
      },
      {
        id              : 'idOPHAddtionalAttribues',
        purpose         : #HEADER,
        type            : #FIELDGROUP_REFERENCE,
        label           : 'Additional Header Information',
        targetQualifier : 'tqOPHAddtionalAttribues',
        position        : 40
      },

      // Object Page Tabs
      {
        id              : 'idCustomerInformation',
        label           : 'Customer Information',
        type            : #FIELDGROUP_REFERENCE,
        targetQualifier : 'tqCustomerInformation',
        position        : 10
      },
      {
        id              : 'idGlobalAttributes',
        label           : 'Global Customer Attributes',
        type            : #FIELDGROUP_REFERENCE,
        targetQualifier : 'tqGlobalCustomerAttributes',
        position        : 20
      },
      {
        id              : 'idShippingAttributes',
        label           : 'Global Shipping Attributes',
        type            : #FIELDGROUP_REFERENCE,
        targetQualifier : 'tqGlobalShippingAttributes',
        position        : 30
      },
      {
        id              : 'idGlobalOtherAttributes',
        label           : 'Global Other Attributes',
        type            : #FIELDGROUP_REFERENCE,
        targetQualifier : 'tqGlobalOtherAttributes',
        position        : 40
      },
      {
        id: 'CustomerShippingPoint',
        purpose: #STANDARD,
        type: #LINEITEM_REFERENCE,
        label: 'Local Shipping Points',
        position: 50,
        targetElement: '_CustomerShipPoint'
      },
      {
        id              : 'idAdministrativeFields',
        label           : 'Administrative Fields',
        type            : #FIELDGROUP_REFERENCE,
        targetQualifier : 'tqAdministrativeFields',
        position        : 60
      }]

      @Consumption.semanticObject : 'Customer'
      @Consumption.semanticObjectMapping:{ element: 'BusinessPartnerForEdit' }                                                        //Not working as expected
      @Consumption.semanticObjectMapping.additionalBinding: [ { element: 'BusinessPartner', localElement: 'Customer' } ]              //Not working as expected
      @UI:{ lineItem: [{ position: 10, importance: #HIGH }, //type: #WITH_INTENT_BASED_NAVIGATION, semanticObjectAction: 'manage' }
//                       { type: #WITH_NAVIGATION_PATHWITH_URL, label: 'Return OP',
//                          url: 'ImageURL' },
                       
                       { type: #FOR_INTENT_BASED_NAVIGATION, label: 'Manage Sales Order', semanticObject: 'SalesOrder', semanticObjectAction: 'manageV2', requiresContext: true },
                       { type: #FOR_INTENT_BASED_NAVIGATION, label: 'Manage Customer Returns', semanticObject: 'CustomerReturn', semanticObjectAction: 'manage', requiresContext: true }],
            selectionField: [{ position: 10 }],
            fieldGroup: [ { qualifier: 'tqCustomerInformation', position: 10, groupLabel: 'Customer Information' },
                          { qualifier: 'tqOPHAddtionalAttribues', position: 20, type: #AS_CONTACT, value: '_CustomerContactCard', label: 'Customer Contact Card' }] }
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZM_I_CustomerAIMSVH', element: 'Customer' } }]
      @ObjectModel.text.element: ['CustomerName']
      //@Consumption.filter:{ mandatory: true, selectionType: #SINGLE }
  key Customer,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 20, importance: #LOW }],
            dataPoint: { qualifier: 'tqSalesOrg', title: 'Sales Organization' },
            selectionField: [{ position: 20 }] }
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #MEDIUM }

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZM_I_SalesOrgAIMSVH', element: 'SalesOrganization' } }]
      @ObjectModel.text.element: ['SalesOrganizationName']
  key SalesOrganization,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 30, importance: #LOW }],
            dataPoint: { qualifier: 'tqDistrChannel', title: 'Distribution Channel' },
            selectionField: [{ position: 30 }] }
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZM_I_DistrChanAIMSVH', element: 'DistributionChannel' } }]
      @ObjectModel.text.element: ['DistributionChannelName']
  key DistributionChannel,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 40, importance: #LOW }],
            dataPoint: { qualifier: 'tqDivision', title: 'Division' },
            selectionField: [{ position: 40 }] }
      @ObjectModel.foreignKey.association: '_Division'
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
      @ObjectModel.text.element: ['DivisionName']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZM_I_DivisionVH', element: 'Division' } }]
  key Division,

      @Consumption.filter.hidden: true
      @UI:{ lineItem: [{ position: 50 }],
            selectionField: [{ position: 50 }],
            fieldGroup: [ { qualifier: 'tqOPHAddtionalAttribues', position: 10 }] }
      @ObjectModel.text.element: ['PlantName']
      DeliveringPlant,

      @UI:{ fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 20 }] }
      _CustomerContactCard.CustomerFullName,
      @UI:{ lineItem: [{ position: 60, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 30 }] }
      _CustomerContactCard.Country,
      @UI:{ lineItem: [{ position: 70, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 40 }] }

      @Semantics.personalData.isPotentiallySensitive: true
      _CustomerContactCard.CityName,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 80, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 50 }] }
      _CustomerContactCard.PostalCode,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 90, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 60 }] }
      _CustomerContactCard.StreetName,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ lineItem: [{ position: 100, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 70 }] }
      _CustomerContactCard.Region,
      @UI:{ lineItem: [{ position: 110, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 80 }] }
      _CustomerContactCard.TelephoneNumber1,
      @UI:{ lineItem: [{ position: 120, importance: #LOW }],
            fieldGroup: [{ qualifier: 'tqCustomerInformation', position: 90 }] }
      _CustomerContactCard.TelephoneNumber2,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalCustomerAttributes', position: 10, groupLabel: 'Global Customer Attributes' }] }
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZM_I_BarcodeIndVH', element: 'BarcodeIndicator' }, useForValidation: true }]
      BarcodeIndicator,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalCustomerAttributes', position: 20 }] }
      DistributionCenterID,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalShippingAttributes', position: 10, groupLabel: 'Global Shipping Attributes' }] }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
      @ObjectModel.text.element: ['PickCustomerConsolidText']
      PickCustomerConsolidatation,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalShippingAttributes', position: 20 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, useForValidation: true }]
      @ObjectModel.text.element: ['PickConsolidatationByPOText']
      PickConsolidatationByPO,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalShippingAttributes', position: 30 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
      @ObjectModel.text.element: ['PickConsolidateByAttnLineText']
      PickConsolidateByAttentionLine,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalShippingAttributes', position: 40 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
      @ObjectModel.text.element: ['BarCodedPalletContentSheetText']
      BarCodedPalletContentSheet,

      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalOtherAttributes', position: 10, groupLabel: 'Global Other Attributes' }] }
      ShipViaCode,
      @UI:{ fieldGroup: [{ qualifier: 'tqGlobalOtherAttributes', position: 20 }] }
      FrozenShipViaCode,

      @Semantics.personalData.isPotentiallySensitive: true
      @UI:{ fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 10, groupLabel: 'Administrative Fields'//,
                           //type: #AS_CONTACT, value: '_CreatedByUserContactCard'
                           }] } //type: #AS_CONTACT, value: '_CreatedByUserContactCard', label: 'Created By'
      @ObjectModel.text.element: ['CreatedByName']
      CreatedBy,
      @UI:{ selectionField: [{ position: 60 }],
            fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 20 }] }
      @Consumption:{ filter:{ selectionType: #INTERVAL } }
      CreatedAt,

      @Semantics.personalData.isPotentiallySensitive: true                        //Not working as expected
      @UI:{ fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 30 }] } //type: #AS_CONTACT, value: '_LastChangedByUserContactCard', label: 'Changed By'
      @ObjectModel.text.element: ['ChangedByName']
      LocalLastChangedBy,
      @UI:{ fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 40 }] }
      LocalLastChangedAt, //Local ETag field --> OData ETag

      /* Text Values */

      _Customer.CustomerName,
      @UI.hidden: true
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
      _Customer.OrganizationBPName1,
      @UI.hidden: true
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
      _Customer.OrganizationBPName2,
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #MEDIUM }
      _SalesOrganization._Text.SalesOrganizationName                                     : localized,
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
      _DistributionChannel._Text.DistributionChannelName                                 : localized,
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
      _Division._Text.DivisionName                                                       : localized,

      _CustomerSalesArea._SupplyingPlant.PlantName,
      _PickCustomerConsolidatation._Text.Description   as PickCustomerConsolidText       : localized,
      _PickConsolidatationByPO._Text.Description       as PickConsolidatationByPOText    : localized,
      _PickConsolidateByAttntionLine._Text.Description as PickConsolidateByAttnLineText  : localized,
      _BarCodedPalletContentSheet._Text.Description    as BarCodedPalletContentSheetText : localized,

      _CreatedBy.UserDescription                       as CreatedByName,
      _LastChangedBy.UserDescription                   as ChangedByName,

      /* Hidden from UI */

      @UI.hidden: true
      ImageURL,
      @UI.hidden: true
      LastChangedAt, //Total ETag

      /* Associations */

      @Consumption.filter.hidden: true
      _Customer,
      @Consumption.filter.hidden: true
      _SalesOrganization,
      @Consumption.filter.hidden: true
      _DistributionChannel,
      @Consumption.filter.hidden: true
      _Division,
      @Consumption.filter.hidden: true
      _PickCustomerConsolidatation,
      @Consumption.filter.hidden: true
      _CustomerContactCard,
      @Consumption.filter.hidden: true
      _CreatedBy,
      @Consumption.filter.hidden: true
      _LastChangedBy,

      /* Compositions */
      _CustomerShipPoint : redirected to composition child ZD_C_CustomerShipPointM

}
