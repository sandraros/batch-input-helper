CLASS zcl_btci_dynpro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_btci_selscr .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !program TYPE syrepid
        !dynpro  TYPE sydynnr .
    INTERFACES: zif_btci_dynpro.

  PROTECTED SECTION.
  PRIVATE SECTION.
  ALIASES:
    bdc_lines  FOR   zif_btci_dynpro~bdc_lines,
    dynpro  FOR   zif_btci_dynpro~dynpro,
    program  FOR   zif_btci_dynpro~program.


    CONSTANTS c_b_dc_okcode TYPE bdcdata-fnam VALUE 'BDC_OKCODE' ##NO_TEXT.
    CONSTANTS c_b_dc_cursor TYPE bdcdata-fnam VALUE 'BDC_CURSOR' ##NO_TEXT.

    METHODS deduce_field_name
      IMPORTING
        !value               TYPE simple
      RETURNING
        VALUE(r_result) TYPE d021s-fnam .
    CLASS-METHODS create_dummy_empty_dynpro
      RETURNING
        VALUE(dynpro) TYPE REF TO zif_btci_dynpro .
ENDCLASS.



CLASS zcl_btci_dynpro IMPLEMENTATION.

  METHOD constructor.

    DATA ls_bdcdata TYPE bdcdata.

    me->program = program.
    me->dynpro = dynpro.

    CLEAR ls_bdcdata.
    ls_bdcdata-dynbegin = abap_true.
    ls_bdcdata-program = program.
    ls_bdcdata-dynpro  = dynpro.
    APPEND ls_bdcdata TO bdc_lines.

  ENDMETHOD.



  METHOD create_dummy_empty_dynpro.

    dynpro = NEW zcl_btci_dynpro( program = space dynpro = space ).
    CLEAR dynpro->bdc_lines.

  ENDMETHOD.

  METHOD zif_btci_dynpro~append_steploop_field.

    DATA: ls_bdcdata TYPE bdcdata,
          l_stepl(2) TYPE n.

    IF name IS NOT INITIAL.
      ls_bdcdata-fnam = name.
    ELSE.
      ls_bdcdata-fnam = deduce_field_name( value ).
    ENDIF.

    l_stepl = steploop.
    CONCATENATE ls_bdcdata-fnam '(' l_stepl ')' INTO ls_bdcdata-fnam.
    WRITE value TO ls_bdcdata-fval.
    APPEND ls_bdcdata TO bdc_lines.

    fluent_dynpro = me.

  ENDMETHOD.

  METHOD deduce_field_name.

    DESCRIBE FIELD value HELP-ID r_result.

  ENDMETHOD.


  METHOD zif_btci_dynpro~set_cursor.

    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_cursor.
    IF steploop_row = 0.
      ls_bdcdata-fval = name.
    ELSE.
      ls_bdcdata-fval = |{ name }({ steploop_row })|.
    ENDIF.
    APPEND ls_bdcdata TO bdc_lines.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD zif_btci_dynpro~set_cursor_dobj.

    zif_btci_dynpro~set_cursor( name = deduce_field_name( dobj ) steploop_row = steploop_row ).

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD zif_btci_dynpro~set_cursor_list.

    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_cursor.
    ls_bdcdata-fval = |{ row }/{ column }|.
    APPEND ls_bdcdata TO bdc_lines.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD zif_btci_dynpro~set_field.

    DATA ls_bdcdata TYPE bdcdata.

    IF name IS NOT INITIAL.
      ls_bdcdata-fnam = name.
    ELSE.
      ls_bdcdata-fnam = deduce_field_name( value ).
    ENDIF.
    WRITE value TO ls_bdcdata-fval.
    APPEND ls_bdcdata TO bdc_lines.

    fluent_dynpro = me.

  ENDMETHOD.


  METHOD zif_btci_dynpro~set_okcode.


    DATA ls_bdcdata TYPE bdcdata.

    ls_bdcdata-fnam = c_b_dc_okcode.
    ls_bdcdata-fval = okcode.
    APPEND ls_bdcdata TO bdc_lines.

    fluent_dynpro = me.

  ENDMETHOD.

ENDCLASS.
