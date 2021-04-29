"! This class has not been tested by Martin at all
class ZCL_BTCI_SESSION definition
  public
  create public .

public section.

  data session_name type APQI-GROUPID  .
  data queue_identification type APQI-QID .

  methods CONSTRUCTOR
    importing
      !session_name type APQI-GROUPID .

  methods INSERT
    importing
      !btci_transaction type ref to zif_btci_transaction .
  methods CLOSE
    importing
      !i_commit type FLAG .
  methods RUN_DIALOG
    importing
      !mode type CHAR01 default 'N'
      !logall type FLAG default '' .
  class-methods RUN_ALL .
protected section.
private section.

  data bdcdata_lines type WDKBDCDATA_TTY .
ENDCLASS.



CLASS ZCL_BTCI_SESSION IMPLEMENTATION.


  method CONSTRUCTOR.


    me->session_name = session_name.

* BTCI Session opening
    CALL FUNCTION 'BDC_OPEN_GROUP'
      EXPORTING
        client        = sy-mandt            " Client
        group         = session_name    " Batch input session name
        keep          = 'X'                 " Indicator to keep processed session
        user          = sy-uname            " Batch input user
      IMPORTING
        qid           = queue_identification
      EXCEPTIONS
        group_invalid = 1  " Batch input session name is invalid
        OTHERS        = 2.


  endmethod.

  method CLOSE.


    " close the batch input folder
    CALL FUNCTION 'BDC_CLOSE_GROUP'
      EXCEPTIONS
        OTHERS = 1.

    IF i_commit = abap_true.
      COMMIT WORK.
    ENDIF.


  endmethod.




  method INSERT.


    " Function module for wt_bdctab data transfer in queue file
    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        tcode         = btci_transaction->tcode   " Transaction code
      TABLES
        dynprotab     = btci_transaction->bdc_lines
      EXCEPTIONS
        tcode_invalid = 1          " Transaction code is unknown
        OTHERS        = 2.


  endmethod.


  method RUN_ALL.

    " TODO
*SUBMIT rsbdcsub
*        with batchsys =
*        with bis      =
*        with fehler   =
*        with logall   =
*        with mappe    =
*        with queue_id =
*        with von      =
*        with z_verarb = .


  endmethod.


  method RUN_DIALOG.


    SUBMIT rsbdcbtc
        WITH queue_id = queue_identification
        WITH mappe    = session_name
        WITH modus    = mode
        WITH logall   = logall
        AND RETURN.


  endmethod.
ENDCLASS.
