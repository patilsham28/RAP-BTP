@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View of Travel'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: {typeName: 'Travel Request', typeNamePlural: 'Travel Request' }
define root view entity y185C_Travel
  provider contract transactional_query as projection on y185_I_Travel
 
{

@UI.facet: [{ id:'Travel', purpose:#STANDARD, type:#IDENTIFICATION_REFERENCE, label: 'Travel Details', position: 10 }]

@EndUserText.label: 'TravelID'
@UI.lineItem: [{ position: 10 }]
@UI.identification: [{ position: 10 }]
    key TravelId,
    
    @EndUserText.label: 'EmployeeID'
    @UI.lineItem: [{ position: 20 }]
    @UI.identification: [{ position: 20 }]
    EmployeeId,
    
    @EndUserText.label: 'Destination'
    @UI.lineItem: [{ position: 30 }]
    @UI.identification: [{ position: 30 }]
    Destination,
    
    @EndUserText.label: 'Start Date'
    @UI.lineItem: [{ position: 40 }]
    @UI.identification: [{ position: 40 }]
    StartDate,
    
    @EndUserText.label: 'End Date'
    @UI.lineItem: [{ position: 50 }]
    @UI.identification: [{ position: 50 }]
    EndDate,
    
    @EndUserText.label: 'Status'
    @UI.lineItem: [{ position: 60 }]
    @UI.identification: [{ position: 60 }]
    Status
}
