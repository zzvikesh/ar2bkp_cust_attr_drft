@AccessControl: {
    authorizationCheck: #NOT_REQUIRED
    //,privilegedAssociations: ['_CreatedByUserContactCard', '_LastChangedByUserContactCard']
}

@EndUserText.label: 'Customer Master AIMS'
define root view entity ZD_R_CustomerAIMSTP
  as select from ZM_R_CustomerAIMS
  composition [0..*] of ZD_R_CustomerShipPointTP as _CustomerShipPoint

  //Additional Data
  association [0..1] to ZM_I_CustomerContactCard as _CustomerContactCard           on  $projection.Customer = _CustomerContactCard.Customer
  association [0..1] to I_User                   as _CreatedBy                     on  $projection.CreatedBy = _CreatedBy.UserID
  association [0..1] to I_User                   as _LastChangedBy                 on  $projection.LocalLastChangedBy = _LastChangedBy.UserID
  association [0..1] to I_CustomerSalesArea      as _CustomerSalesArea             on  $projection.Customer            = _CustomerSalesArea.Customer
                                                                                   and $projection.SalesOrganization   = _CustomerSalesArea.SalesOrganization
                                                                                   and $projection.DistributionChannel = _CustomerSalesArea.DistributionChannel
                                                                                   and $projection.Division            = _CustomerSalesArea.Division
  association [1..1] to ZM_I_AIMSFlagVH          as _PickCustomerConsolidatation   on  $projection.PickCustomerConsolidatation = _PickCustomerConsolidatation.Code
  association [1..1] to ZM_I_AIMSFlagVH          as _PickConsolidatationByPO       on  $projection.PickConsolidatationByPO = _PickConsolidatationByPO.Code
  association [1..1] to ZM_I_AIMSFlagVH          as _PickConsolidateByAttntionLine on  $projection.PickConsolidateByAttentionLine = _PickConsolidateByAttntionLine.Code
  association [1..1] to ZM_I_AIMSFlagVH          as _BarCodedPalletContentSheet    on  $projection.BarCodedPalletContentSheet = _BarCodedPalletContentSheet.Code
{
      /* Header Data */
  key Customer,
  key SalesOrganization,
  key DistributionChannel,
  key Division,

      @EndUserText:{ label: 'Delivering Plant' }
      _CustomerSalesArea.SupplyingPlant as DeliveringPlant,

      //Local Constants
      'www.bing.com'             as ImageURL,

      /* Global Attributes */

      BarcodeIndicator,
      DistributionCenterID,

      /* Global Shipping Attributes */

      PickCustomerConsolidatation,
      PickConsolidatationByPO,
      PickConsolidateByAttentionLine,
      BarCodedPalletContentSheet,

      /* Other Attributes */

      ShipViaCode,
      FrozenShipViaCode,

      /* Admin Fields */

      CreatedBy,
      CreatedAt,
      LastChangedAt,      //Total ETag
      LocalLastChangedBy,
      LocalLastChangedAt, //Local ETag field --> OData ETag

      /* Associations */

      _Customer,
      _SalesOrganization,
      _DistributionChannel,
      _Division,
      _PickCustomerConsolidatation,
      _PickConsolidatationByPO,
      _PickConsolidateByAttntionLine,
      _BarCodedPalletContentSheet,
      _CustomerContactCard,
      _CustomerSalesArea,
      _CreatedBy,
      _LastChangedBy,

      /* Compositions */

      _CustomerShipPoint // Make association public

}
