CLASS lhc_customershippingpoint DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setdefaultvalues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR customershippingpoint~setdefaultvalues.
    METHODS pickconsolidatebycustomerpo FOR VALIDATE ON SAVE
      IMPORTING keys FOR customershippingpoint~pickconsolidatebycustomerpo.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE customershippingpoint.

ENDCLASS.

CLASS lhc_customershippingpoint IMPLEMENTATION.

  METHOD setdefaultvalues.

    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
        ENTITY customershippingpoint
        BY \_customeraims
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_customeraims).

    LOOP AT lt_customeraims INTO DATA(ls_customeraims).

      " Modify in local mode: BO-related updates that are not relevant for authorization checks
      MODIFY ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
      ENTITY customershippingpoint
      UPDATE FIELDS ( pickcustomerconsolidatation
                      pickconsolidatationbypo
                      pickconsolidatebyattentionline
                      barcodedpalletcontentsheet
                      shipviacode
                      frozenshipviacode )
      WITH VALUE #( FOR key IN keys
                    ( %tky                           = key-%tky
                      pickcustomerconsolidatation    = ls_customeraims-pickcustomerconsolidatation
                      pickconsolidatationbypo        = ls_customeraims-pickconsolidatationbypo
                      pickconsolidatebyattentionline = ls_customeraims-pickconsolidatebyattentionline
                      barcodedpalletcontentsheet     = ls_customeraims-barcodedpalletcontentsheet
                      shipviacode                    = ls_customeraims-shipviacode
                      frozenshipviacode              = ls_customeraims-frozenshipviacode

                      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD pickconsolidatebycustomerpo.

    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
      ENTITY customershippingpoint
      FIELDS ( pickcustomerconsolidatation
               pickconsolidatationbypo )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customershippingpoint).

    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
      ENTITY customershippingpoint
          BY \_customeraims
      FROM CORRESPONDING #( lt_customershippingpoint )
      LINK DATA(lt_to_customeraims).

    LOOP AT lt_customershippingpoint ASSIGNING FIELD-SYMBOL(<lfs_customershippingpoint>).

      IF <lfs_customershippingpoint>-pickcustomerconsolidatation EQ '0' AND
         <lfs_customershippingpoint>-pickconsolidatationbypo EQ '1'.

        APPEND VALUE #( %tky = <lfs_customershippingpoint>-%tky )
        TO failed-customershippingpoint.

        APPEND VALUE #( %tky = <lfs_customershippingpoint>-%tky
                        %msg = new_message(
                                 id       = 'ZOTC_MSG'
                                 number   = 002
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Pick Consolidate by Customer PO'
                                 v2       = 'Pick Customer Consolidation' )
                        %path             = VALUE #( customeraims-%tky = lt_to_customeraims[ KEY id source-%tky = <lfs_customershippingpoint>-%tky ]-target-%tky )
                        %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
                        %element-pickconsolidatationbypo     = if_abap_behv=>mk-on )
        TO reported-customershippingpoint.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD precheck_update.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).

      IF <lfs_entity>-%control-pickcustomerconsolidatation EQ if_abap_behv=>mk-on OR
         <lfs_entity>-%control-pickconsolidatationbypo EQ if_abap_behv=>mk-on.

*        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
*          ENTITY customershippingpoint
*          ALL FIELDS
*          WITH VALUE #( ( %key = <lfs_entity>-%key ) )
*          RESULT DATA(lt_customershippingpoint_a)
*          FAILED failed
*          REPORTED reported.

        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
          ENTITY customershippingpoint
          ALL FIELDS
          WITH VALUE #( ( %is_draft = <lfs_entity>-%is_draft
                          %key = <lfs_entity>-%key ) )
          RESULT DATA(lt_customershippingpoint_d).

