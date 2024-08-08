CLASS lsc_zd_r_customeraimstp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zd_r_customeraimstp IMPLEMENTATION.

  METHOD save_modified.

    DATA lv_tmstmpl TYPE timestampl.

    LOOP AT update-customershippingpoint ASSIGNING FIELD-SYMBOL(<lfs_customershippingpoint>).

      IF <lfs_customershippingpoint>-%control-shipviacode EQ if_abap_behv=>mk-on.

        "BREAK shavik10.

        "ZVKS_BGPF_SHIP_VIA_CHANGED
        CALL FUNCTION 'ZVKS_BGPF_SHIP_VIA_UPDATE' IN BACKGROUND TASK
          EXPORTING
            iv_customer            = <lfs_customershippingpoint>-customer
            iv_salesorganization   = <lfs_customershippingpoint>-salesorganization
            iv_distributionchannel = <lfs_customershippingpoint>-distributionchannel
            iv_division            = <lfs_customershippingpoint>-division
            iv_shippingpoint       = <lfs_customershippingpoint>-shippingpoint
            iv_shipviacode         = <lfs_customershippingpoint>-shipviacode
            iv_eventraiseddatetime = <lfs_customershippingpoint>-locallastchangedat.

        "Throw Dump!
*        CALL FUNCTION 'ZVKS_BGPF_SHIP_VIA_UPDATE' IN UPDATE TASK.

        IF 1 = 2.

          DATA:
            lv_jobname  TYPE cl_apj_rt_api=>ty_jobname,
            lv_jobcount TYPE cl_apj_rt_api=>ty_jobcount.

          TRY.
              cl_apj_rt_api=>schedule_job(
                EXPORTING
                  iv_job_template_name   = |ZD_R_CUSTOMERAOMSTP_AJ|
                  iv_job_text            = |Manage Customer AIMS|
                  is_start_info          = VALUE #( start_immediately = abap_true )
                  "is_end_info            =
                  "is_scheduling_info     =
                  "it_job_parameter_value =
                IMPORTING
                  ev_jobname             = lv_jobname
                  ev_jobcount            = lv_jobcount
               ).

            CATCH cx_apj_rt INTO data(lo_apj_rt).
              data(lv_msg) = |{ lo_apj_rt->get_text( ) }|.
              "handle exception
          ENDTRY.
*         CATCH cx_apj_rt.

        ENDIF.

*        RAISE ENTITY EVENT zd_r_customeraimstp~shipviachanged
*        FROM VALUE #( ( customer            = <lfs_customershippingpoint>-customer
*                        salesorganization   = <lfs_customershippingpoint>-salesorganization
*                        distributionchannel = <lfs_customershippingpoint>-distributionchannel
*                        division            = <lfs_customershippingpoint>-division
*                        %param = VALUE #( shippingpoint       = <lfs_customershippingpoint>-shippingpoint
*                                          shipviacode         = <lfs_customershippingpoint>-shipviacode
*                                          eventraiseddatetime = <lfs_customershippingpoint>-locallastchangedat )
*                     ) ).


*        DATA lr_event_parameters TYPE REF TO if_swf_ifs_parameter_container.
*        TRY.
*            CALL METHOD CL_SWF_EVT_EVENT=>get_event_container
*              EXPORTING
*                im_objcateg  = cl_swf_evt_event=>mc_objcateg_cl                   "CL
*                im_objtype   = if_mm_pur_workflow_c=>gc_cl_mm_pur_wf_object_po    "CL_MM_PUR_WF_OBJECT_PO
*                im_event     = if_mm_pur_workflow_c=>gc_workitem_released_po      "PURCHASEORDERAPPROVED
*              RECEIVING
*                re_reference = lr_event_parameters.
*
*            CALL METHOD lr_event_parameters->set
*              EXPORTING
*                name  = if_mm_pur_workflow_c=>gc_purchaseorder
*                value = iv_po_number.
*
*            CALL METHOD cl_swf_evt_event=>RAISE_IN_UPDATE_TASK
*              EXPORTING
*                im_objcateg        = cl_swf_evt_event=>mc_objcateg_cl
*                im_objtype         = if_mm_pur_workflow_c=>gc_cl_mm_pur_wf_object_po
*                im_event           = if_mm_pur_workflow_c=>gc_workitem_released_po
*                im_objkey          = iv_po_number
*                im_event_container = lr_event_parameters.
*
*          CATCH cx_swf_evt_invalid_objtype cx_swf_evt_invalid_event.
*          CATCH cx_swf_cnt_container.
*        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_customeraims DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR customeraims RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR customeraims RESULT result.
    METHODS pickconsolidatebycustomerpo FOR VALIDATE ON SAVE
      IMPORTING keys FOR customeraims~pickconsolidatebycustomerpo.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE customeraims.
