trigger DOED_Update_Durations_OnUpdate on BMCServiceDesk__Incident__c (before update) 
{
    Long assigned_timediff;
    Long resolved_timediff;
    Long closed_timediff;
    
    
    for(BMCServiceDesk__Incident__c inc : Trigger.new)
    {    
        BMCServiceDesk__Incident__c oldCase = Trigger.oldMap.get(inc.ID);
    
        if(inc.BMCServiceDesk__openDateTime__c != null && inc.BMCServiceDesk__FKStatus__c != null && inc.BMCServiceDesk__FKStatus__c <> oldCase.BMCServiceDesk__FKStatus__c && inc.BMCServiceDesk__Status_ID__c == 'ASSIGNED' && oldCase.BMCServiceDesk__Status_ID__c <> 'ASSIGNED'){assigned_timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(inc.BMCServiceDesk__openDateTime__c,System.now());inc.DOED_Assigned_Duration__c = assigned_timediff;inc.DOED_Assigned_Date_Time__c = System.now();}
        
        if(inc.DOED_Assigned_Date_Time__c != null && inc.BMCServiceDesk__FKStatus__c != null && inc.BMCServiceDesk__FKStatus__c <> oldCase.BMCServiceDesk__FKStatus__c && inc.BMCServiceDesk__Status_ID__c == 'RESOLVED' && oldCase.BMCServiceDesk__Status_ID__c <> 'RESOLVED'){resolved_timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(inc.DOED_Assigned_Date_Time__c,System.now());inc.DOED_Resolved_Duration__c = resolved_timediff;inc.DOED_Resolved_Date_Time__c = System.now();}
        
        if(inc.BMCServiceDesk__openDateTime__c != null && inc.DOED_Assigned_Date_Time__c != null && inc.BMCServiceDesk__FKStatus__c != null && inc.DOED_Assigned_Date_Time__c <> oldCase.DOED_Assigned_Date_Time__c){assigned_timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(inc.BMCServiceDesk__openDateTime__c,inc.DOED_Assigned_Date_Time__c);inc.DOED_Assigned_Duration__c = assigned_timediff;}
        
        if(inc.DOED_Assigned_Date_Time__c != null && inc.DOED_Resolved_Date_Time__c != null && inc.BMCServiceDesk__FKStatus__c != null && inc.DOED_Resolved_Date_Time__c <> oldCase.DOED_Resolved_Date_Time__c){resolved_timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(inc.DOED_Assigned_Date_Time__c,inc.DOED_Resolved_Date_Time__c);inc.DOED_Resolved_Duration__c = resolved_timediff;}
        
        if(inc.BMCServiceDesk__closeDateTime__c != null && inc.DOED_Resolved_Date_Time__c != null && inc.BMCServiceDesk__FKStatus__c != null && inc.BMCServiceDesk__FKStatus__c <> oldCase.BMCServiceDesk__FKStatus__c && inc.BMCServiceDesk__Status_ID__c == 'CLOSED' && oldCase.BMCServiceDesk__Status_ID__c <> 'CLOSED'){closed_timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(inc.DOED_Resolved_Date_Time__c,inc.BMCServiceDesk__closeDateTime__c);inc.DOED_Closed_Duration__c = closed_timediff;}
        
        if(inc.BMCServiceDesk__firstCallResolution__c == true && inc.BMCServiceDesk__Status_ID__c == 'ASSIGNED'){inc.BMCServiceDesk__firstCallResolution__c = false;}              
    }
}