class ZCL_CA_EDOC_APGR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EDOC_ADAPTOR .
protected section.

  methods ADJUST_NONLIABLE_INVOICE
    importing
      !IV_EDOC_GUID type EDOC_GUID optional
      !IV_EDOC_TYPE type EDOC_TYPE optional
      !IV_INTERFACE_ID type EDOC_INTERFACE_ID optional
      !IO_SOURCE type ref to CL_EDOC_SOURCE optional
      !IS_ADDITIONAL_DATA type ANY optional
    changing
      !CS_OUTPUT_DATA type ANY .
  methods CHANGE_SD_TO_FI_DOC_NUMBER
    importing
      !IV_EDOC_GUID type EDOC_GUID optional
      !IV_EDOC_TYPE type EDOC_TYPE optional
      !IV_INTERFACE_ID type EDOC_INTERFACE_ID optional
      !IO_SOURCE type ref to CL_EDOC_SOURCE optional
      !IS_ADDITIONAL_DATA type ANY optional
    changing
      !CS_OUTPUT_DATA type ANY .
private section.
ENDCLASS.



CLASS ZCL_CA_EDOC_APGR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_CA_EDOC_APGR->ADJUST_NONLIABLE_INVOICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDOC_GUID                   TYPE        EDOC_GUID(optional)
* | [--->] IV_EDOC_TYPE                   TYPE        EDOC_TYPE(optional)
* | [--->] IV_INTERFACE_ID                TYPE        EDOC_INTERFACE_ID(optional)
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE(optional)
* | [--->] IS_ADDITIONAL_DATA             TYPE        ANY(optional)
* | [<-->] CS_OUTPUT_DATA                 TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD adjust_nonliable_invoice.
    DATA: ls_invoice_verif TYPE edoc_src_data_invoice_verif,
          ls_fi_invoice    TYPE edoc_src_data_fi_invoice.

    FIELD-SYMBOLS: <fs_invoice> TYPE edo_gr_aade_book_invoice_t_tab.

    CHECK iv_edoc_type = 'GR_INVI_NL'.

    CASE io_source->mv_source_type.
      WHEN cl_edoc_source_invoice_verif=>gc_src_inv_verif.
        io_source->get_data( IMPORTING es_data = ls_invoice_verif ).
        SELECT SINGLE stkzn FROM lfa1 WHERE lifnr = @ls_invoice_verif-document_header-lifnr INTO @DATA(lv_stkzn).
        IF lv_stkzn = abap_true.
          ASSIGN COMPONENT 'INVOICE' OF STRUCTURE cs_output_data TO <fs_invoice>.
          IF <fs_invoice> IS ASSIGNED.
            READ TABLE <fs_invoice> ASSIGNING FIELD-SYMBOL(<fs_xml>) INDEX 1.
            IF sy-subrc = 0.
              <fs_xml>-invoice_header-invoice_type = '14.30'.
            ENDIF.
          ENDIF.
        ENDIF.
      WHEN cl_edoc_source_fi_invoice=>gc_src_fi_invoice.
        io_source->get_data( IMPORTING es_data = ls_fi_invoice ).
        SELECT SINGLE lifnr FROM @ls_fi_invoice-document_item AS fi WHERE lifnr IS NOT INITIAL INTO @DATA(lv_lifnr).
        SELECT SINGLE stkzn FROM lfa1 WHERE lifnr = @lv_lifnr INTO @lv_stkzn.
        IF lv_stkzn = abap_true.
          ASSIGN COMPONENT 'INVOICE' OF STRUCTURE cs_output_data TO <fs_invoice>.
          IF <fs_invoice> IS ASSIGNED.
            READ TABLE <fs_invoice> ASSIGNING <fs_xml> INDEX 1.
            IF sy-subrc = 0.
              <fs_xml>-invoice_header-invoice_type = '14.30'.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_CA_EDOC_APGR->CHANGE_SD_TO_FI_DOC_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDOC_GUID                   TYPE        EDOC_GUID(optional)
