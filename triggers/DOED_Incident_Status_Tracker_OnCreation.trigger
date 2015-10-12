trigger DOED_Incident_Status_Tracker_OnCreation on BMCServiceDesk__Incident__c (after insert) 
{
    Long timediff;
    
    for(BMCServiceDesk__Incident__c inc : Trigger.new)
    {
        Status_Time_Tracker__c sttr = new Status_Time_Tracker__c();
        sttr.Incident__c = inc.Id;
        sttr.Status__c = inc.BMCServiceDesk__FKStatus__c;
        sttr.Start_Date_Time__c = System.now();
        sttr.End_Date_Time__c = System.now();
        sttr.Status_ID__c = inc.BMCServiceDesk__Status_ID__c;
        sttr.Time_Taken_in_Seconds__c = 0;
        sttr.State_Open__c = inc.BMCServiceDesk__state__c;
        insert sttr;   
    }    
}