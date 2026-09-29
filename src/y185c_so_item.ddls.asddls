@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Of Item Table'
@Metadata.ignorePropagatedAnnotations: true


define view entity Y185C_SO_ITEM
  as projection on y185_I_So_Item
{
@UI.facet: [
  {
    id: 'ItemDetails',
    purpose: #STANDARD,
    type: #IDENTIFICATION_REFERENCE,
    position: 10,
    label: 'Item Details'
  }
]

@EndUserText.label: 'Unique Id'
@UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]

  key SoId,
  @EndUserText.label: 'Item ID'
@UI.lineItem: [{ position: 20 },{ type: #FOR_ACTION, dataAction: 'copyItem', label: 'Copy Item' }]
@UI.identification: [{ position: 20 }]
  key ItemId,
  @EndUserText.label: 'Material'
@UI.lineItem: [{ position: 30 }]
@UI.identification: [{ position: 30 }]
  Material,
  @EndUserText.label: 'Quantity'
@UI.lineItem: [{ position: 40 }]
@UI.identification: [{ position: 40 }]
  Quantity,
  @EndUserText.label: 'Net Price'
@UI.lineItem: [{ position: 50 }]
@UI.identification: [{ position: 50 }]
@Semantics.amount.currencyCode: 'Currency'
  NetPrice,
  @EndUserText.label: 'Total Price'
  @UI.lineItem: [{ position: 60 }]              
  @UI.identification: [{ position: 60 }]        
  @Semantics.amount.currencyCode: 'Currency'
  TotalPrice,
  
  @Consumption.valueHelpDefinition: [{ 
          entity: { name: 'I_Currency', element: 'Currency' } 
      }]
Currency,
  _Header : redirected to parent Y185C_SO_HEADER
  
}
