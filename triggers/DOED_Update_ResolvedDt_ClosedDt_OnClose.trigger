trigger DOED_Update_ResolvedDt_ClosedDt_OnClose on Status_Time_Tracker__c (before insert) 
{
    Long timediff;
    for(Status_Time_Tracker__c stt : Trigger.new)
    {
        if(stt.Status_ID__c == 'CLOSED'){List<Status_Time_Tracker__c> statustracker_to_update = [select Id,Incident__c,Status__c,Start_Date_Time__c,End_Date_Time__c from Status_Time_Tracker__c where Incident__c =: stt.Incident__c and Status_ID__c = 'RESOLVED' order by Start_Date_Time__c DESC limit 1];if(!statustracker_to_update.isEmpty()){for(Status_Time_Tracker__c wo : statustracker_to_update ){stt.Resolved_Date__c = wo.End_Date_Time__c;stt.Closed_Date__c = System.now();timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(wo.End_Date_Time__c,System.now());stt.Time_Taken_in_Seconds__c = timediff;}}}    
    }        
}