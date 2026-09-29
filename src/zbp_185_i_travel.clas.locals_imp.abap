*" ----------------------------------------------------------------------
*" STEP 1: The Transactional Buffers (Memory)
*" ----------------------------------------------------------------------
CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: gt_travel_create TYPE STANDARD TABLE OF y185m_travel,
                gt_travel_update TYPE STANDARD TABLE OF y185m_travel,
                gt_travel_delete TYPE STANDARD TABLE OF y185m_travel.
ENDCLASS.

*" ----------------------------------------------------------------------
*" STEP 2: The Handler Class (Interaction Phase)
*" ----------------------------------------------------------------------
CLASS lhc_y185_I_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.
ENDCLASS.

CLASS lhc_y185_I_Travel IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fiori_data>).
      DATA(ls_travel) = VALUE y185m_travel(
          client      = sy-mandt
          travel_id   = <fiori_data>-TravelId
          employee_id = <fiori_data>-EmployeeId
          destination = <fiori_data>-Destination
          start_date  = <fiori_data>-StartDate
          end_date    = <fiori_data>-EndDate
          status      = <fiori_data>-Status
      ).
      APPEND ls_travel TO lcl_buffer=>gt_travel_create.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fiori_data>).
      DATA(ls_travel) = VALUE y185m_travel(
          client      = sy-mandt
          travel_id   = <fiori_data>-TravelId
          employee_id = <fiori_data>-EmployeeId
          destination = <fiori_data>-Destination
          start_date  = <fiori_data>-StartDate
          end_date    = <fiori_data>-EndDate
          status      = <fiori_data>-Status
      ).
      APPEND ls_travel TO lcl_buffer=>gt_travel_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fiori_key>).
      " For delete, we only need the primary key!
      DATA(ls_travel) = VALUE y185m_travel(
          travel_id = <fiori_key>-TravelId
      ).
      APPEND ls_travel TO lcl_buffer=>gt_travel_delete.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

*" ----------------------------------------------------------------------
*" STEP 3: The Saver Class (Save Phase)
*" ----------------------------------------------------------------------
CLASS lsc_Y185_I_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_Y185_I_TRAVEL IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " 1. Execute Creates
    IF lcl_buffer=>gt_travel_create IS NOT INITIAL.
      INSERT y185m_travel FROM TABLE @lcl_buffer=>gt_travel_create.
    ENDIF.

    " 2. Execute Updates
    IF lcl_buffer=>gt_travel_update IS NOT INITIAL.
      MODIFY y185m_travel FROM TABLE @lcl_buffer=>gt_travel_update.
    ENDIF.

    " 3. Execute Deletes
    IF lcl_buffer=>gt_travel_delete IS NOT INITIAL.
      DELETE y185m_travel FROM TABLE @lcl_buffer=>gt_travel_delete.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    " Clear ALL buffers to prevent duplicate actions
    CLEAR: lcl_buffer=>gt_travel_create,
           lcl_buffer=>gt_travel_update,
           lcl_buffer=>gt_travel_delete.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
