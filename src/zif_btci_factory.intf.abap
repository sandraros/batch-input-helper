interface ZIF_BTCI_FACTORY
  public .
  METHODS get_dynpro
    IMPORTING
       program      TYPE syrepid
       dynpro       TYPE sydynnr
    RETURNING
      VALUE(r_dynpro) TYPE REF TO zif_btci_dynpro .
  METHODS get_transaction
    IMPORTING
       tcode             TYPE tcode
    RETURNING
      value(r_transaction) TYPE REF TO zif_btci_transaction .
  METHODS get_submit_via_sa38
   IMPORTING
      program TYPE syrepid
   RETURNING
     value(r_submit_via_sa38) TYPE REF TO zif_btci_submit_via_sa38 .

endinterface.
