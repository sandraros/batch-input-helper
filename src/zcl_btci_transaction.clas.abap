CLASS zcl_btci_transaction DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE

  GLOBAL FRIENDS zcl_btci .

  PUBLIC SECTION.

    TYPES td_display_mode TYPE char01 .
    TYPES td_update_mode TYPE char01 .
    TYPES:
      ty_dynpros TYPE STANDARD TABLE OF REF TO zcl_btci_dynpro WITH DEFAULT KEY .

    DATA aud_tcode TYPE tcode READ-ONLY .
    DATA aut_bdcdata TYPE wdkbdcdata_tty READ-ONLY .
    CONSTANTS:
      "! Runs the batch input with SY-BATCH unchanged (' ' if interactive, 'X' if background)
      BEGIN OF c_display,
        "! Screens are not displayed at all
        nothing     TYPE td_display_mode VALUE 'N' ##NO_TEXT,
        "! Every screen is displayed, the user must press Enter to reach next screen
        all_screens TYPE td_display_mode VALUE 'A' ##NO_TEXT,
        "! Screens are displayed only from the screen where an error occurs, otherwise screens are not displayed
        if_error    TYPE td_display_mode VALUE 'E' ##NO_TEXT,
      END OF c_display,
      "! Runs the batch input with SY-BATCH = 'X' (even if runs interactively)
      BEGIN OF c_display_sybatch,
        "! Screens are not displayed at all
        nothing     TYPE td_display_mode VALUE 'Q' ##NO_TEXT,
        "! Every screen is displayed, the user must press Enter to reach next screen
        all_screens TYPE td_display_mode VALUE 'D' ##NO_TEXT,
        "! Screens are displayed only from the screen where an error occurs, otherwise screens are not displayed
        if_error    TYPE td_display_mode VALUE 'H' ##NO_TEXT,
      END OF c_display_sybatch.
    CONSTANTS:
      BEGIN OF c_update,
        asynchronous TYPE td_update_mode VALUE 'A' ##NO_TEXT,
        synchronous  TYPE td_update_mode VALUE 'S' ##NO_TEXT,
        local        TYPE td_update_mode VALUE 'L' ##NO_TEXT,
      END OF c_update .

    METHODS constructor
      IMPORTING
        !iv_tcode TYPE tcode .
    METHODS add_dynpro
      IMPORTING
        !dynpro                   TYPE REF TO zcl_btci_dynpro
      RETURNING
        VALUE(fluent_transaction) TYPE REF TO zcl_btci_transaction .
    METHODS add_dynpros
      IMPORTING
        !dynpros                  TYPE ty_dynpros
      RETURNING
        VALUE(fluent_transaction) TYPE REF TO zcl_btci_transaction .
    METHODS call_transaction
      IMPORTING
        VALUE(iv_display) TYPE ctu_params-dismode DEFAULT c_display-nothing
        VALUE(iv_update)  TYPE ctu_params-updmode DEFAULT c_update-asynchronous
        VALUE(is_param)   TYPE ctu_params OPTIONAL
      RETURNING
        VALUE(eo_result)  TYPE REF TO zcl_btci_result .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btci_transaction IMPLEMENTATION.


  METHOD add_dynpro.

    APPEND LINES OF dynpro->aut_bdcdata TO aut_bdcdata.
    fluent_transaction = me.

  ENDMETHOD.


  METHOD add_dynpros.

    LOOP AT dynpros INTO DATA(dynpro).
      APPEND LINES OF dynpro->aut_bdcdata TO aut_bdcdata.
    ENDLOOP.
    fluent_transaction = me.

  ENDMETHOD.


  METHOD call_transaction.

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


  ENDMETHOD.


  METHOD constructor.

    aud_tcode = iv_tcode.

  ENDMETHOD.
ENDCLASS.