* | [--->] IV_EDOC_TYPE                   TYPE        EDOC_TYPE(optional)
* | [--->] IV_INTERFACE_ID                TYPE        EDOC_INTERFACE_ID(optional)
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE(optional)
* | [--->] IS_ADDITIONAL_DATA             TYPE        ANY(optional)
* | [<-->] CS_OUTPUT_DATA                 TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD change_sd_to_fi_doc_number.
    DATA: ls_sd_invoice    TYPE edoc_src_data_sd_invoice,
          lt_acc_documents TYPE STANDARD TABLE OF acc_doc,
          ls_acc_document  TYPE acc_doc.

    FIELD-SYMBOLS: <fs_invoice>        TYPE edo_gr_aade_book_invoice_t_tab,
                   <fs_invoice_header> TYPE edo_gr_invoice_header_type.

    CASE io_source->mv_source_type.
      WHEN cl_edoc_source_sd_invoice=>gc_src_sd_invoice.
        io_source->get_data( IMPORTING es_data = ls_sd_invoice ).

        ASSIGN COMPONENT 'INVOICE' OF STRUCTURE cs_output_data TO <fs_invoice>.
        IF <fs_invoice> IS ASSIGNED.
          READ TABLE <fs_invoice> ASSIGNING FIELD-SYMBOL(<fs_invoice_line_item>) INDEX 1.
          IF sy-subrc = 0.
            ASSIGN COMPONENT 'INVOICE_HEADER' OF STRUCTURE <fs_invoice_line_item> TO <fs_invoice_header>.
            IF <fs_invoice_header> IS ASSIGNED.
              CALL FUNCTION 'AC_DOCUMENT_RECORD'
                EXPORTING
                  i_awtyp     = 'VBRK'
                  i_awref     = ls_sd_invoice-document_header-vbeln
                  x_dialog    = ''
                TABLES
                  t_documents = lt_acc_documents.
              IF sy-subrc = 0.
                READ TABLE lt_acc_documents INTO ls_acc_document WITH KEY awtyp = 'BKPF'.
                IF sy-subrc = 0.
                  <fs_invoice_header>-aa = ls_acc_document-docnr.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~CHANGE_EDOCUMENT_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE
* | [<-->] CV_EDOC_TYPE                   TYPE        EDOC_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_ADAPTOR~CHANGE_EDOCUMENT_TYPE.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~GET_VARIABLE_KEY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE
* | [--->] IV_EDOC_TYPE                   TYPE        EDOC_TYPE
* | [<-->] CV_VARKEY                      TYPE        EDOC_VARKEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_ADAPTOR~GET_VARIABLE_KEY.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~IS_RELEVANT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE
* | [<-->] CX_RELEVANT                    TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_ADAPTOR~IS_RELEVANT.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~SET_FIX_VALUES
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_FIX_VALUES                  TYPE        EDOC_FIX_VALUE_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_ADAPTOR~SET_FIX_VALUES.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~SET_OUTPUT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDOC_GUID                   TYPE        EDOC_GUID(optional)
* | [--->] IV_EDOC_TYPE                   TYPE        EDOC_TYPE(optional)
* | [--->] IV_INTERFACE_ID                TYPE        EDOC_INTERFACE_ID(optional)
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE(optional)
* | [--->] IS_ADDITIONAL_INFO             TYPE        ANY(optional)
* | [<-->] CS_OUTPUT_DATA                 TYPE        ANY
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edoc_adaptor~set_output_data.

    CALL METHOD me->change_sd_to_fi_doc_number
      EXPORTING
        iv_edoc_guid       = iv_edoc_guid
        iv_edoc_type       = iv_edoc_type
        iv_interface_id    = iv_interface_id
        io_source          = io_source
        is_additional_data = is_additional_info
      CHANGING
        cs_output_data     = cs_output_data.

    CALL METHOD me->adjust_nonliable_invoice
      EXPORTING
        iv_edoc_guid       = iv_edoc_guid
        iv_edoc_type       = iv_edoc_type
        iv_interface_id    = iv_interface_id
        io_source          = io_source
        is_additional_data = is_additional_info
      CHANGING
        cs_output_data     = cs_output_data.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_APGR->IF_EDOC_ADAPTOR~SET_VALUE_MAPPING
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_VALUE_MAPPING               TYPE        EDOC_VALUE_MAPPING_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_ADAPTOR~SET_VALUE_MAPPING.
  endmethod.
ENDCLASS.
