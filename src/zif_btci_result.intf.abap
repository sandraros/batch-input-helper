interface ZIF_BTCI_RESULT
  public .

  data bdc_messages type ETTCD_MSG_TABTYPE read-only .
  data subrc type SYSUBRC read-only .
  data HAS_ERROR type ABAP_BOOL read-only .

  methods SET_ERROR_IF_CONTAINS_SY_MSG .
  methods DELETE_USELESS_SY_MSG .
  methods GET_MESSAGES_BAPIRET2
    RETURNING VALUE(r_messages) type BAPIRET2_T .
endinterface.
