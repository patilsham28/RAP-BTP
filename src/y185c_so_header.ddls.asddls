@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Of Header Table'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity Y185C_SO_HEADER
  provider contract transactional_query
  as projection on y185_I_So_Header01
{

   key Soid,
   OrderDate,
   Customer,
   Currency,
   CreatdBy,
   @Semantics.amount.currencyCode: 'Currency'
      TotalAmount,
     @ObjectModel.text.element: ['Status_text']
      @UI.textArrangement: #TEXT_ONLY
      Status,
      
      StatusCriticality,
      @Semantics.text: true
      Status_text,
   /* Associations */
   _Item : redirected to composition child Y185C_SO_ITEM
}
