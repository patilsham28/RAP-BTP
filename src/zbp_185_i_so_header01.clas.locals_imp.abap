CLASS lhc_y185_i_so_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      keys FOR y185_I_So_Item~calculateTotalPrice.
    METHODS calculateHeaderTotal FOR DETERMINE ON MODIFY
      keys FOR y185_I_So_Item~calculateHeaderTotal.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR y185_I_So_Item RESULT result.

    METHODS copyItem FOR MODIFY
      keys FOR ACTION y185_I_So_Item~copyItem.

ENDCLASS.



CLASS lhc_y185_i_so_item IMPLEMENTATION.


METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD calculateTotalPrice.
  " 1. Read the Quantity and Net Price of the modified items
  READ ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
    ENTITY y185_I_So_Item
    FIELDS ( Quantity NetPrice )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_items).

  " 2. Calculate the new Total Price
  LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
    <item>-TotalPrice = <item>-Quantity * <item>-NetPrice.
  ENDLOOP.

  " 3. Update the entities with the calculated Total Price
  MODIFY ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
    ENTITY y185_I_So_Item
    UPDATE FIELDS ( TotalPrice )
    WITH VALUE #( FOR item IN lt_items (
                    %tky       = item-%tky
                    TotalPrice = item-TotalPrice
                ) ).
  ENDMETHOD.





  METHOD calculateHeaderTotal.

    " 1. Extract unique Sales Order IDs from the modified items
    DATA lt_header_keys TYPE TABLE FOR READ IMPORT y185_I_So_Header01.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      APPEND VALUE #( SoId = <key>-SoId ) TO lt_header_keys.
    ENDLOOP.

    SORT lt_header_keys BY SoId.
    DELETE ADJACENT DUPLICATES FROM lt_header_keys COMPARING SoId.

    " 2. Calculate the total for each affected Header
    LOOP AT lt_header_keys ASSIGNING FIELD-SYMBOL(<header_key>).

      " Read all items for this specific Sales Order
      READ ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
        ENTITY y185_I_So_Header01 BY \_Item
        FIELDS ( TotalPrice )
        WITH VALUE #( ( SoId = <header_key>-SoId ) )      " <--- FIX 1
        RESULT DATA(lt_items).

      " Sum the item totals
      DATA(lv_total_amount) = VALUE y185_net_price( ).

      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<item>).
        lv_total_amount = lv_total_amount + <item>-TotalPrice.
      ENDLOOP.

      " 3. Update the Header with the new Total Amount
      MODIFY ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
        ENTITY y185_I_So_Header01
        UPDATE FIELDS ( TotalAmount )
        WITH VALUE #( ( SoId        = <header_key>-SoId   " <--- FIX 2
                        TotalAmount = lv_total_amount ) ).

    ENDLOOP.

  ENDMETHOD.




METHOD copyItem.

    " 1. Read the data of the items selected for copying
    READ ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
      ENTITY y185_I_So_Item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_read_items).

    DATA lt_cba_item TYPE TABLE FOR CREATE y185_I_So_Header01\_Item.

    " 2. Build the payload to create a new item under the same Sales Order
    LOOP AT lt_read_items ASSIGNING FIELD-SYMBOL(<item>).
      APPEND VALUE #(
        SoId = <item>-SoId
        %target = VALUE #( (
            %cid     = keys[ sy-tabix ]-%cid   " Pass the RAP framework ID
            Material = <item>-Material
            Quantity = <item>-Quantity
            NetPrice = <item>-NetPrice
        ) )
      ) TO lt_cba_item.
    ENDLOOP.

    " 3. Create the new item using Create-By-Association
    MODIFY ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
      ENTITY y185_I_So_Header01
      CREATE BY \_Item
      FIELDS ( Material Quantity NetPrice )
      WITH lt_cba_item
      MAPPED DATA(ls_mapped)
      FAILED failed
      REPORTED reported.

    " 4. Map the newly created item to the action output so the UI refreshes
    mapped-y185_i_so_item = ls_mapped-y185_i_so_item.

  ENDMETHOD.

ENDCLASS.






CLASS lhc_y185_I_So_Header01 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR Header RESULT result.
    METHODS Validatecustomer FOR VALIDATE ON SAVE
      keys FOR Header~Validatecustomer.
    METHODS earlynumbering_create FOR NUMBERING
      entities FOR CREATE Header.

      METHODS earlynumbering_cba_item
  FOR NUMBERING
  entities FOR CREATE Y185_I_So_Header01\_Item.


ENDCLASS.






CLASS lhc_y185_I_So_Header01 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.



  DATA lv_next_number TYPE i.

  "Find the highest existing Sales Order number
  SELECT MAX( soid )
    FROM y185m_so_header
    INTO @DATA(lv_max_soid).

  IF lv_max_soid IS INITIAL.

    lv_next_number = 1.

  ELSE.

    DATA(lv_max_soid_clean) = CONV string( lv_max_soid ).

    CONDENSE lv_max_soid_clean NO-GAPS.

    lv_next_number = CONV i(
      substring(
        val = lv_max_soid_clean
        off = 2
      )
    ) + 1.

  ENDIF.

  "Generate number for every create request
  LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

    DATA(lv_soid) = CONV y185soid(
      |SO{ lv_next_number WIDTH = 6 ALIGN = RIGHT PAD = '0' }|
    ).

    APPEND VALUE #(
      %cid = <entity>-%cid
      soid = lv_soid
    ) TO mapped-Header.

    lv_next_number += 1.

  ENDLOOP.


  ENDMETHOD.


METHOD Validatecustomer.

  READ ENTITIES OF y185_I_So_Header01 IN LOCAL MODE
    ENTITY Header
    FIELDS ( Customer )
    WITH CORRESPONDING #( keys )
    RESULT DATA(it_header).

  LOOP AT it_header ASSIGNING FIELD-SYMBOL(<header>).

    IF <header>-Customer IS INITIAL.

      APPEND VALUE #(
        %tky = <header>-%tky
      ) TO failed-Header.

      APPEND VALUE #(
        %tky = <header>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Customer cannot be empty'
        )
        %element-Customer = if_abap_behv=>mk-on
      ) TO reported-Header.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

METHOD earlynumbering_cba_item.

  LOOP AT entities ASSIGNING FIELD-SYMBOL(<header>).

    SELECT MAX( item_id )
      FROM y185m_so_item
      WHERE so_id = @<header>-SoId
      INTO @DATA(lv_max_item).

    DATA(lv_next_item) = 1.

    IF lv_max_item IS NOT INITIAL.
      lv_next_item = CONV i( lv_max_item ) + 1.
    ENDIF.

    LOOP AT <header>-%target ASSIGNING FIELD-SYMBOL(<item>).

      DATA(ls_item) = <item>.

      ls_item-ItemId =
        |{ lv_next_item WIDTH = 10 ALIGN = RIGHT PAD = '0' }|.

      APPEND CORRESPONDING #( ls_item )
        TO mapped-y185_I_So_Item.

      lv_next_item += 1.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.
ENDCLASS.



