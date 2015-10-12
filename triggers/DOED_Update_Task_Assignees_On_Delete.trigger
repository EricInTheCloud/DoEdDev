trigger DOED_Update_Task_Assignees_On_Delete on BMCServiceDesk__Task__c (after delete) 
{
String task_assignees = '';
    for(BMCServiceDesk__Task__c opp : trigger.Old)
    {
        List<BMCServiceDesk__Task__c> task = [select Id,ownerid,DOED_Owner_Name_User__c,BMCServiceDesk__Queue__c, BMCServiceDesk__FKOpenBy__c from BMCServiceDesk__Task__c where BMCServiceDesk__FKIncident__c =: opp.BMCServiceDesk__FKIncident__c];      
                        if(!task.isEmpty()){for(BMCServiceDesk__Task__c tskins : task){if(task_assignees == ''){if(String.isBlank(tskins.BMCServiceDesk__Queue__c)){task_assignees = tskins.DOED_Owner_Name_User__c;}if(String.isBlank(tskins.DOED_Owner_Name_User__c)){task_assignees = tskins.BMCServiceDesk__Queue__c + CA_Helper_Functions.returnstaffname(tskins.BMCServiceDesk__FKOpenBy__c);}}else{if(String.isBlank(tskins.BMCServiceDesk__Queue__c)){task_assignees = task_assignees + ' / ' + tskins.DOED_Owner_Name_User__c;}if(String.isBlank(tskins.DOED_Owner_Name_User__c)){task_assignees = task_assignees + ' / ' + tskins.BMCServiceDesk__Queue__c + CA_Helper_Functions.returnstaffname(tskins.BMCServiceDesk__FKOpenBy__c);}}}}                              
                                                 
                        List<BMCServiceDesk__Incident__c> incident = [select Id,DOED_Task_Assignees__c from BMCServiceDesk__Incident__c where Id =: opp.BMCServiceDesk__FKIncident__c limit 1];      
                        if(!incident.isEmpty())
                        {
                            for(BMCServiceDesk__Incident__c inc : incident) 
                            {  
                                inc.DOED_Task_Assignees__c = task_assignees;
                            }
                            update incident;    
                        }  
    }
}