*        IF line_exists( lt_customershippingpoint_a[ 1 ] ).
*          DATA(ls_customershippingpoint_a) = lt_customershippingpoint_a[ 1 ].
*        ENDIF.

        IF line_exists( lt_customershippingpoint_d[ 1 ] ).
          DATA(ls_customershippingpoint_d) = lt_customershippingpoint_d[ 1 ].
        ENDIF.

        IF <lfs_entity>-pickcustomerconsolidatation EQ '0'.

          IF <lfs_entity>-pickconsolidatationbypo IS NOT INITIAL.             "If, screen value is changed for other field

            IF <lfs_entity>-pickconsolidatationbypo EQ '1'.
              DATA(lv_error_flag) = abap_true.                                "If, other field is 1 then Error!
            ENDIF.

          ELSE. "Screen value is NOT yet changed, compare with draft data

            IF ls_customershippingpoint_d-pickconsolidatationbypo EQ '1'.
              lv_error_flag = abap_true.                                      "If, other field is 1 then Error!
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_error_flag EQ abap_false.

          IF <lfs_entity>-pickconsolidatationbypo EQ '1'.

            IF <lfs_entity>-pickcustomerconsolidatation IS NOT INITIAL.         "If, screen value is changed for other field

              IF <lfs_entity>-pickcustomerconsolidatation EQ '0'.                   "If, other field is 0 then Error!
                lv_error_flag = abap_true.
              ENDIF.

            ELSE. "Screen value is NOT yet changed, compare with draft data

              IF ls_customershippingpoint_d-pickcustomerconsolidatation EQ '0'.     "If, other field is 0 then Error!
                lv_error_flag = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.

        ENDIF.

        IF lv_error_flag EQ abap_true.

          APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-customershippingpoint.

          APPEND VALUE #( %tky = <lfs_entity>-%tky
                          %msg = new_message(
                                   id       = 'ZOTC_MSG'
                                   number   = 002
                                   severity = if_abap_behv_message=>severity-error
                                   v1       = 'Pick Consolidation by PO'
                                   v2       = 'Pick Customer Consolidation' )
                          "Fields to Tag
                          %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
                          %element-pickconsolidatationbypo = if_abap_behv=>mk-on )
         TO reported-customershippingpoint.
        ENDIF.
      ENDIF.

*      IF <lfs_entity>-%control-pickconsolidatebyattentionline EQ if_abap_behv=>mk-on.
*
*        IF <lfs_entity>-pickconsolidatebyattentionline EQ '0' OR
*           <lfs_entity>-pickconsolidatebyattentionline EQ '1'.
*          "All Good.
*        ELSE.
*          APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-customershippingpoint.
*
*          APPEND VALUE #( %tky = <lfs_entity>-%tky
*                          %msg = new_message_with_text(
*                                   severity = if_abap_behv_message=>severity-error
*                                   text     = 'Allowed values are 0 and 1' )
*                          "Fields to Tag
*                          %element-pickconsolidatebyattentionline = if_abap_behv=>mk-on )
*         TO reported-customershippingpoint.
*
*        ENDIF.
*      ENDIF.

    ENDLOOP.

*    ENDIF.

*      IF <lfs_entity>-%control-pickconsolidatationbypo EQ if_abap_behv=>mk-on.
*
*        IF lt_customeraims_draft IS INITIAL.
*
*          READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
*            ENTITY customeraims
*            ALL FIELDS
*            WITH VALUE #( ( %is_draft = <lfs_entity>-%is_draft
*                            %key = <lfs_entity>-%key ) )
*            RESULT lt_customeraims_draft.
*        ENDIF.
*
*        LOOP AT lt_customeraims_draft ASSIGNING <lfs_customeraims_draft>.
*
*          IF <lfs_customeraims_draft>-pickcustomerconsolidatation EQ '0' AND
*             <lfs_entity>-pickconsolidatationbypo EQ '1'.
*
*            APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-customeraims.
*
*            APPEND VALUE #( %tky = <lfs_entity>-%tky
*                            %msg = new_message(
*                                     id       = 'ZOTC_MSG'
*                                     number   = 002
*                                     severity = if_abap_behv_message=>severity-error
*                                     v1       = 'Pick Consolidation by PO'
*                                     v2       = 'Pick Customer Consolidation' )
*                            "Fields to Tag
*                            %element-pickcustomerconsolidatation = if_abap_behv=>mk-on ) TO reported-customeraims.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.

*  ENDLOOP.
  ENDMETHOD.

ENDCLASS.
