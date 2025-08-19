class ZCL_CA_EDOC_MCGR definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EDOCUMENT_GR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CA_EDOC_MCGR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MCGR->IF_EDOCUMENT_GR~GET_LEGAL_DOC_NUMBER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE
* | [<---] ES_LEGAL_DATA                  TYPE        EDOC_GR_LEGAL_DATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edocument_gr~get_legal_doc_number.
    DATA: ls_fi_invoice    TYPE edoc_src_data_fi_invoice,
          ls_sd_invoice    TYPE edoc_src_data_sd_invoice,
          ls_mm_invoice    TYPE edoc_src_data_invoice_verif,
          ls_src_data_file TYPE edoc_src_data_file.

    FIELD-SYMBOLS: <ls_source_data> TYPE any.

    CASE io_source->mv_source_type.
      WHEN 'FI_INVOICE'.
        ASSIGN ls_fi_invoice TO <ls_source_data>.
*       get data of source document
        io_source->get_data( IMPORTING es_data = <ls_source_data> ).
        es_legal_data-legaldoc = ls_fi_invoice-document_item[ 1 ]-sgtxt.
        es_legal_data-series = '0'.
*      WHEN 'SD_INVOICE'.
*        ASSIGN ls_sd_invoice TO <ls_source_data>.
**       get data of source document
*        io_source->get_data( IMPORTING es_data = <ls_source_data> ).
*        es_legal_data-legaldoc = ls_sd_invoice-document_header-xblnr.
      WHEN 'INVOICE_VERIF'.
        ASSIGN ls_mm_invoice TO <ls_source_data>.
*       get data of source document
        io_source->get_data( IMPORTING es_data = <ls_source_data> ).
        es_legal_data-legaldoc = ls_mm_invoice-document_header-sgtxt.
        es_legal_data-series = '0'.
******* implement your business logic here to get value from the source data OR ANY CUSTOMER TABLE in your SYSTEM
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MCGR->IF_EDOCUMENT_GR~MATCH_WITH_MYDATA_DOCUMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_SOURCE                      TYPE REF TO CL_EDOC_SOURCE
* | [--->] IV_COMPANY_CODE                TYPE        BUKRS
* | [--->] IV_DOCUMENT_NUMBER             TYPE        BELNR_D
* | [--->] IV_DOCUMENT_YEAR               TYPE        GJAHR
* | [--->] IV_LEGALDOC                    TYPE        XBLNR
* | [--->] IV_CUSTOMER_VAT_ID             TYPE        EDOC_GR_VAT_ID
* | [--->] IV_VENDOR_VAT_ID               TYPE        EDOC_GR_VAT_ID
* | [--->] IV_INVOICE_DATE                TYPE        BLDAT
* | [<-->] CV_MATCHED_EDOCUMENT_ID        TYPE        EDOC_GUID
* | [<-->] CS_EDOGRINV                    TYPE        EDOGRINV(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edocument_gr~match_with_mydata_document.
    DATA: lv_index        TYPE i,
          lv_rest         TYPE i,
          lv_length       TYPE i,
          lv_position     TYPE i,
          lv_invoice_date TYPE d,
          lv_legaldoc     TYPE string,
          lv_series       TYPE string.

    lv_length = strlen( iv_legaldoc ).

    WHILE lv_index < lv_length.
      DATA(lv_char) = iv_legaldoc+lv_index(1).
      IF lv_char = '-'.
        lv_position = lv_index.
      ENDIF.
      ADD 1 TO lv_index.
    ENDWHILE.
    lv_series = iv_legaldoc+0(lv_position).
    lv_position += 1.
    lv_rest = lv_length - lv_position.
    lv_legaldoc = iv_legaldoc+lv_position(lv_rest).

    SELECT SINGLE edogrinv~*
      FROM edogrinv
      INNER JOIN edocument ON edogrinv~edoc_guid EQ edocument~edoc_guid
      INTO CORRESPONDING FIELDS OF @cs_edogrinv
      WHERE edogrinv~series = @lv_series
        AND edogrinv~numbr = @lv_legaldoc
        AND edogrinv~invoice_date = @iv_invoice_date
        AND ( edocument~proc_status = 'CREA' OR  edocument~proc_status = 'MATCH_ERR' )
        AND edocument~edoc_type = 'GR_INV_MD'.
    IF cs_edogrinv IS NOT INITIAL.
      cv_matched_edocument_id = cs_edogrinv-edoc_guid.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_MCGR->IF_EDOCUMENT_GR~MATCH_WITH_VENDOR_INVOICE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SERIES                      TYPE        EDOC_GR_SERIES
* | [--->] IV_AA                          TYPE        EDOC_GR_NUMBER
* | [--->] IV_CUSTOMER_VAT_ID             TYPE        EDOC_GR_VAT_ID
* | [--->] IV_VENDOR_VAT_ID               TYPE        EDOC_GR_VAT_ID
* | [--->] IV_INVOICE_DATE                TYPE        BLDAT
* | [--->] IV_TOTAL_GROSS_AMOUNT          TYPE        EDOC_GR_AMOUNT
* | [--->] IV_TOTAL_PAYABLE_AMOUNT        TYPE        EDOC_GR_AMOUNT
* | [<-->] CV_MATCHED_EDOCUMENT_ID        TYPE        EDOC_GUID
* | [<-->] CV_MULTIPLE_MATCH_ERROR        TYPE        FLAG
* | [<-->] CT_MULTIPLE_EDOCS              TYPE        TY_GUID_EDOC_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_edocument_gr~match_with_vendor_invoice.

  ENDMETHOD.
ENDCLASS.
