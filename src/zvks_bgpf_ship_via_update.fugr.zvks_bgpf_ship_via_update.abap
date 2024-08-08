FUNCTION zvks_bgpf_ship_via_update.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_CUSTOMER) TYPE  KUNNR OPTIONAL
*"     VALUE(IV_SALESORGANIZATION) TYPE  VKORG OPTIONAL
*"     VALUE(IV_DISTRIBUTIONCHANNEL) TYPE  VTWEG OPTIONAL
*"     VALUE(IV_DIVISION) TYPE  SPART OPTIONAL
*"     VALUE(IV_SHIPPINGPOINT) TYPE  VSTEL OPTIONAL
*"     VALUE(IV_SHIPVIACODE) TYPE  CHAR21 OPTIONAL
*"     VALUE(IV_EVENTRAISEDDATETIME) TYPE  ABP_LASTCHANGE_TSTMPL
*"       OPTIONAL
*"----------------------------------------------------------------------
  DATA ls_str TYPE zvks_bgpf_test.

  ls_str = VALUE #(
    client              = sy-mandt
    customer            = iv_customer
    salesorganization   = iv_salesorganization
    distributionchannel = iv_distributionchannel
    division            = iv_division
    shippingpoint       = iv_shippingpoint
    shipviacode         = iv_shipviacode
    eventraiseddatetime = iv_eventraiseddatetime ).

  IF ls_str IS NOT INITIAL.
    MODIFY zvks_bgpf_test FROM ls_str.
  ENDIF.

ENDFUNCTION.
