@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Of Travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity y185_I_Travel as select from y185m_travel as Travel

{
    key travel_id as TravelId,
    employee_id as EmployeeId,
    destination as Destination,
    start_date as StartDate,
    end_date as EndDate,
    status as Status
    
    }
   
