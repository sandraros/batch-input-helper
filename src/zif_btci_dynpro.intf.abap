interface ZIF_BTCI_DYNPRO
  public .
    DATA program TYPE syrepid READ-ONLY .
    DATA dynpro TYPE sydynnr READ-ONLY .
    DATA bdc_lines TYPE wdkbdcdata_tty .

    METHODS set_field
      IMPORTING
        !name                TYPE c OPTIONAL
        !value               TYPE simple OPTIONAL
          PREFERRED PARAMETER value
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
    METHODS append_steploop_field
      IMPORTING
        !name                TYPE c OPTIONAL
        !steploop            TYPE numeric
        !value               TYPE simple
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
    METHODS set_cursor
      IMPORTING
        !name                TYPE c
        !steploop_row        TYPE i OPTIONAL
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
    METHODS set_cursor_dobj
      IMPORTING
        !dobj               TYPE any
        !steploop_row        TYPE i OPTIONAL
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
    METHODS set_cursor_list
      IMPORTING
        !row                 TYPE i
        !column              TYPE i
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
    METHODS set_okcode
      IMPORTING
        !okcode           TYPE syucomm
      RETURNING
        VALUE(fluent_dynpro) TYPE REF TO zif_btci_dynpro .
endinterface.
