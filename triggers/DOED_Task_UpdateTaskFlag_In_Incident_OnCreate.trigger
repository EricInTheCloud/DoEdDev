trigger DOED_Task_UpdateTaskFlag_In_Incident_OnCreate on BMCServiceDesk__Task__c (after insert) 
{
    String task_assignees = '';
    for(BMCServiceDesk__Task__c tsk : Trigger.new)
    {
    
        List<BMCServiceDesk__Task__c> task = [select Id,ownerid,DOED_Owner_Name_User__c,BMCServiceDesk__Queue__c, BMCServiceDesk__FKOpenBy__c from BMCServiceDesk__Task__c where BMCServiceDesk__FKIncident__c =: tsk.BMCServiceDesk__FKIncident__c];      
        if(!task.isEmpty())
        {
            for(BMCServiceDesk__Task__c tskins : task) 
            {  
                if(task_assignees == '')
                {
                    if(String.isBlank(tskins.BMCServiceDesk__Queue__c))
                    {
                        task_assignees = tskins.DOED_Owner_Name_User__c;
                    }
                    if(String.isBlank(tskins.DOED_Owner_Name_User__c))
                    {
                        task_assignees = tskins.BMCServiceDesk__Queue__c + CA_Helper_Functions.returnstaffname(tskins.BMCServiceDesk__FKOpenBy__c);
                    }
                }
                else
                {
                    if(String.isBlank(tskins.BMCServiceDesk__Queue__c))
                    {
                        task_assignees = task_assignees + ' / ' + tskins.DOED_Owner_Name_User__c;
                    }
                    if(String.isBlank(tskins.DOED_Owner_Name_User__c))
                    {
                        task_assignees = task_assignees + ' / ' + tskins.BMCServiceDesk__Queue__c + CA_Helper_Functions.returnstaffname(tskins.BMCServiceDesk__FKOpenBy__c);
                    }
                }      
            }    
        }              
                
            List<BMCServiceDesk__Incident__c> incident = [select Id,Task_Assigned__c,DOED_Task_Assignees__c,BMCServiceDesk__firstCallResolution__c from BMCServiceDesk__Incident__c where Id =: tsk.BMCServiceDesk__FKIncident__c limit 1];      
            if(!incident.isEmpty())
            {
                for(BMCServiceDesk__Incident__c inc : incident ) 
                {  
                    if(String.isNotBlank(tsk.BMCServiceDesk__FKIncident__c))
                    {
                        inc.Task_Assigned__c = true;      
                    }
                    inc.DOED_Task_Assignees__c = task_assignees;
                    inc.BMCServiceDesk__firstCallResolution__c = false;
                    String ca_assigned = 'ASSIGNED';
                    List<BMCServiceDesk__Status__c> status_query = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name =: ca_assigned AND BMCServiceDesk__appliesToIncident__c = true AND BMCServiceDesk__inactive__c = false limit 1];      
                    if(!status_query.isEmpty())
                    {
                         for(BMCServiceDesk__Status__c wo : status_query) 
                         {
                            inc.BMCServiceDesk__FKStatus__c = wo.Id;                         
                         }            
                    }   
                }
                update incident;
            }            
    }
}