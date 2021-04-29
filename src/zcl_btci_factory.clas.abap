CLASS zcl_btci_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*    INTERFACES: zif_btci_factory.
      CLASS-METHODS create
      RETURNING
        VALUE(btci) TYPE REF TO zcl_btci_factory .
    METHODS get_dynpro
      IMPORTING
        !iv_program      TYPE syrepid
        !iv_dynpro       TYPE sydynnr
      RETURNING
        VALUE(r_dynpro) TYPE REF TO zcl_btci_dynpro .
    METHODS get_transaction
      IMPORTING
        !iv_tcode             TYPE tcode
      RETURNING
        VALUE(r_transaction) TYPE REF TO zcl_btci_transaction .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA singleton TYPE REF TO zcl_btci_factory .
ENDCLASS.



CLASS zcl_btci_factory IMPLEMENTATION.

  METHOD create.
    IF singleton IS NOT BOUND.
      CREATE OBJECT singleton.
    ENDIF.
    btci = singleton.
  ENDMETHOD.


  METHOD get_dynpro.

    CREATE OBJECT r_dynpro
      EXPORTING
        iv_program = iv_program
        iv_dynpro  = iv_dynpro.

  ENDMETHOD.


  METHOD get_transaction.

    CREATE OBJECT r_transaction
      EXPORTING
        iv_tcode = iv_tcode.

  ENDMETHOD.
ENDCLASS.
