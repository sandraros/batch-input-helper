*&---------------------------------------------------------------------*
*& Report zbtci_demo_sa38
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbtci_demo_sa38.

PARAMETERS p_carrid TYPE scarr-carrid.
SELECT-OPTIONS s_carrid FOR p_carrid.

START-OF-SELECTION.
  TYPES ty_range_carrid LIKE s_carrid[].

  IF p_carrid IS INITIAL.

    zcl_btci_factory=>create( )->get_submit_via_sa38( program = 'ZZSRO_TEST6' ##TODo "this program doesn't exist...

          )->set_selection_screen( '1000'
          )->set_parameters( name = 'P_CARRID' value = 'X'
          )->set_select_options( name = 'S_CARRID' value = VALUE ty_range_carrid( sign = 'I' option = 'EQ' ( low = 'A' ) ( low = 'B' ) ( low = 'C' )
                    ( low = 'D' ) ( low = 'E' ) ( low = 'F' ) ( low = 'G' ) ( low = 'H' ) ( low = 'I' ) ( low = 'J' ) ( low = 'K' ) ( low = 'L' ) )
          )->execute_function( 'ONLI'

          )->set_selection_screen( '1000'
          )->execute_function( zcl_btci_constants=>c_fkey-f3 " BACK

          )->finalize( )->call_transaction(
            EXPORTING
              bdc_display_mode = zif_btci_transaction=>c_display-all_screens
            RECEIVING
              r_result  = DATA(go_result)
          ).

    DATA(g_messages) = go_result->get_messages_bapiret2( ).
    cl_demo_output=>display( g_messages ).

  ELSE.

    BREAK-POINT.

  ENDIF.
