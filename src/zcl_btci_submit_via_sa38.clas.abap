CLASS zcl_btci_submit_via_sa38 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !program TYPE syrepid .
    METHODS set_selection_screen
      IMPORTING
        !dynnr        TYPE sydynnr
      RETURNING
        VALUE(fluent) TYPE REF TO zcl_btci_submit_via_sa38 .
    METHODS set_parameters
      IMPORTING
        !name         TYPE csequence
        !value        TYPE csequence
      RETURNING
        VALUE(fluent) TYPE REF TO zcl_btci_submit_via_sa38 .
    METHODS set_select_options
      IMPORTING
        !name         TYPE csequence
        !value        TYPE STANDARD TABLE
      RETURNING
        VALUE(fluent) TYPE REF TO zcl_btci_submit_via_sa38 .
    METHODS execute_function
      IMPORTING
        !fcode        TYPE csequence
      RETURNING
        VALUE(fluent) TYPE REF TO zcl_btci_submit_via_sa38 .
    METHODS finalize
      RETURNING
        VALUE(transaction) TYPE REF TO zcl_btci_transaction .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA program TYPE syrepid .
    DATA transaction TYPE REF TO zcl_btci_transaction .
    DATA current_dynpro TYPE REF TO zcl_btci_dynpro .
ENDCLASS.



CLASS zcl_btci_submit_via_sa38 IMPLEMENTATION.


  METHOD constructor.

    me->program = program.
    transaction = zcl_btci=>create( )->get_transaction( iv_tcode = 'SA38'
                            )->add_dynpro( NEW zcl_btci_dynpro( iv_program = 'SAPMS38M' iv_dynpro  = '0101'
                                      )->set_field( CONV rs38m-programm( program ) ##OPERATOR
                                      )->set_okcode( 'STRT' ) ).

  ENDMETHOD.


  METHOD execute_function.

    current_dynpro->set_okcode( iv_okcode = fcode ).
    transaction->add_dynpro( current_dynpro ).
    fluent = me.

  ENDMETHOD.


  METHOD finalize.

    me->transaction->add_dynpro( NEW zcl_btci_dynpro( iv_program = 'SAPMS38M' iv_dynpro  = '0101' )->set_okcode( zcl_btci=>c_fkey-f3 ) ).
    transaction = me->transaction.

  ENDMETHOD.


  METHOD set_parameters.

    IF current_dynpro IS BOUND.
      current_dynpro->set_field( name = name value = value ).
    ENDIF.
    fluent = me.

  ENDMETHOD.


  METHOD set_selection_screen.

    current_dynpro = NEW zcl_btci_dynpro(
        iv_program = program
        iv_dynpro  = dynnr ).
    fluent = me.

  ENDMETHOD.


  METHOD set_select_options.

    IF current_dynpro IS BOUND.
      transaction->add_dynpro( current_dynpro ).
      transaction->add_dynpros( zcl_btci_selscr=>add_select_options(
          iv_program = program
          dynnr      = current_dynpro->dynpro
          name       = name
          value      = value ) ).
      set_selection_screen( current_dynpro->dynpro ).
    ENDIF.
    fluent = me.

  ENDMETHOD.
ENDCLASS.
