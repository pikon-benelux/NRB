class ZCL_CA_EDOC_ADBS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EDOC_AIF .
protected section.
private section.

  class-data MV_EDOC_GUID type EDOC_GUID .
  class-data MV_MSGID type EDOC_INTERFACE_GUID .
ENDCLASS.



CLASS ZCL_CA_EDOC_ADBS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~EXPORT_VALUES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~EXPORT_VALUES.
    INCLUDE EDOC_AIF_PROXY_EXPORT_VALUES.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_EDOCUMENT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INTERFACE_GUID              TYPE        EDOC_INTERFACE_GUID
* | [<-->] CV_SOURCE_TYPE                 TYPE        EDOC_SOURCE_TYPE
* | [<-->] CV_SOURCE_KEY                  TYPE        EDOC_SOURCE_KEY
* | [<-->] CV_EDOC_GUID                   TYPE        EDOC_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_EDOCUMENT_DATA.
    INCLUDE EDOC_AIF_PROXY_GET_EDOCUMENT_D.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_EDOC_GUID
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CV_EDOC_GUID                   TYPE        EDOC_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_EDOC_GUID.
    INCLUDE EDOC_AIF_PROXY_GET_EDOC_GUID.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_INTERFACE_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CV_INTERFACE_ID                TYPE        EDOC_INTERFACE_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_INTERFACE_ID.
    INCLUDE EDOC_AIF_PROXY_GET_INTERFACEID.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_MSGID
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CV_MSGID                       TYPE        EDOC_INTERFACE_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_MSGID.
    INCLUDE EDOC_AIF_PROXY_GET_MSGID.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_PROCESS_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PROCESS_STEP                TYPE        EDOC_PROCESS_STEP
* | [--->] IV_DATA                        TYPE REF TO DATA
* | [<-->] CV_PROCESS_DATA                TYPE REF TO DATA
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_PROCESS_DATA.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~GET_PROCESS_STEP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_EDOCUMENT                   TYPE REF TO CL_EDOCUMENT
* | [<-->] CV_PROCESS_STEP                TYPE        EDOC_PROCESS_STEP
* | [!CX!] CX_EDOCUMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~GET_PROCESS_STEP.
    INCLUDE EDOC_AIF_PROXY_GET_PROCESS_ST.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CA_EDOC_ADBS->IF_EDOC_AIF~SET_EDOC_GUID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EDOC_GUID                   TYPE        EDOC_GUID
* | [--->] IV_MSGID                       TYPE        EDOC_INTERFACE_GUID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IF_EDOC_AIF~SET_EDOC_GUID.
    INCLUDE EDOC_AIF_PROXY_SET_EDOC_GUID.
  endmethod.
ENDCLASS.
