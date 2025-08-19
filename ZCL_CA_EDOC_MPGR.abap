class ZCL_CA_EDOC_MPGR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EDOC_MAP_GR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CA_EDOC_MPGR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MPGR->IF_EDOC_MAP_GR~DETERMINE_CLASSIF_DETAILS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SOURCE                      TYPE        EDOC_GR_MAPPING_SOURCE
* | [--->] IV_PROCESS                     TYPE        EDOC_PROCESS
* | [--->] IS_BSEG                        TYPE        BSEG
* | [--->] IV_COUNTRY_TYPE                TYPE        EDOC_GR_COUNTRY_TYPE
* | [<---] ES_CLASSIF_DATA                TYPE        TY_CLASSIF_DATA
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edoc_map_gr~determine_classif_details.

*******************************************************************************
** This sample code shows how to determine Income/Expense classification detail
** You can use custom logic to populate classification data in ES_CLASSIF_DATA.
*******************************************************************************
*
*    DATA: ls_edogrclasstypegl TYPE edogrclasstypegl.
*
*    CLEAR es_classif_data.
*
** Get Income/Expense classification data based on the GL account
*    cl_edoc_map_gr=>get_classification_db_data(
*       EXPORTING
*         iv_bukrs        = is_bseg-bukrs
*         iv_country_type = iv_country_type
*         iv_hkont        = is_bseg-hkont
*         iv_mwskz        = is_bseg-mwskz
*         iv_blart        = is_source-bkpf-blart
*       IMPORTING
*         es_classif_data = ls_edogrclasstypegl ).
*
*    IF ls_edogrclasstypegl IS NOT INITIAL.
*      es_classif_data-classification_type = ls_edogrclasstypegl-classifcation_type.
*      es_classif_data-classification_category = ls_edogrclasstypegl-classifcation_category.
*      es_classif_data-amount = is_bseg-dmbtr.
*
*    ELSE.
*      MESSAGE e000(edocument_type)
*         WITH 'Classification Type/Category not found for'
*              is_bseg-hkont
*         INTO cl_edocument=>gv_error_txt.
*      cl_edocument=>raise_edoc_exception( ).
*    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MPGR->IF_EDOC_MAP_GR~DETERMINE_INVOICE_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SOURCE                      TYPE        EDOC_GR_MAPPING_SOURCE
* | [--->] IT_BSEG                        TYPE        EDOC_BSEG_TAB
* | [--->] IV_SOURCE_TYPE                 TYPE        EDOC_SOURCE_TYPE
* | [--->] IV_EDOC_TYPE                   TYPE        EDOC_TYPE
* | [--->] IV_BLART                       TYPE        BLART
* | [--->] IV_PTC                         TYPE        EDOC_GR_PRNTSK
* | [--->] IV_COUNTRY_TYPE                TYPE        EDOC_GR_COUNTRY_TYPE
* | [<---] EV_INVTYPE                     TYPE        EDOC_GR_INVTYPE
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edoc_map_gr~determine_invoice_type.

******************************************************************************
* This sample code shows how to determine invoice type using custom logic.
* You can use custom logic to populate invoice type in EV_INVTYPE.
******************************************************************************

    DATA: lt_invtypeacc TYPE STANDARD TABLE OF edogrinvtypeacc,
          ls_invtypeacc TYPE edogrinvtypeacc,
          lt_invtypeptc TYPE STANDARD TABLE OF edogrinvtypeptc,
          ls_invtypeptc TYPE edogrinvtypeptc,
          lv_invtype    TYPE edoc_gr_invtype.

    CLEAR ev_invtype.

* Determine Invoice Type based on GL Account/PTC table entries
    IF iv_edoc_type NE cl_edocument_gr=>gc_edoc_type-invoice_cr_note.

      CASE iv_source_type.
** For SD invoice (customer invoice), First read PTC if not found, then read ACC
*        WHEN cl_edoc_source_sd_invoice=>gc_src_sd_invoice.
** Get Invoice Type from *PTC based on Print Task Code
*          cl_edoc_map_gr=>get_inv_type_for_ptc(
*            EXPORTING
*              iv_blart        = iv_blart
*              iv_ptc          = iv_ptc
*              iv_country_type = iv_country_type
*            IMPORTING
*              et_invtypeptc   = lt_invtypeptc ).
*
*          READ TABLE lt_invtypeptc INTO ls_invtypeptc INDEX 1.
*          IF sy-subrc IS INITIAL.
*            lv_invtype = ls_invtypeptc-invoice_type.
*          ENDIF.
*
** Get Invoice Type from *ACC table based on G/L Accounts
*          IF lv_invtype IS INITIAL.
*            cl_edoc_map_gr=>get_inv_type_for_gl_account(
*              EXPORTING
*                it_bseg         = it_bseg
*                iv_blart        = iv_blart
*                iv_country_type = iv_country_type
*                iv_source_type  = iv_source_type
*              IMPORTING
*                et_invtypeacc   = lt_invtypeacc ).
*
** Check if different items correspond to different Invoice Types
*            IF lines( lt_invtypeacc ) > 1.
*              LOOP AT lt_invtypeacc INTO ls_invtypeacc.
*                IF ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_1
*                  OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_2
*                  OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_3
*                  OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_4
*                  OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_6.
*                  lv_invtype = ls_invtypeacc-invoice_type.
*                  EXIT.
*                ENDIF.
*              ENDLOOP.
*
*            ELSE.
*              READ TABLE lt_invtypeacc INTO ls_invtypeacc INDEX 1.
*              IF sy-subrc IS INITIAL.
*                lv_invtype = ls_invtypeacc-invoice_type.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*
** For FI invoice (Vendor/Customer), first read ACC if not found then read PTC
        WHEN cl_edoc_source_fi_invoice=>gc_src_fi_invoice.
