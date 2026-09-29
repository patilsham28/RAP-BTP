@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Of Item Table'
define view entity y185_I_So_Item as select from y185m_so_item
association to parent y185_I_So_Header01 as _Header
on $projection.SoId = _Header.Soid
{
    key so_id as SoId,
    key item_id as ItemId,
    material as Material,
    quantity as Quantity,
    @Semantics.amount.currencyCode: 'Currency'
    net_price as NetPrice,
    @Semantics.amount.currencyCode: 'Currency'
    total_price as TotalPrice,
    _Header,
    
     _Header.Currency as Currency
}
