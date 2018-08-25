class ZCL_BTCI_SELSCR definition
  public
  abstract
  create public .

public section.

  class-methods ADD_SELECT_OPTIONS
    importing
      !IV_PROGRAM type SYREPID
      !DYNNR type SYDYNNR
      !NAME type CSEQUENCE
      !VALUE type STANDARD TABLE
    returning
      value(DYNPROS) type ZCL_BTCI_TRANSACTION=>TY_DYNPROS .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BTCI_SELSCR IMPLEMENTATION.


  method ADD_SELECT_OPTIONS.

    TYPES :
      BEGIN OF ty_ls_tab,
        ucomm   TYPE syucomm,
        sign    TYPE tvarvc-sign,
        sng_int TYPE char1,
      END OF ty_ls_tab.
    DATA :
      ls_bdcdata TYPE bdcdata,
      ls_d020s   TYPE d020s,
      lt_d021s   TYPE TABLE OF d021s, "field list
      lt_d022s   TYPE TABLE OF d022s, "flow logic
      lt_d023s   TYPE TABLE OF d023s, "matchcode information
      BEGIN OF ls_id,
        repid TYPE syrepid,
        dynnr TYPE sydynnr,
      END OF ls_id,
      ls_res1       TYPE d021s_res1,
      l_row_number  TYPE n LENGTH 2,
      l_first_time  TYPE flag,
      l_is_interval TYPE flag,
      l_fnam        TYPE bdcdata-fnam,
      lt_tab        TYPE TABLE OF ty_ls_tab.
    FIELD-SYMBOLS :
      <ls_d021s> TYPE d021s,
      <ls_range> TYPE any,
      <l_sign>   TYPE rsdsselopt-sign,
      <l_option> TYPE rsdsselopt-option,
      <l_low>    TYPE clike,
      <l_high>   TYPE clike,
      <ls_tab>   TYPE ty_ls_tab.

    ls_id-repid = iv_program.
    ls_id-dynnr = dynnr.
    IMPORT DYNPRO ls_d020s lt_d021s lt_d022s lt_d023s ID ls_id.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_btci.
    ENDIF.

    CONCATENATE '%_' name '_%_APP_%-VALU_PUSH' INTO l_fnam.
    READ TABLE lt_d021s ASSIGNING <ls_d021s> WITH KEY fnam = l_fnam.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_btci.
    ENDIF.

    "------------------------------------------
    " click the button to get into the select-options dialog
    " (note that the previous dynpro was not terminated by a BDC_OKCODE so
    " here we add a dummy dynpro with this BDC_OKCODE)
    "------------------------------------------
    ls_res1 = <ls_d021s>-res1.
    DATA(dynpro2) = zcl_btci_dynpro=>create_dummy_empty_dynpro( ).
    dynpro2->set_okcode( CONV #( ls_res1-funccode ) ).
    APPEND dynpro2 TO dynpros.

    "------------------------------------------
    " empty the list of values inside the select options
    "------------------------------------------
    dynpro2 = NEW zcl_btci_dynpro( iv_program = 'SAPLALDB' iv_dynpro = '3000' ).
    dynpro2->set_okcode( '/EDELA' ).
    APPEND dynpro2 TO dynpros.

    dynpro2 = NEW zcl_btci_dynpro( iv_program = 'SAPLALDB' iv_dynpro = '3000' ).

    "------------------------------------------
    " Now fill values from the range
    "------------------------------------------
    lt_tab = VALUE #( ( ucomm = 'SIVA'  sign = 'I' sng_int = 'S' )
                      ( ucomm = 'INTL'  sign = 'I' sng_int = 'I' )
                      ( ucomm = 'NOSV'  sign = 'E' sng_int = 'S' )
                      ( ucomm = 'NOINT' sign = 'E' sng_int = 'I' ) ).

    LOOP AT lt_tab ASSIGNING <ls_tab>.

      l_first_time = 'X'.

      LOOP AT value ASSIGNING <ls_range>.

        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <ls_range> TO <l_sign>.
        ASSERT sy-subrc = 0.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_range> TO <l_option>.
        ASSERT sy-subrc = 0.
        IF <l_option> = 'BT' OR <l_option> = 'NB'.
          l_is_interval = 'X'.
        ELSE.
          CLEAR l_is_interval.
        ENDIF.

        CHECK ( <ls_tab>-ucomm = 'SIVA' AND <l_sign> = 'I' AND l_is_interval IS INITIAL )
              OR ( <ls_tab>-ucomm = 'INTL' AND <l_sign> = 'I' AND l_is_interval = 'X' )
              OR ( <ls_tab>-ucomm = 'NOSV' AND <l_sign> = 'E' AND l_is_interval IS INITIAL )
              OR ( <ls_tab>-ucomm = 'NOINT' AND <l_sign> = 'E' AND l_is_interval = 'X' ).

        IF l_first_time = 'X'.
          " FIRST PAGE in the tab
          " change to tabstrip tab (action recorded on the previously filled screen)
          IF <ls_tab>-ucomm <> 'SIVA'.
            dynpro2->set_okcode( <ls_tab>-ucomm ).
            APPEND dynpro2 TO dynpros.

            " now, prepare start of next screen
            dynpro2 = NEW zcl_btci_dynpro( iv_program = 'SAPLALDB' iv_dynpro = '3000' ).
          ENDIF.
          l_row_number = 1.
          CLEAR l_first_time.

        ELSEIF l_row_number = 9.
          " NEXT PAGE in the tab
          " Simulate page down by Enter key (action recorded on the previously filled screen)
          dynpro2->set_cursor( l_fnam )->set_okcode( 'P+' ).
          APPEND dynpro2 TO dynpros.

          dynpro2 = NEW zcl_btci_dynpro( iv_program = 'SAPLALDB' iv_dynpro = '3000' ).

          " page down will scroll 7 lines only (last line of last page becomes the first line)
          " so fill from second line
          l_row_number = 2.
        ENDIF.

        ASSIGN COMPONENT 'LOW' OF STRUCTURE <ls_range> TO <l_low>.
        ASSERT sy-subrc = 0.
        IF sy-saprl < '702'.
          CONCATENATE 'RSCSEL-' <ls_tab>-sng_int 'LOW_' <ls_tab>-sign '(' l_row_number ')' INTO l_fnam.
        ELSE.
          CONCATENATE 'RSCSEL_255-' <ls_tab>-sng_int 'LOW_' <ls_tab>-sign '(' l_row_number ')' INTO l_fnam.
        ENDIF.

        dynpro2->set_field( name = l_fnam value = <l_low> ).

        IF <ls_tab>-sng_int = 'I'.
          ASSIGN COMPONENT 'HIGH' OF STRUCTURE <ls_range> TO <l_high>.
          ASSERT sy-subrc = 0.
          IF sy-saprl < '702'.
            CONCATENATE 'RSCSEL-' <ls_tab>-sng_int 'HIGH_' <ls_tab>-sign '(' l_row_number ')' INTO l_fnam.
          ELSE.
            CONCATENATE 'RSCSEL_255-' <ls_tab>-sng_int 'HIGH_' <ls_tab>-sign '(' l_row_number ')' INTO l_fnam.
          ENDIF.
          dynpro2->set_field( name = l_fnam value = <l_high> ).
        ENDIF.

        ADD 1 TO l_row_number.

      ENDLOOP.

    ENDLOOP.

    " action on the previously filled screen
    dynpro2->set_okcode( '=ACPT' ).
    APPEND dynpro2 TO dynpros.


  endmethod.
ENDCLASS.
