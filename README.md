# batch-input-helper
ABAP API to build batch input table easily and more

# Example (ZBTCI_DEMO_FI02)

This code is to change a few fields of an existing bank, using FI02 transaction code.

    zcl_btci_factory=>create( )->get_transaction( 'FI02'
    )->add_dynpro( zcl_btci_factory=>create( )( program = 'SAPMF02B' dynpro = '0100'
                      )->set_field( CONV bnka-banks( 'FR' ) " country
                      )->set_field( CONV bnka-bankl( '1234567890' ) " bank ID
                      )->set_okcode( zcl_btci_constants=>c_fkey-enter )
    )->add_dynpro( zcl_btci_factory=>create( )( program = 'SAPMF02B' dynpro = '0110'
                      )->set_field( CONV bnka-banka( 'dummy French bank' ) " bank name
                      )->set_okcode( '=ADDR' )
    )->add_dynpro( zcl_btci_factory=>create( )( program = 'SAPLSZA1' dynpro = '0201'
                      )->set_field( CONV addr1_data-country( 'FR' )
                      )->set_field( CONV addr1_data-langu( 'EN' )
                      )->set_okcode( '=CONT' )
     )->add_dynpro( zcl_btci_factory=>create( )( program = 'SAPMF02B' dynpro = '0110'
                      )->set_okcode( '=UPDA' )
     )->call_transaction(
                      EXPORTING
                        bdc_display_mode = zcl_btci_transaction=>c_display-all_screens
                      RECEIVING
                        r_result  = DATA(lo_result) ).

based on the batch-input-helper created by sandraros https://github.com/sandraros/batch-input-helper
