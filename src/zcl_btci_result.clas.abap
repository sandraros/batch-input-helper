class ZCL_BTCI_RESULT definition
  public
  final
  create private

  global friends ZCL_BTCI_TRANSACTION .

public section.

  data AUT_BDCMSGCOLL type ETTCD_MSG_TABTYPE read-only .
  data AU_SUBRC type SYSUBRC read-only .
  data HAS_ERROR type ABAP_BOOL read-only .

  methods SET_ERROR_IF_CONTAINS_SY_MSG .
  methods DELETE_USELESS_SY_MSG .
  methods GET_MESSAGES_BAPIRET2
    exporting
      !ET_BAPIRET2 type BAPIRET2_T .
protected section.
private section.

  methods CONSTRUCTOR
    importing
      value(IV_SUBRC) type SYSUBRC
      !IT_BDCMSGCOLL type ETTCD_MSG_TABTYPE .
ENDCLASS.



CLASS ZCL_BTCI_RESULT IMPLEMENTATION.


  method CONSTRUCTOR.

    au_subrc = iv_subrc.
    aut_bdcmsgcoll = it_bdcmsgcoll.
    IF au_subrc <> 0.
      has_error = abap_true.
    ELSE.
      LOOP AT aut_bdcmsgcoll TRANSPORTING NO FIELDS
            WHERE msgtyp CA sctsa_msg_types_nok .
        has_error = abap_true.
        EXIT.
      ENDLOOP.
    ENDIF.

  endmethod.


  method DELETE_USELESS_SY_MSG.

    DELETE aut_bdcmsgcoll
          WHERE msgtyp = sy-msgty
            AND msgid  = sy-msgid
            AND msgnr  = sy-msgno.

  endmethod.


  method GET_MESSAGES_BAPIRET2.

    DATA l_message TYPE string.

    REFRESH et_bapiret2.
    LOOP AT me->aut_bdcmsgcoll ASSIGNING FIELD-SYMBOL(<lfs_bdcmsgcoll>).
      MESSAGE ID <lfs_bdcmsgcoll>-msgid TYPE <lfs_bdcmsgcoll>-msgtyp NUMBER <lfs_bdcmsgcoll>-msgnr
            WITH <lfs_bdcmsgcoll>-msgv1 <lfs_bdcmsgcoll>-msgv2 <lfs_bdcmsgcoll>-msgv3 <lfs_bdcmsgcoll>-msgv4
            INTO l_message.
      et_bapiret2 = VALUE #( BASE et_bapiret2
                      ( type       = <lfs_bdcmsgcoll>-msgtyp
                        id         = <lfs_bdcmsgcoll>-msgid
                        number     = <lfs_bdcmsgcoll>-msgnr
                        message    = l_message
                        message_v1 = <lfs_bdcmsgcoll>-msgv1
                        message_v2 = <lfs_bdcmsgcoll>-msgv2
                        message_v3 = <lfs_bdcmsgcoll>-msgv3
                        message_v4 = <lfs_bdcmsgcoll>-msgv4
                      ) ).
    ENDLOOP.


  endmethod.


  method SET_ERROR_IF_CONTAINS_SY_MSG.

    READ TABLE aut_bdcmsgcoll ASSIGNING FIELD-SYMBOL(<lfs_bdcmsgcoll>)
          WITH KEY
            msgtyp = sy-msgty
            msgid  = sy-msgid
            msgnr  = sy-msgno.
    IF sy-subrc = 0.
      <lfs_bdcmsgcoll>-msgtyp = rs_c_error.
      has_error = abap_true.
    ENDIF.

  endmethod.
ENDCLASS.
