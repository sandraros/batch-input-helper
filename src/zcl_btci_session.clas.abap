class ZCL_BTCI_SESSION definition
  public
  create public .

public section.

  types TD_SESSION_NAME type APQI-GROUPID .

  data AUD_SESSION_NAME type TD_SESSION_NAME .
  data AUD_QID type APQI-QID .

  methods INSERT
    importing
      !IO_BTCI_TRANSACTION type ref to ZCL_BTCI_TRANSACTION .
  methods CLOSE
    importing
      !ID_COMMIT type FLAG .
  methods CONSTRUCTOR
    importing
      !ID_SESSION_NAME type TD_SESSION_NAME .
  methods RUN_DIALOG
    importing
      !ID_MODE type CHAR01 default 'N'
      !ID_LOGALL type FLAG default '' .
  class-methods RUN_ALL .
protected section.
private section.

  data AIT_BDCDATA type WDKBDCDATA_TTY .
ENDCLASS.



CLASS ZCL_BTCI_SESSION IMPLEMENTATION.


  method CLOSE.


    " close the batch input folder
    CALL FUNCTION 'BDC_CLOSE_GROUP'
      EXCEPTIONS
        OTHERS = 1.

    IF id_commit = abap_true.
      COMMIT WORK.
    ENDIF.


  endmethod.


  method CONSTRUCTOR.


    aud_session_name = id_session_name.

* BTCI Session opening
    CALL FUNCTION 'BDC_OPEN_GROUP'
      EXPORTING
        client        = sy-mandt            " Client
        group         = aud_session_name    " Batch input session name
        keep          = 'X'                 " Indicator to keep processed session
        user          = sy-uname            " Batch input user
      IMPORTING
        qid           = aud_qid
      EXCEPTIONS
        group_invalid = 1  " Batch input session name is invalid
        OTHERS        = 2.


  endmethod.


  method INSERT.


    " Function module for wt_bdctab data transfer in queue file
    CALL FUNCTION 'BDC_INSERT'
      EXPORTING
        tcode         = io_btci_transaction->aud_tcode   " Transaction code
      TABLES
        dynprotab     = io_btci_transaction->aut_bdcdata
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
        WITH queue_id = aud_qid
        WITH mappe    = aud_session_name
        WITH modus    = id_mode
        WITH logall   = id_logall
        AND RETURN.


  endmethod.
ENDCLASS.
