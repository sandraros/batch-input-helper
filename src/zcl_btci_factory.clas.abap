CLASS zcl_btci_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_btci_factory.

    CLASS-METHODS create
      RETURNING
        VALUE(r_btci_factory) TYPE REF TO zif_btci_factory .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA singleton TYPE REF TO zif_btci_factory .
ENDCLASS.



CLASS zcl_btci_factory IMPLEMENTATION.

  METHOD create.
    IF singleton IS NOT BOUND.
      CREATE OBJECT singleton TYPE zcl_btci_factory.
    ENDIF.
    r_btci_factory = singleton.
  ENDMETHOD.


  METHOD zif_btci_factory~get_dynpro.

    CREATE OBJECT r_dynpro TYPE zcl_btci_dynpro
      EXPORTING
        program = program
        dynpro  = dynpro.

  ENDMETHOD.


  METHOD zif_btci_factory~get_transaction.

    CREATE OBJECT r_transaction TYPE zcl_btci_transaction
      EXPORTING
        tcode = tcode.

  ENDMETHOD.

  METHOD zif_btci_factory~get_submit_via_sa38.
    CREATE OBJECT r_submit_via_sa38 TYPE zcl_btci_submit_via_sa38
      EXPORTING
        program = program.
  ENDMETHOD.

ENDCLASS.
