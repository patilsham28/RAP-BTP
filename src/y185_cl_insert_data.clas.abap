CLASS y185_cl_insert_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS y185_cl_insert_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA it_header TYPE TABLE OF y185m_so_header.
    DATA it_item TYPE TABLE OF y185m_so_item.

    it_header = VALUE #(

     (    soid       = 'SO100001'
          customer    = '10001'
          order_date  = '20260901'
          currency    = 'INR'
          creatd_by  = 'SHAM' )

        ( soid       = 'SO100002'
          customer    = '10002'
          order_date  = '20260902'
          currency    = 'INR'
          creatd_by  = 'SHAM' )

        ( soid       = 'SO100003'
          customer    = '10003'
          order_date  = '20260903'
          currency    = 'USD'
          creatd_by  = 'SHAM' )


    ).


it_item = VALUE #(

  ( item_id   = '0000000001'
    so_id     = 'SO100001'
    material  = 'MAT001'
    quantity  = '2'
    net_price = '150.00' )

  ( item_id   = '0000000002'
    so_id     = 'SO100001'
    material  = 'MAT002'
    quantity  = '5'
    net_price = '500.00' )

  ( item_id   = '0000000003'
    so_id     = 'SO100002'
    material  = 'MAT003'
    quantity  = '1'
    net_price = '250.00' )

  ( item_id   = '0000000004'
    so_id     = 'SO100002'
    material  = 'MAT004'
    quantity  = '3'
    net_price = '120.00' )

  ( item_id   = '0000000005'
    so_id     = 'SO100003'
    material  = 'MAT005'
    quantity = '10'
    net_price = '300.00' )

).


 INSERT y185m_so_header FROM TABLE @it_header.

    IF sy-subrc = 0.
      out->write( 'Header data inserted successfully.' ).
    ELSE.
      out->write( 'Error while inserting Header data.' ).
    ENDIF.




      INSERT y185m_so_item FROM TABLE @it_item.

    IF sy-subrc = 0.
      out->write( 'Item data inserted successfully.' ).
    ELSE.
      out->write( 'Error while inserting Item data.' ).
    ENDIF.

    COMMIT WORK AND WAIT.

  ENDMETHOD.
ENDCLASS.
