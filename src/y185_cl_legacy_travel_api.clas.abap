CLASS y185_cl_legacy_travel_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Table type for multiple travel records
    TYPES: tt_travel TYPE STANDARD TABLE OF y185m_travel WITH DEFAULT KEY.

    " Legacy methods for CRUD operations
    CLASS-METHODS create_travel
      IMPORTING it_travel TYPE tt_travel.

    CLASS-METHODS update_travel
      IMPORTING it_travel TYPE tt_travel.

    CLASS-METHODS delete_travel
      IMPORTING it_travel TYPE tt_travel.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS y185_cl_legacy_travel_api IMPLEMENTATION.

  METHOD create_travel.
    IF it_travel IS NOT INITIAL.
      INSERT y185m_travel FROM TABLE @it_travel.
    ENDIF.
  ENDMETHOD.

  METHOD update_travel.
    IF it_travel IS NOT INITIAL.
      UPDATE y185m_travel FROM TABLE @it_travel.
    ENDIF.
  ENDMETHOD.

  METHOD delete_travel.
    IF it_travel IS NOT INITIAL.
      DELETE y185m_travel FROM TABLE @it_travel.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
