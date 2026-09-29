@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Of Header Table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity y185_I_So_Header01 as select from y185m_so_header
composition [0..*] of y185_I_So_Item as _Item
{

    key soid as Soid,
    order_date as OrderDate,
    customer as Customer,
    currency as Currency,
    creatd_by as CreatdBy,
    @Semantics.amount.currencyCode: 'Currency'
      total_amount as TotalAmount,
            status as Status,
      
            case status
      when 'A' then 'Approved'
      when 'P' then 'Pending'
      when 'C' then 'Canceled'
      else ''
      end as Status_text,
      case status
        when 'A' then 3 
        when 'P'  then 2
        when 'C' then 1
        else 0
        
      end as StatusCriticality, 
      

    
    _Item
}
