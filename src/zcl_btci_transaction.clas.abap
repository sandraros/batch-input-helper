CLASS zcl_btci_transaction DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_btci_factory .

  PUBLIC SECTION.
    INTERFACES: zif_btci_transaction.
    METHODS constructor
      IMPORTING
        !tcode TYPE tcode .
  PROTECTED SECTION.
  PRIVATE SECTION.
    ALIASES:
      tcode FOR zif_btci_transaction~tcode,
      bdc_lines  FOR zif_btci_transaction~bdc_lines,
      c_display    FOR zif_btci_transaction~c_display,
      c_display_sybatch   FOR zif_btci_transaction~c_display_sybatch,
      c_update FOR zif_btci_transaction~c_update.

ENDCLASS.



CLASS zcl_btci_transaction IMPLEMENTATION.


  METHOD constructor.

    me->tcode = tcode.

  ENDMETHOD.

  METHOD zif_btci_transaction~add_dynpro.

    APPEND LINES OF dynpro->bdc_lines TO bdc_lines.
    fluent_transaction = me.
  ENDMETHOD.

  METHOD zif_btci_transaction~add_dynpros.

    LOOP AT dynpros INTO DATA(dynpro).
      APPEND LINES OF dynpro->bdc_lines TO bdc_lines.
    ENDLOOP.
    fluent_transaction = me.
  ENDMETHOD.

  METHOD zif_btci_transaction~call_transaction.

    DATA: bdc_messages TYPE ettcd_msg_tabtype.

    IF bdc_parameters-dismode IS INITIAL.
      bdc_parameters-dismode = bdc_display_mode.
    ENDIF.
    IF bdc_parameters-updmode IS INITIAL.
      bdc_parameters-updmode = bdc_update_mode.
    ENDIF.

    CALL TRANSACTION tcode
          USING         bdc_lines
          OPTIONS FROM  bdc_parameters
          MESSAGES INTO bdc_messages.

    CREATE OBJECT r_result TYPE zcl_btci_result
      EXPORTING
        subrc      = CONV #( sy-subrc ) ##OPERATOR " CONV allows copying SY-SUBRC before call, otherwise it's reset to zero
        bdc_messages = bdc_messages.
  ENDMETHOD.


ENDCLASS.
