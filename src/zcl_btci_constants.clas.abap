CLASS zcl_btci_constants DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF c_fkey, " list in table GUI_FKEY
        enter     TYPE syucomm VALUE '/00',
        f3        TYPE syucomm VALUE '/03',
        f5        TYPE syucomm VALUE '/05',
        f6        TYPE syucomm VALUE '/06',
        f7        TYPE syucomm VALUE '/07',
        f8        TYPE syucomm VALUE '/08',
        f9        TYPE syucomm VALUE '/09',
        f10       TYPE syucomm VALUE '/10',
        f11       TYPE syucomm VALUE '/11',
        f12       TYPE syucomm VALUE '/12',
        page_up   TYPE syucomm VALUE '/81', " works only when the system toolbar equivalent function is assigned
        page_down TYPE syucomm VALUE '/82', " works only when the system toolbar equivalent function is assigned
        BEGIN OF shift,
          f1  TYPE syucomm VALUE '/13',
          f2  TYPE syucomm VALUE '/14',
          f3  TYPE syucomm VALUE '/15',
          f4  TYPE syucomm VALUE '/16',
          f5  TYPE syucomm VALUE '/17',
          f6  TYPE syucomm VALUE '/18',
          f7  TYPE syucomm VALUE '/19',
          f8  TYPE syucomm VALUE '/20',
          f9  TYPE syucomm VALUE '/21',
          f10 TYPE syucomm VALUE '/94', " it's /94, not /22 which is used by Shift+Ctrl+0 !
          f11 TYPE syucomm VALUE '/23',
          f12 TYPE syucomm VALUE '/24',
          del TYPE syucomm VALUE '/76',
          ins TYPE syucomm VALUE '/78',
          BEGIN OF ctrl,
            f1  TYPE syucomm VALUE '/37',
            f2  TYPE syucomm VALUE '/38',
            f3  TYPE syucomm VALUE '/39',
            f4  TYPE syucomm VALUE '/40',
            f5  TYPE syucomm VALUE '/41',
            f6  TYPE syucomm VALUE '/44',
            f7  TYPE syucomm VALUE '/43',
            f8  TYPE syucomm VALUE '/44',
            f9  TYPE syucomm VALUE '/45',
            f10 TYPE syucomm VALUE '/46',
            f11 TYPE syucomm VALUE '/47',
            f12 TYPE syucomm VALUE '/48',
            _0  TYPE syucomm VALUE '/22',
          END OF ctrl,
        END OF shift,
        BEGIN OF ctrl,
          f1        TYPE syucomm VALUE '/25',
          f2        TYPE syucomm VALUE '/26',
          f3        TYPE syucomm VALUE '/27',
          f4        TYPE syucomm VALUE '/28',
          f5        TYPE syucomm VALUE '/29',
          f6        TYPE syucomm VALUE '/30',
          f7        TYPE syucomm VALUE '/31',
          f8        TYPE syucomm VALUE '/32',
          f9        TYPE syucomm VALUE '/33',
          f10       TYPE syucomm VALUE '/34',
          f11       TYPE syucomm VALUE '/35',
          f12       TYPE syucomm VALUE '/36',
          a         TYPE syucomm VALUE '/72',
          d         TYPE syucomm VALUE '/73',
          e         TYPE syucomm VALUE '/70',
          f         TYPE syucomm VALUE '/71',
          g         TYPE syucomm VALUE '/84',
          n         TYPE syucomm VALUE '/74',
          o         TYPE syucomm VALUE '/75',
          p         TYPE syucomm VALUE '/86',
          r         TYPE syucomm VALUE '/85',
          s         TYPE syucomm VALUE '/11',
          ins       TYPE syucomm VALUE '/77',
          page_up   TYPE syucomm VALUE '/80',
          page_down TYPE syucomm VALUE '/83',
          BEGIN OF shift,
            f1  TYPE syucomm VALUE '/37',
            f2  TYPE syucomm VALUE '/38',
            f3  TYPE syucomm VALUE '/39',
            f4  TYPE syucomm VALUE '/40',
            f5  TYPE syucomm VALUE '/41',
            f6  TYPE syucomm VALUE '/44',
            f7  TYPE syucomm VALUE '/43',
            f8  TYPE syucomm VALUE '/44',
            f9  TYPE syucomm VALUE '/45',
            f10 TYPE syucomm VALUE '/46',
            f11 TYPE syucomm VALUE '/47',
            f12 TYPE syucomm VALUE '/48',
            _0  TYPE syucomm VALUE '/22',
          END OF shift,
        END OF ctrl,
        BEGIN OF alt,
          backspace TYPE syucomm VALUE '/79',
        END OF alt,
      END OF c_fkey .
    CONSTANTS:
      BEGIN OF c_fcode,
        first_page TYPE syucomm VALUE 'P--',
        last_page  TYPE syucomm VALUE 'P++',
      END OF c_fcode .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BTCI_CONSTANTS IMPLEMENTATION.

ENDCLASS.
