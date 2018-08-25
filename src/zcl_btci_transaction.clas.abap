class ZCL_BTCI_TRANSACTION definition
  public
  final
  create private

  global friends ZCL_BTCI .

public section.

  types TD_DISPLAY_MODE type CHAR01 .
  types TD_UPDATE_MODE type CHAR01 .
  types:
    ty_dynpros TYPE STANDARD TABLE OF REF TO zcl_btci_dynpro WITH DEFAULT KEY .

  data AUD_TCODE type TCODE read-only .
  data AUT_BDCDATA type WDKBDCDATA_TTY read-only .
  constants:
    BEGIN OF c_display,
        nothing     TYPE td_display_mode VALUE 'N' ##NO_TEXT,
        all_screens TYPE td_display_mode VALUE 'A' ##NO_TEXT,
        if_error    TYPE td_display_mode VALUE 'E' ##NO_TEXT,
      END OF c_display .
  constants:
    BEGIN OF c_update,
        asynchronous TYPE td_update_mode VALUE 'A' ##NO_TEXT,
        synchronous  TYPE td_update_mode VALUE 'S' ##NO_TEXT,
        local        TYPE td_update_mode VALUE 'L' ##NO_TEXT,
      END OF c_update .

  methods CONSTRUCTOR
    importing
      !IV_TCODE type TCODE .
  methods ADD_DYNPRO
    importing
      !DYNPRO type ref to ZCL_BTCI_DYNPRO
    returning
      value(FLUENT_TRANSACTION) type ref to ZCL_BTCI_TRANSACTION .
  methods ADD_DYNPROS
    importing
      !DYNPROS type TY_DYNPROS
    returning
      value(FLUENT_TRANSACTION) type ref to ZCL_BTCI_TRANSACTION .
  methods CALL_TRANSACTION
    importing
      value(IV_DISPLAY) type CTU_PARAMS-DISMODE default C_DISPLAY-NOTHING
      value(IV_UPDATE) type CTU_PARAMS-UPDMODE default C_UPDATE-ASYNCHRONOUS
      value(IS_PARAM) type CTU_PARAMS optional
    returning
      value(EO_RESULT) type ref to ZCL_BTCI_RESULT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTCI_TRANSACTION IMPLEMENTATION.


  method ADD_DYNPRO.

    APPEND LINES OF dynpro->aut_bdcdata TO aut_bdcdata.
    fluent_transaction = me.

  endmethod.


  method ADD_DYNPROS.

    LOOP AT dynpros INTO DATA(dynpro).
      APPEND LINES OF dynpro->aut_bdcdata TO aut_bdcdata.
    ENDLOOP.
    fluent_transaction = me.

  endmethod.


  method CALL_TRANSACTION.

    DATA: wlt_bdcmsgcoll TYPE ettcd_msg_tabtype.

    IF is_param-dismode IS INITIAL.
      is_param-dismode = iv_display.
    ENDIF.
    IF is_param-updmode IS INITIAL.
      is_param-updmode = iv_update.
    ENDIF.

    CALL TRANSACTION aud_tcode
          USING         aut_bdcdata
          OPTIONS FROM  is_param
          MESSAGES INTO wlt_bdcmsgcoll.

    CREATE OBJECT eo_result
      EXPORTING
        iv_subrc      = CONV #( sy-subrc ) ##OPERATOR " CONV allows copying SY-SUBRC before call, otherwise it's reset to zero
        it_bdcmsgcoll = wlt_bdcmsgcoll.


  endmethod.


  method CONSTRUCTOR.

    aud_tcode = iv_tcode.

  endmethod.
ENDCLASS.
