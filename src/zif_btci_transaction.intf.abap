INTERFACE zif_btci_transaction
  PUBLIC .
  TYPES td_display_mode TYPE char01 .
  TYPES td_update_mode TYPE char01 .

  TYPES:
    ty_dynpros TYPE STANDARD TABLE OF REF TO zif_btci_dynpro WITH DEFAULT KEY .

  DATA tcode TYPE tcode READ-ONLY .
  DATA bdc_lines TYPE wdkbdcdata_tty READ-ONLY .
  CONSTANTS:
    "! Runs the batch input with SY-BATCH unchanged (' ' if interactive, 'X' if background)
    BEGIN OF c_display,
      "! Screens are not displayed at all
      nothing     TYPE td_display_mode VALUE 'N' ##NO_TEXT,
      "! Every screen is displayed, the user must press Enter to reach next screen
      all_screens TYPE td_display_mode VALUE 'A' ##NO_TEXT,
      "! Screens are displayed only from the screen where an error occurs, otherwise screens are not displayed
      if_error    TYPE td_display_mode VALUE 'E' ##NO_TEXT,
    END OF c_display,
    "! Runs the batch input with SY-BATCH = 'X' (even if runs interactively)
    BEGIN OF c_display_sybatch,
      "! Screens are not displayed at all
      nothing     TYPE td_display_mode VALUE 'Q' ##NO_TEXT,
      "! Every screen is displayed, the user must press Enter to reach next screen
      all_screens TYPE td_display_mode VALUE 'D' ##NO_TEXT,
      "! Screens are displayed only from the screen where an error occurs, otherwise screens are not displayed
      if_error    TYPE td_display_mode VALUE 'H' ##NO_TEXT,
    END OF c_display_sybatch.
  CONSTANTS:
    BEGIN OF c_update,
      asynchronous TYPE td_update_mode VALUE 'A' ##NO_TEXT,
      synchronous  TYPE td_update_mode VALUE 'S' ##NO_TEXT,
      local        TYPE td_update_mode VALUE 'L' ##NO_TEXT,
    END OF c_update .

  METHODS add_dynpro
    IMPORTING
      dynpro                    TYPE REF TO zif_btci_dynpro
    RETURNING
      VALUE(fluent_transaction) TYPE REF TO zif_btci_transaction .
  METHODS add_dynpros
    IMPORTING
      dynpros                   TYPE ty_dynpros
    RETURNING
      VALUE(fluent_transaction) TYPE REF TO zif_btci_transaction .
  METHODS call_transaction
    IMPORTING
      VALUE(bdc_display_mode) TYPE ctu_params-dismode DEFAULT c_display-nothing
      VALUE(bdc_update_mode)  TYPE ctu_params-updmode DEFAULT c_update-asynchronous
      VALUE(bdc_parameters)   TYPE ctu_params OPTIONAL
    RETURNING
      VALUE(r_result)         TYPE REF TO zif_btci_result .
ENDINTERFACE.
