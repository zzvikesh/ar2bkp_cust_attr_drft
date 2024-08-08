//Description
@EndUserText.label: 'Ship-Via Changed'
//VDM Exposed As
@VDM.usage.type: [#EVENT_SIGNATURE]
define abstract entity ZVKS_D_ShipViaChanged
{

      ShippingPoint       : vstel;
      ShipViaCode         : abap.char(21);
      @Event.raisedAt.dateTime   : true
      EventRaisedDateTime : abp_lastchange_tstmpl;
}

