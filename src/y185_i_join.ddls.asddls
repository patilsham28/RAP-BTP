@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Join in Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity y185_I_join as select from y185m_so_header as h join y185m_so_item as i on h.soid = i.so_id 
{
    h.customer,
    h.order_date,
    h.currency,
  
    i.material
    
}
