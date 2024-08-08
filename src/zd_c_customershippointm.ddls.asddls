@EndUserText.label: 'Projection of ZM_R_CustomerShipPointTP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
-- Header Info (List and Object Page)
@UI.headerInfo: { typeName: 'Shipping Point',
                  typeNamePlural: 'Shipping Points',
                  imageUrl: 'ImageURL',
                  title:{ value: 'ShippingPoint', type: #STANDARD },
                  description: { value: 'ShippingPointName', type: #STANDARD }
                  }
@ObjectModel:{ semanticKey: [//'Customer',
                             //'SalesOrganization',
                             //'DistributionChannel',
                             //'Division',
                             'ShippingPoint' ] }
@Search.searchable: true
define view entity ZD_C_CustomerShipPointM
  as projection on ZD_R_CustomerShipPointTP
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

          //          {
          //            id              : 'idOPHKeyAttribues',
          //            purpose         : #HEADER,
          //            type            : #FIELDGROUP_REFERENCE,
          //            //label           : 'Key Attributes',
          //            targetQualifier : 'tqOPHKeyAttributes',
          //            position        : 10
          //          },

          // Object Page Tabs

          {
            id              : 'idShippingAttributes',
            label           : 'Shipping Attributes',
            type            : #FIELDGROUP_REFERENCE,
            targetQualifier : 'tqShippingAttributes',
            position        : 20
          },
          {
            id              : 'idOtherAttributes',
            label           : 'Other Attributes',
            type            : #FIELDGROUP_REFERENCE,
            targetQualifier : 'tqOtherAttributes',
            position        : 30
          },
          {
            id              : 'idAdministrativeFields',
            label           : 'Administrative Fields',
            type            : #FIELDGROUP_REFERENCE,
            targetQualifier : 'tqAdministrativeFields',
            position        : 40
           }]

          @ObjectModel.text.element: ['CustomerName']
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
  key     Customer,

          @UI:{ dataPoint: { qualifier: 'tqSalesOrg', title: 'Sales Organization' },
                fieldGroup: [{ qualifier: 'tqOPHKeyAttributes', position: 20 }] }
          @ObjectModel.text.element: ['SalesOrganizationName']
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #MEDIUM }
  key     SalesOrganization,

          @UI:{ dataPoint: { qualifier: 'tqDistrChannel', title: 'Distribution Channel' },
                fieldGroup: [{ qualifier: 'tqOPHKeyAttributes', position: 30 }]  }
          @ObjectModel.text.element: ['DistributionChannelName']
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
  key     DistributionChannel,

          @UI:{ dataPoint: { qualifier: 'tqDivision', title: 'Division' },
                fieldGroup: [{ qualifier: 'tqOPHKeyAttributes', position: 40 }] }
          @ObjectModel.text.element: ['DivisionName']
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
  key     Division,

          @UI:{ lineItem: [{ position: 10 }] }
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_ShippingPointVH', element: 'ShippingPoint' }, useForValidation: true }]
          @ObjectModel.text.element: ['ShippingPointName']
  key     ShippingPoint,

          @UI:{ fieldGroup: [{ qualifier: 'tqShippingAttributes', position: 20 }] }
          @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
          @ObjectModel.text.element: ['PickCustomerConsolidText']
          PickCustomerConsolidatation,

          @UI:{ fieldGroup: [{ qualifier: 'tqShippingAttributes', position: 30 }] }
          @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
          @ObjectModel.text.element: ['PickConsolidatationByPOText']
          PickConsolidatationByPO,

          @UI:{ fieldGroup: [{ qualifier: 'tqShippingAttributes', position: 40 }] }
          @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true , useForValidation: false }]
          @ObjectModel.text.element: ['PickConsolidateByAttnLineText']
          PickConsolidateByAttentionLine,

          @UI:{ fieldGroup: [{ qualifier: 'tqShippingAttributes', position: 50 }] }
          @Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_AIMSFlagVH' , element: 'Code' }, distinctValues: true, useForValidation: true }]
          //@Consumption.valueHelpDefinition: [{ entity: { name : 'ZM_I_DomainVH' , element: 'low' }, 
          //additionalBinding: [{ element: 'domain_name', localConstant: 'ZMCUST_INFO_STS1' }],           
          //distinctValues: true, useForValidation: true }]
          @ObjectModel.text.element: ['BarCodedPalletContentSheetText']
          BarCodedPalletContentSheet,

          @UI:{ fieldGroup: [{ qualifier: 'tqOtherAttributes', position: 10 }] }
          ShipViaCode,
          @UI:{ fieldGroup: [{ qualifier: 'tqOtherAttributes', position: 20 }] }
          FrozenShipViaCode,

          @UI:{ lineItem: [{ position: 60, importance: #LOW }],
                fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 10 }] }
          @ObjectModel.text.element: ['CreatedByName']
          CreatedBy,
          @UI:{ lineItem: [{ position: 80, importance: #LOW }],
                fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 20 }] }
          CreatedAt,
          @UI:{ lineItem: [{ position: 70, importance: #LOW, label: 'Changed By' }],
                fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 30 }] }
          @ObjectModel.text.element: ['ChangedByName']
          LocalLastChangedBy,
          @UI:{ lineItem: [{ position: 90, importance: #LOW, label: 'Changed At' }],
                fieldGroup: [{ qualifier: 'tqAdministrativeFields', position: 40 }] }
          LocalLastChangedAt, //Local ETag field --> OData ETag

          /* Text Values */

          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
          _Customer.CustomerName,
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #MEDIUM }
          _SalesOrganization._Text.SalesOrganizationName                                    : localized,
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
          _DistributionChannel._Text.DistributionChannelName                                : localized,
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #LOW }
          _Division._Text.DivisionName                                                      : localized,
          @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7, ranking: #HIGH }
          _ShippingPoint._Text.ShippingPointName                                            : localized,

          _PickCustomerConsolidatation._Text.Description   as PickCustomerConsolidText        : localized,
          _PickConsolidatationByPO._Text.Description       as PickConsolidatationByPOText         : localized,
          _PickConsolidateByAttntionLine._Text.Description as PickConsolidateByAttnLineText : localized,
          _BarCodedPalletContentSheet._Text.Description    as BarCodedPalletContentSheetText   : localized,

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
          _ShippingPoint,

          /* Compositions */

          _CustomerAIMS : redirected to parent ZD_C_CustomerAIMSM
}
