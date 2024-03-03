interface ZIF_BTCI_SUBMIT_VIA_SA38
  public .

    METHODS set_selection_screen
      IMPORTING
        !dynnr        TYPE sydynnr
      RETURNING
        VALUE(fluent) TYPE REF TO zif_btci_submit_via_sa38 .
    METHODS set_parameters
      IMPORTING
        !name         TYPE csequence
        !value        TYPE csequence
      RETURNING
        VALUE(fluent) TYPE REF TO zif_btci_submit_via_sa38 .
    METHODS set_select_options
      IMPORTING
        !name         TYPE csequence
        !value        TYPE STANDARD TABLE
      RETURNING
        VALUE(fluent) TYPE REF TO zif_btci_submit_via_sa38 .
    METHODS execute_function
      IMPORTING
        !fcode        TYPE csequence
      RETURNING
        VALUE(fluent) TYPE REF TO zif_btci_submit_via_sa38 .
    METHODS finalize
      RETURNING
        VALUE(transaction) TYPE REF TO zif_btci_transaction .
endinterface.
