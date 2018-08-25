CLASS zcl_btci_dynpro DEFINITION
  PUBLIC
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_btci_selscr .

  PUBLIC SECTION.

    DATA program TYPE syrepid READ-ONLY .
    DATA dynpro TYPE sydynnr READ-ONLY .
    DATA aut_bdcdata TYPE wdkbdcdata_tty .

    METHODS constructor
      IMPORTING
        !iv_program TYPE syrepid
        !iv_dynpro  TYPE sydynnr .
    METHODS set_field
      IMPORTING
        !name                TYPE c OPTIONAL
        !value               TYPE simple OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS append_steploop_field
      IMPORTING
        !name                TYPE c OPTIONAL
        !iv_stepl            TYPE numeric
        !value               TYPE simple
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS set_cursor
      IMPORTING
        !name                TYPE c
        !steploop_row        TYPE i OPTIONAL
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS set_cursor_dobj
      IMPORTING
        !dobj               TYPE any
        !steploop_row        TYPE i OPTIONAL
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS set_cursor_list
      IMPORTING
        !row                 TYPE i
        !column              TYPE i
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS set_okcode
      IMPORTING
        !iv_okcode           TYPE syucomm
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zcl_btci_dynpro .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS c_b_dc_okcode TYPE bdcdata-fnam VALUE 'BDC_OKCODE' ##NO_TEXT.
    CONSTANTS c_b_dc_cursor TYPE bdcdata-fnam VALUE 'BDC_CURSOR' ##NO_TEXT.

    METHODS deduce_field_name
      IMPORTING
        !value               TYPE simple
      RETURNING
        VALUE(ev_field_name) TYPE d021s-fnam .
    CLASS-METHODS create_dummy_empty_dynpro
      RETURNING
        VALUE(dynpro) TYPE REF TO zcl_btci_dynpro .
ENDCLASS.



CLASS zcl_btci_dynpro IMPLEMENTATION.


  METHOD append_steploop_field.

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

  ENDMETHOD.


  METHOD constructor.

    DATA ls_bdcdata TYPE bdcdata.

    program = iv_program.
    dynpro = iv_dynpro.

    CLEAR ls_bdcdata.
    ls_bdcdata-dynbegin = abap_true.
    ls_bdcdata-program = iv_program.
    ls_bdcdata-dynpro  = iv_dynpro.
    APPEND ls_bdcdata TO aut_bdcdata.

  ENDMETHOD.


  METHOD create_dummy_empty_dynpro.

    dynpro = NEW zcl_btci_dynpro( iv_program = space iv_dynpro = space ).
    CLEAR dynpro->aut_bdcdata.

  ENDMETHOD.


  METHOD deduce_field_name.

    DESCRIBE FIELD value HELP-ID ev_field_name.

  ENDMETHOD.


  METHOD set_cursor.

    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_cursor.
    IF steploop_row = 0.
      ls_bdcdata-fval = name.
    ELSE.
      ls_bdcdata-fval = |{ name }({ steploop_row })|.
    ENDIF.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD set_cursor_dobj.

    set_cursor( name = deduce_field_name( dobj ) steploop_row = steploop_row ).

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD set_cursor_list.

    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_cursor.
    ls_bdcdata-fval = |{ row }/{ column }|.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD set_field.

    DATA ls_bdcdata TYPE bdcdata.

    IF name IS NOT INITIAL.
      ls_bdcdata-fnam = name.
    ELSE.
      ls_bdcdata-fnam = deduce_field_name( value ).
    ENDIF.
    WRITE value TO ls_bdcdata-fval.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD set_okcode.


    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_okcode.
    ls_bdcdata-fval = iv_okcode.
    APPEND ls_bdcdata TO aut_bdcdata.

    fluent_dynpro = me.

  ENDMETHOD.
ENDCLASS.