* Get Invoice Type from *ACC table based on G/L Accounts
          cl_edoc_map_gr=>get_inv_type_for_gl_account(
            EXPORTING
              it_bseg         = it_bseg
              iv_blart        = iv_blart
              iv_country_type = iv_country_type
              iv_source_type  = iv_source_type
            IMPORTING
              et_invtypeacc   = lt_invtypeacc ).

* Check if different items correspond to different Invoice Types
          IF lines( lt_invtypeacc ) > 1.
            LOOP AT lt_invtypeacc INTO ls_invtypeacc.
              IF ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_1
                OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_2
                OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_3
                OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_4
                OR ls_invtypeacc-invoice_type = cl_edocument_gr=>gc_constants-inv_type_1_6.
                lv_invtype = ls_invtypeacc-invoice_type.
                EXIT.
              ENDIF.
            ENDLOOP.

          ELSE.
            READ TABLE lt_invtypeacc INTO ls_invtypeacc INDEX 1.
            IF sy-subrc IS INITIAL.
              lv_invtype = ls_invtypeacc-invoice_type.
            ENDIF.
          ENDIF.

* Get Invoice Type from *PTC based on Print Task Code
          IF lv_invtype IS INITIAL.
            cl_edoc_map_gr=>get_inv_type_for_ptc(
              EXPORTING
                iv_blart        = iv_blart
                iv_ptc          = iv_ptc
                iv_country_type = iv_country_type
              IMPORTING
                et_invtypeptc   = lt_invtypeptc ).

            READ TABLE lt_invtypeptc INTO ls_invtypeptc INDEX 1.
            IF sy-subrc IS INITIAL.
              lv_invtype = ls_invtypeptc-invoice_type.
            ENDIF.
          ENDIF.

** For MM invoice (Vendor), read only ACC. There is no PTC for this
        WHEN cl_edoc_source_invoice_verif=>gc_src_inv_verif.
* Get Invoice Type from *ACC table based on G/L Accounts
          cl_edoc_map_gr=>get_inv_type_for_gl_account(
            EXPORTING
              it_bseg         = it_bseg
              iv_blart        = iv_blart
              iv_country_type = iv_country_type
              iv_source_type  = iv_source_type
            IMPORTING
              et_invtypeacc   = lt_invtypeacc ).

          READ TABLE lt_invtypeacc INTO ls_invtypeacc INDEX 1.
          IF sy-subrc IS INITIAL.
            lv_invtype = ls_invtypeacc-invoice_type.
          ENDIF.

      ENDCASE.

    ENDIF.

    IF lv_invtype IS NOT INITIAL.
      ev_invtype = lv_invtype.
    ELSE.
      MESSAGE e000(edocument_gr)
         WITH 'Invoice Type not found for'
              is_source-source_header-source_key
         INTO cl_edocument=>gv_error_txt.
      cl_edocument=>raise_edoc_exception( ).
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MPGR->IF_EDOC_MAP_GR~DETERMINE_VAT_CLASSIF_DETAIL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_SOURCE                      TYPE        EDOC_GR_MAPPING_SOURCE
* | [--->] IV_PROCESS                     TYPE        EDOC_PROCESS
* | [--->] IV_COUNTRY_TYPE                TYPE        EDOC_GR_COUNTRY_TYPE
* | [--->] IS_BSET                        TYPE        BSET
* | [<---] ES_CLASSIF_DATA                TYPE        TY_CLASSIF_DATA
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edoc_map_gr~determine_vat_classif_detail.

*******************************************************************************
** This sample code shows how to determine VAT classification detail
** You can use custom logic to populate classification data in ES_CLASSIF_DATA.
*******************************************************************************
*
*    DATA: ls_edogrclasstypegl TYPE edogrclasstypegl.
*
*    CLEAR es_classif_data.
*
** Get VAT classification data based on the GL account
*    cl_edoc_map_gr=>get_classification_db_data(
*       EXPORTING
*         iv_bukrs        = is_bset-bukrs
*         iv_country_type = iv_country_type
*         iv_hkont        = is_bset-hkont
*         iv_mwskz        = is_bset-mwskz
*         iv_blart        = is_source-bkpf-blart
*       IMPORTING
*         es_classif_data = ls_edogrclasstypegl ).
*
*    IF ls_edogrclasstypegl IS NOT INITIAL.
*      es_classif_data-classification_type = ls_edogrclasstypegl-classifcation_type.
*      es_classif_data-classification_category = ls_edogrclasstypegl-classifcation_category.
*
*    ELSE.
*      MESSAGE e000(edocument_type)
*         WITH 'VAT Classification Type/Category not found for'
*              is_bset-hkont
*         INTO cl_edocument=>gv_error_txt.
*      cl_edocument=>raise_edoc_exception( ).
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
