class ZCL_BTCI_RESULT definition
  public
  final
  create private

  global friends zif_btci_transaction .

public section.
  INTERFACES: Zif_BTCI_RESULT.
  ALIASES:
    bdc_messages FOR Zif_BTCI_RESULT~bdc_messages,
    has_error FOR Zif_BTCI_RESULT~has_error,
    subrc FOR Zif_BTCI_RESULT~subrc.

protected section.
private section.

  methods CONSTRUCTOR
    importing
      value(subrc) type SYSUBRC
      !bdc_messages type ETTCD_MSG_TABTYPE .
ENDCLASS.



CLASS ZCL_BTCI_RESULT IMPLEMENTATION.


  method CONSTRUCTOR.

    me->subrc = subrc.
    me->bdc_messages = bdc_messages.
    IF subrc <> 0.
      has_error = abap_true.
    ELSE.
      LOOP AT bdc_messages TRANSPORTING NO FIELDS
            WHERE msgtyp CA sctsa_msg_types_nok .
        has_error = abap_true.
        EXIT.
      ENDLOOP.
    ENDIF.

  endmethod.


  method Zif_BTCI_RESULT~DELETE_USELESS_SY_MSG.

    DELETE bdc_messages
          WHERE msgtyp = sy-msgty
            AND msgid  = sy-msgid
            AND msgnr  = sy-msgno.

  endmethod.


  method Zif_BTCI_RESULT~GET_MESSAGES_BAPIRET2.

    DATA l_message TYPE string.

    LOOP AT me->bdc_messages ASSIGNING FIELD-SYMBOL(<lfs_bdcmsgcoll>).
      MESSAGE ID <lfs_bdcmsgcoll>-msgid TYPE <lfs_bdcmsgcoll>-msgtyp NUMBER <lfs_bdcmsgcoll>-msgnr
            WITH <lfs_bdcmsgcoll>-msgv1 <lfs_bdcmsgcoll>-msgv2 <lfs_bdcmsgcoll>-msgv3 <lfs_bdcmsgcoll>-msgv4
            INTO l_message.
      r_messages = VALUE #( BASE r_messages
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


  method Zif_BTCI_RESULT~SET_ERROR_IF_CONTAINS_SY_MSG.

    READ TABLE bdc_messages ASSIGNING FIELD-SYMBOL(<lfs_bdcmsgcoll>)
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