*    METHODS precheck_create FOR PRECHECK
*      IMPORTING entities FOR CREATE customeraims.
*    METHODS precheck_update FOR PRECHECK
*      IMPORTING entities FOR UPDATE customeraims.
*    METHODS precheck_cba_customershippoint FOR PRECHECK
*      IMPORTING entities FOR CREATE customeraims\_customershippoint.

ENDCLASS.

CLASS lhc_customeraims IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    "Authorization Object
    "DATA(lv_flag_changes_allowed) = abap_true.
    IF cl_abap_context_info=>get_user_technical_name( ) EQ 'TEST_IT1' OR
       cl_abap_context_info=>get_user_technical_name( ) EQ 'SHAVIK10'.
      DATA(lv_feature_control) = if_abap_behv=>fc-f-unrestricted.
    ELSE.
      lv_feature_control = if_abap_behv=>fc-f-read_only.
    ENDIF.

    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
      ENTITY customeraims
      FIELDS ( barcodeindicator
               distributioncenterid
               pickcustomerconsolidatation
               pickconsolidatationbypo
               pickconsolidatebyattentionline
               barcodedpalletcontentsheet
               shipviacode
               frozenshipviacode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customeraims)
      FAILED failed.

    result = VALUE #( FOR <lfs_customeraims> IN lt_customeraims
                      (
                        %tky = <lfs_customeraims>-%tky
                        %field-barcodeindicator               = lv_feature_control
                        %field-distributioncenterid           = lv_feature_control
                        %field-pickcustomerconsolidatation    = lv_feature_control
                        %field-pickconsolidatationbypo        = lv_feature_control
                        %field-pickconsolidatebyattentionline = lv_feature_control
                        %field-barcodedpalletcontentsheet     = lv_feature_control
                        %field-shipviacode                    = lv_feature_control
                        %field-frozenshipviacode              = lv_feature_control
                       ) ).

  ENDMETHOD.

  METHOD pickconsolidatebycustomerpo.

    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
      ENTITY customeraims
      FIELDS ( pickcustomerconsolidatation
               pickconsolidatationbypo )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customeraims).

    LOOP AT lt_customeraims INTO DATA(ls_customeraims).

      IF ls_customeraims-pickcustomerconsolidatation EQ '0' AND
         ls_customeraims-pickconsolidatationbypo EQ '1'.

        APPEND VALUE #( %tky = ls_customeraims-%tky
                        "%state_area = 'TEST'
                      )
        TO failed-customeraims.

        APPEND VALUE #( %tky = ls_customeraims-%tky
                        "%state_area = 'TEST'
                        %msg = new_message(
                                 id       = 'ZOTC_MSG'
                                 number   = 002
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = 'Pick Consolidate by Customer PO'
                                 v2       = 'Pick Customer Consolidation' )
                        "Fields to Tag
                        %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
                        %element-pickconsolidatationbypo     = if_abap_behv=>mk-on )
        TO reported-customeraims.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*  METHOD precheck_create.

**      READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
**      ENTITY CustomerAIMS
**      FIELDS ( pickcustomerconsolidatation
**               pickconsolidatationbypo )
**      WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_customeraims).
**/n
**    LOOP AT lt_customeraims INTO DATA(ls_customeraims).
**
**      IF ls_customeraims-pickcustomerconsolidatation EQ '0' AND
**         ls_customeraims-pickconsolidatationbypo EQ '1'.
**
**        APPEND VALUE #( %tky = ls_customeraims-%tky ) TO failed-customeraims.
**
**        APPEND VALUE #( %tky = ls_customeraims-%tky
**                        %msg = new_message(
**                                 id       = 'ZOTC_MSG'
**                                 number   = 002
**                                 severity = if_abap_behv_message=>severity-error
**                                 v1       = 'Pick Consolidation by PO'
**                                 v2       = 'Pick Customer Consolidation' )
**                        "Fields to Tag
**                        %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
**                        %element-pickconsolidatationbypo     = if_abap_behv=>mk-on ) TO reported-customeraims.
**
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
*
**    READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
**      ENTITY customeraims
**      FIELDS ( pickcustomerconsolidatation
**               pickconsolidatationbypo )
**      WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_customeraims).
**
*
*      IF <lfs_entity>-%control-pickcustomerconsolidatation EQ '0' AND
*         <lfs_entity>-%control-pickconsolidatationbypo EQ '1'.
*
*        APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-customeraims.
*
*        APPEND VALUE #( %tky = <lfs_entity>-%tky
*                        %msg = new_message(
*                                 id       = 'ZOTC_MSG'
*                                 number   = 002
*                                 severity = if_abap_behv_message=>severity-error
*                                 v1       = 'Pick Consolidation by PO'
*                                 v2       = 'Pick Customer Consolidation' )
*                        "Fields to Tag
*                        %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
*                        %element-pickconsolidatationbypo     = if_abap_behv=>mk-on ) TO reported-customeraims.
*
*      ENDIF.
*
*    ENDLOOP.

