@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Attributes'
define view entity ZD_R_CustomerShipPointTP
  as select from ZM_R_CustomerShipPoint
  association        to parent ZD_R_CustomerAIMSTP as _CustomerAIMS                  on  $projection.Customer            = _CustomerAIMS.Customer
                                                                                     and $projection.SalesOrganization   = _CustomerAIMS.SalesOrganization
                                                                                     and $projection.DistributionChannel = _CustomerAIMS.DistributionChannel
                                                                                     and $projection.Division            = _CustomerAIMS.Division
  //Additional Data
  association [0..1] to I_User                     as _CreatedBy                     on  $projection.CreatedBy = _CreatedBy.UserID
  association [0..1] to I_User                     as _LastChangedBy                 on  $projection.LocalLastChangedBy = _LastChangedBy.UserID
  association [1..1] to I_ShippingPoint            as _ShippingPoint                 on  $projection.ShippingPoint = _ShippingPoint.ShippingPoint
  association [1..1] to ZM_I_AIMSFlagVH            as _PickCustomerConsolidatation   on  $projection.PickCustomerConsolidatation = _PickCustomerConsolidatation.Code
  association [1..1] to ZM_I_AIMSFlagVH            as _PickConsolidatationByPO       on  $projection.PickConsolidatationByPO = _PickConsolidatationByPO.Code
  association [1..1] to ZM_I_AIMSFlagVH            as _PickConsolidateByAttntionLine on  $projection.PickConsolidateByAttentionLine = _PickConsolidateByAttntionLine.Code
  association [1..1] to ZM_I_AIMSFlagVH            as _BarCodedPalletContentSheet    on  $projection.BarCodedPalletContentSheet = _BarCodedPalletContentSheet.Code
{
  key Customer,
  key SalesOrganization,
  key DistributionChannel,
  key Division,
  key ShippingPoint,
      'sap-icon://shipping-status' as ImageURL,

      /* Shipping Attributes */

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
      _ShippingPoint,
      _PickCustomerConsolidatation,
      _PickConsolidatationByPO,
      _PickConsolidateByAttntionLine,
      _BarCodedPalletContentSheet,

      _CreatedBy,
      _LastChangedBy,

      /* Compositions */

      _CustomerAIMS // Make association public
}
