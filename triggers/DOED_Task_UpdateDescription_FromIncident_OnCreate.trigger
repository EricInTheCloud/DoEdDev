trigger DOED_Task_UpdateDescription_FromIncident_OnCreate on BMCServiceDesk__Task__c (before insert) 
{
    for(BMCServiceDesk__Task__c tsk : Trigger.new)
    {        
            List<BMCServiceDesk__Incident__c> incident = [select Id,BMCServiceDesk__incidentDescription__c from BMCServiceDesk__Incident__c where Id =: tsk.BMCServiceDesk__FKIncident__c limit 1];      
            if(!incident.isEmpty())
            {
                for(BMCServiceDesk__Incident__c inc : incident ) 
                {  
                    if(String.isNotBlank(tsk.BMCServiceDesk__FKIncident__c) && String.isBlank(tsk.BMCServiceDesk__taskDescription__c))
                    {
                        tsk.BMCServiceDesk__taskDescription__c = inc.BMCServiceDesk__incidentDescription__c;    
                    }   
                }    
            }            
    }
}