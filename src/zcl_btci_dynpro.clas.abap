class ZCL_BTCI_DYNPRO definition
  public
  create public

  global friends ZCL_BTCI_SELSCR .

public section.

  data PROGRAM type SYREPID read-only .
  data DYNPRO type SYDYNNR read-only .
  data AUT_BDCDATA type WDKBDCDATA_TTY .

  methods CONSTRUCTOR
    importing
      !IV_PROGRAM type SYREPID
      !IV_DYNPRO type SYDYNNR .
  methods SET_FIELD
    importing
      !NAME type C optional
      !VALUE type SIMPLE optional
    preferred parameter VALUE
    returning
      value(FLUENT_DYNPRO) type ref to ZCL_BTCI_DYNPRO .
  methods APPEND_STEPLOOP_FIELD
    importing
      !NAME type C optional
      !IV_STEPL type NUMERIC
      !VALUE type SIMPLE
    returning
      value(FLUENT_DYNPRO) type ref to ZCL_BTCI_DYNPRO .
  methods SET_CURSOR
    importing
      !NAME type C
    returning
      value(FLUENT_DYNPRO) type ref to ZCL_BTCI_DYNPRO .
  methods SET_OKCODE
    importing
      !IV_OKCODE type SYUCOMM
    returning
      value(FLUENT_DYNPRO) type ref to ZCL_BTCI_DYNPRO .
protected section.
private section.

  constants C_B_DC_OKCODE type BDCDATA-FNAM value 'BDC_OKCODE' ##NO_TEXT.
  constants C_B_DC_CURSOR type BDCDATA-FNAM value 'BDC_CURSOR' ##NO_TEXT.

  methods DEDUCE_FIELD_NAME
    importing
      !VALUE type SIMPLE
    returning
      value(EV_FIELD_NAME) type D021S-FNAM .
  class-methods CREATE_DUMMY_EMPTY_DYNPRO
    returning
      value(DYNPRO) type ref to ZCL_BTCI_DYNPRO .
ENDCLASS.



CLASS ZCL_BTCI_DYNPRO IMPLEMENTATION.


  method APPEND_STEPLOOP_FIELD.

    DATA: ls_bdcdata TYPE bdcdata,
          l_stepl(2) TYPE n.

    IF name IS NOT INITIAL.
      ls_bdcdata-fnam = name.
    ELSE.
      ls_bdcdata-fnam = deduce_field_name( value ).
    ENDIF.

    l_stepl = iv_stepl.
    CONCATENATE ls_bdcdata-fnam '(' l_stepl ')' INTO ls_bdcdata-fnam.
    WRITE value TO ls_bdcdata-fval.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  endmethod.


  method CONSTRUCTOR.

    DATA ls_bdcdata TYPE bdcdata.

    program = iv_program.
    dynpro = iv_dynpro.

    CLEAR ls_bdcdata.
    ls_bdcdata-dynbegin = abap_true.
    ls_bdcdata-program = iv_program.
    ls_bdcdata-dynpro  = iv_dynpro.
    APPEND ls_bdcdata TO aut_bdcdata.

  endmethod.


  method CREATE_DUMMY_EMPTY_DYNPRO.

    dynpro = NEW zcl_btci_dynpro( iv_program = space iv_dynpro = space ).
    CLEAR dynpro->aut_bdcdata.

  endmethod.


  method DEDUCE_FIELD_NAME.

    DESCRIBE FIELD value HELP-ID ev_field_name.

  endmethod.


  method SET_CURSOR.


    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_cursor.
    ls_bdcdata-fval = name.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  endmethod.


  method SET_FIELD.

    DATA ls_bdcdata TYPE bdcdata.

    IF name IS NOT INITIAL.
      ls_bdcdata-fnam = name.
    ELSE.
      ls_bdcdata-fnam = deduce_field_name( value ).
    ENDIF.
    WRITE value TO ls_bdcdata-fval.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  endmethod.


  method SET_OKCODE.


    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_okcode.
    ls_bdcdata-fval = iv_okcode.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  endmethod.
ENDCLASS.
