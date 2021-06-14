*&---------------------------------------------------------------------*
*& Report ZBTCI_DEMO_FI02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbtci_demo_fi02.

zcl_btci_factory=>create( )->get_transaction( 'FI02'
    )->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPMF02B' dynpro = '0100'
                      )->set_field( CONV bnka-banks( 'FR' ) " country
                      )->set_field( CONV bnka-bankl( '1234567890' ) " bank ID
                      )->set_okcode( zcl_btci_constants=>c_fkey-enter )
    )->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPMF02B' dynpro = '0110'
                      )->set_field( CONV bnka-banka( 'ZZ' ) " bank name
                      )->set_okcode( '=ADDR' )
    )->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPLSZA1' dynpro = '0201'
                      )->set_field( CONV addr1_data-country( 'FR' )
                      )->set_field( CONV addr1_data-langu( 'EN' )
                      )->set_okcode( '=CONT' )
     )->add_dynpro( zcl_btci_factory=>create( )->get_dynpro( program = 'SAPMF02B' dynpro = '0110'
                      )->set_okcode( '=UPDA' )
     )->call_transaction(
                      EXPORTING
                        bdc_display_mode = zif_btci_transaction=>c_display-nothing
                      RECEIVING
                        r_result  = DATA(go_result) ).
DATA(g_messages) = go_result->get_messages_bapiret2( ).
cl_demo_output=>display( g_messages ).
