CLASS zcl_btci_submit_via_sa38 DEFINITION
  PUBLIC
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_btci_factory .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !program TYPE syrepid .
    INTERFACES: zif_btci_submit_via_sa38.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA program TYPE syrepid .
    DATA transaction TYPE REF TO zif_btci_transaction .
    DATA current_dynpro TYPE REF TO zif_btci_dynpro .
ENDCLASS.



CLASS zcl_btci_submit_via_sa38 IMPLEMENTATION.


  METHOD constructor.

    me->program = program.
    transaction = zcl_btci_factory=>create( )->get_transaction( tcode = 'SA38'
                            )->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPMS38M' dynpro  = '0101'
                                      )->set_field( CONV rs38m-programm( program ) ##OPERATOR
                                      )->set_okcode( 'STRT' ) ).

  ENDMETHOD.


  METHOD zif_btci_submit_via_sa38~execute_function.

    current_dynpro->set_okcode( okcode = fcode ).
    transaction->add_dynpro( current_dynpro ).
    fluent = me.

  ENDMETHOD.


  METHOD zif_btci_submit_via_sa38~finalize.

    me->transaction->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPMS38M' dynpro  = '0101' )->set_okcode( zcl_btci_constants=>c_fkey-f3 ) ).
    transaction = me->transaction.

  ENDMETHOD.


  METHOD zif_btci_submit_via_sa38~set_parameters.

    IF current_dynpro IS BOUND.
      current_dynpro->set_field( name = name value = value ).
    ENDIF.
    fluent = me.

  ENDMETHOD.


  METHOD zif_btci_submit_via_sa38~set_selection_screen.

    current_dynpro = NEW zcl_btci_dynpro(
        program = program
        dynpro  = dynnr ).
    fluent = me.

  ENDMETHOD.


  METHOD zif_btci_submit_via_sa38~set_select_options.

    IF current_dynpro IS BOUND.
      transaction->add_dynpro( current_dynpro ).
      transaction->add_dynpros( zcl_btci_selscr=>add_select_options(
          program = program
          dynnr      = current_dynpro->dynpro
          name       = name
          value      = value ) ).
      zif_btci_submit_via_sa38~set_selection_screen( current_dynpro->dynpro ).
    ENDIF.
    fluent = me.

  ENDMETHOD.
ENDCLASS.
