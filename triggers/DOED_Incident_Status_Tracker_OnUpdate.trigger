trigger DOED_Incident_Status_Tracker_OnUpdate on BMCServiceDesk__Incident__c (before update) 
{
    
    Long timediff;
    decimal temp;
    
    for(BMCServiceDesk__Incident__c inc : Trigger.new)
    {        
        BMCServiceDesk__Incident__c oldCase = Trigger.oldMap.get(inc.ID);
        
        //Status got changed. Following will be done in the below code
        //1. Update the end date for the old status record in status tracker
        //2. Create a new record in status tracker    
        
        if(oldCase.BMCServiceDesk__FKStatus__c != inc.BMCServiceDesk__FKStatus__c && String.isNotBlank(oldCase.BMCServiceDesk__FKStatus__c) && String.isNotBlank(inc.BMCServiceDesk__FKStatus__c))
        {
            //1. Update the end date for the old status record in status tracker
            //   take the maximum date (most recent) for the old status record
            //Criteria : oldcase.status = timetracker_record.status AND maximum date (most recent)
            //select Id,Incident__c,Status__c,Start_Date_Time__c from Status_Time_Tracker__c where Incident__c = 'a1Ni0000000C2CeEAK' and Status__c = 'a23i0000000LbqVAAS' order by Start_Date_Time__c DESC limit 1                       
            List<Status_Time_Tracker__c> statustracker_to_update = [select Id,Incident__c,Status__c,Start_Date_Time__c,End_Date_Time__c from Status_Time_Tracker__c where Incident__c =: inc.Id and Status__c =: oldCase.BMCServiceDesk__FKStatus__c order by Start_Date_Time__c DESC limit 1];      
            if(!statustracker_to_update.isEmpty())
            {
                //update statustracker_to_update;   
                for(Status_Time_Tracker__c wo : statustracker_to_update ) 
                {  
                    wo.End_Date_Time__c = System.now();
                    wo.State_Open__c = inc.BMCServiceDesk__state__c;
                    timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(wo.Start_Date_Time__c,System.now());
                    wo.Time_Taken_in_Seconds__c = timediff; 
                }  
                update statustracker_to_update;              
            }
                        
            //2. Create a new record in status tracker 
            Status_Time_Tracker__c sttr = new Status_Time_Tracker__c();
            sttr.Incident__c = inc.Id;
            sttr.Status__c = inc.BMCServiceDesk__FKStatus__c;
            sttr.Start_Date_Time__c = System.now();
            sttr.End_Date_Time__c = System.now();
            sttr.Time_Taken_in_Seconds__c = 0;
            sttr.Status_ID__c = inc.BMCServiceDesk__Status_ID__c;
                        
            //get the correct state from the status form and update it in status tracker
            //SELECT Name,BMCServiceDesk__state__c FROM BMCServiceDesk__Status__c
            List<BMCServiceDesk__Status__c> status_to_query = [SELECT Name,BMCServiceDesk__state__c FROM BMCServiceDesk__Status__c where Id =: inc.BMCServiceDesk__FKStatus__c limit 1];      
            if(!status_to_query.isEmpty())
            {  
                for(BMCServiceDesk__Status__c wo1 : status_to_query) 
                {  
                    sttr.State_Open__c = wo1.BMCServiceDesk__state__c;     
                }              
            }  
            
            insert sttr;   
        }     
    }
}