*  ENDMETHOD.

*  METHOD precheck_update.

*      READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
*      ENTITY CustomerAIMS
*      FIELDS ( pickcustomerconsolidatation
*               pickconsolidatationbypo )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_customeraims).
*
*    LOOP AT lt_customeraims INTO DATA(ls_customeraims).
*
*      IF ls_customeraims-pickcustomerconsolidatation EQ '0' AND
*         ls_customeraims-pickconsolidatationbypo EQ '1'.
*
*        APPEND VALUE #( %tky = ls_customeraims-%tky ) TO failed-customeraims.
*
*        APPEND VALUE #( %tky = ls_customeraims-%tky
*                        %msg = new_message(
*                                 id       = 'ZOTC_MSG'
*                                 number   = 002
*                                 severity = if_abap_behv_message=>severity-error
*                                 v1       = 'Pick Consolidation by PO'
*                                 v2       = 'Pick Customer Consolidation' )
*                        "Fields to Tag
*                        %element-pickcustomerconsolidatation = if_abap_behv=>mk-on
*                        %element-pickconsolidatationbypo     = if_abap_behv=>mk-on ) TO reported-customeraims.
*
*        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
*          ENTITY customeraims
*          FIELDS ( pickcustomerconsolidatation
*                   pickconsolidatationbypo )
*          WITH VALUE #( ( %key = <lfs_entity>-%key ) )
*          RESULT DATA(lt_customeraims).
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
*
*
*      IF <lfs_entity>-%control-pickcustomerconsolidatation EQ if_abap_behv=>mk-on.
*
*        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
*          ENTITY customeraims
*          ALL FIELDS
*          WITH VALUE #( ( %is_draft = <lfs_entity>-%is_draft
*                          %key = <lfs_entity>-%key ) )
*          RESULT DATA(lt_customeraims_draft).
*
*        LOOP AT lt_customeraims_draft ASSIGNING FIELD-SYMBOL(<lfs_customeraims_draft>).
*
*          IF <lfs_entity>-pickcustomerconsolidatation EQ '0' AND
*             <lfs_customeraims_draft>-pickconsolidatationbypo EQ '1'.
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
*
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
*
*    ENDLOOP.

*  ENDMETHOD.

*  METHOD precheck_cba_customershippoint.
*  ENDMETHOD.
*
  METHOD precheck_update.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).

      IF <lfs_entity>-%control-pickcustomerconsolidatation EQ if_abap_behv=>mk-on OR
         <lfs_entity>-%control-pickconsolidatationbypo EQ if_abap_behv=>mk-on.

        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
          ENTITY customeraims
          ALL FIELDS
          WITH VALUE #( ( %key = <lfs_entity>-%key ) )
          RESULT DATA(lt_customeraims_a)
          FAILED failed
          REPORTED reported.

        READ ENTITIES OF zd_r_customeraimstp IN LOCAL MODE
          ENTITY customeraims
          ALL FIELDS
          WITH VALUE #( ( %is_draft = <lfs_entity>-%is_draft
                          %key = <lfs_entity>-%key ) )
          RESULT DATA(lt_customeraims_d).

        IF line_exists( lt_customeraims_a[ 1 ] ).
          DATA(ls_customeraims_a) = lt_customeraims_a[ 1 ].
        ENDIF.

        IF line_exists( lt_customeraims_d[ 1 ] ).
          DATA(ls_customeraims_d) = lt_customeraims_d[ 1 ].
        ENDIF.

        IF <lfs_entity>-pickcustomerconsolidatation EQ '0'.

          IF <lfs_entity>-pickconsolidatationbypo IS NOT INITIAL.             "If, screen value is changed for other field

            IF <lfs_entity>-pickconsolidatationbypo EQ '1'.
              DATA(lv_error_flag) = abap_true.                                "If, other field is 1 then Error!
            ENDIF.

          ELSE. "Screen value is NOT yet changed, compare with draft data

            IF ls_customeraims_d-pickconsolidatationbypo EQ '1'.
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

              IF ls_customeraims_d-pickcustomerconsolidatation EQ '0'.     "If, other field is 0 then Error!
                lv_error_flag = abap_true.
              ENDIF.
            ENDIF.
          ENDIF.

        ENDIF.

        IF lv_error_flag EQ abap_true.

          APPEND VALUE #( %tky = <lfs_entity>-%tky ) TO failed-customeraims.

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
         TO reported-customeraims.
        ENDIF.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
