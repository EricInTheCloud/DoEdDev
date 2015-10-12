trigger DOED_UpdateIncidentStatus_Resolution on BMCServiceDesk__Task__c (after update) 
{

    String task_assignees = '';

    for(BMCServiceDesk__Task__c old_task : trigger.old) 
    {
        If(old_task.BMCServiceDesk__Status_ID__c != 'CLOSED' && old_task.BMCServiceDesk__Status_ID__c != 'TASK RESOLVED') 
        {
             for(BMCServiceDesk__Task__c new_task : trigger.new) 
             {
                  If(new_task.BMCServiceDesk__Status_ID__c == 'UPDATED' || new_task.BMCServiceDesk__Status_ID__c == 'TASK RESOLVED')
                  {
                      List<BMCServiceDesk__Incident__c> inc1 = [SELECT Id,BMCServiceDesk__FKStatus__c,BMCServiceDesk__incidentResolution__c FROM BMCServiceDesk__Incident__c WHERE Id =: new_task.BMCServiceDesk__FKIncident__c AND BMCServiceDesk__state__c = true limit 1];      
                      if(!inc1.isEmpty())
                      {
                          for(BMCServiceDesk__Incident__c wo2 : inc1) 
                          {  
                              wo2.BMCServiceDesk__incidentResolution__c = new_task.BMCServiceDesk__taskResolution__c;             
                          }
                          update inc1;  
                      }
                      if(new_task.BMCServiceDesk__Status_ID__c == 'TASK RESOLVED')
                      {
                          List<BMCServiceDesk__Status__c> status_query1 = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name = 'RESOLVED' AND BMCServiceDesk__appliesToIncident__c = true AND BMCServiceDesk__inactive__c = false limit 1];
                          if(!status_query1.isEmpty())
                          {
                              for(BMCServiceDesk__Status__c wox : status_query1) 
                              {
                                  List<BMCServiceDesk__Incident__c> incx = [SELECT Id,BMCServiceDesk__FKStatus__c,BMCServiceDesk__incidentResolution__c FROM BMCServiceDesk__Incident__c WHERE Id =: new_task.BMCServiceDesk__FKIncident__c AND BMCServiceDesk__state__c = true limit 1];
                                  if(!incx.isEmpty())
                                  {
                                      for(BMCServiceDesk__Incident__c woy : incx) 
                                      {
                                          woy.BMCServiceDesk__FKStatus__c = wox.Id;    
                                      }
                                      update incx;
                                  }
                              }     
                          }    
                      }                            
                  }
                  else
                  {
                      If((new_task.BMCServiceDesk__Status_ID__c == 'ANALYZED' || new_task.BMCServiceDesk__Status_ID__c == 'ASSIGNED' || new_task.BMCServiceDesk__Status_ID__c == 'IN PROGRESS' || new_task.BMCServiceDesk__Status_ID__c == 'SUBMITTED' || new_task.BMCServiceDesk__Status_ID__c == 'CLOSED') && new_task.BMCServiceDesk__FKIncident__c != null) 
                      {
                          List<BMCServiceDesk__Status__c> status_query = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name =: new_task.BMCServiceDesk__Status_ID__c AND BMCServiceDesk__appliesToIncident__c = true AND BMCServiceDesk__inactive__c = false limit 1];      
                          if(!status_query.isEmpty())
                          {
                              for(BMCServiceDesk__Status__c wo : status_query) 
                              {  
                                  List<BMCServiceDesk__Incident__c> inc = [SELECT Id,BMCServiceDesk__FKStatus__c,BMCServiceDesk__incidentResolution__c FROM BMCServiceDesk__Incident__c WHERE Id =: new_task.BMCServiceDesk__FKIncident__c AND BMCServiceDesk__state__c = true limit 1];      
                                  if(!inc.isEmpty())
                                  {
                                      for(BMCServiceDesk__Incident__c wo1 : inc) 
                                      {  
                                          if(new_task.BMCServiceDesk__Status_ID__c <> 'CLOSED')
                                          {
                                              wo1.BMCServiceDesk__FKStatus__c = wo.Id;
                                          }
                                          wo1.BMCServiceDesk__incidentResolution__c = new_task.BMCServiceDesk__taskResolution__c;                 
                                      }
                                      update inc;  
                                  }                   
                              }  
                          }    
                      }                      
                  }
                  
                  if(new_task.DOED_Owner_Name_User__c <> old_task.DOED_Owner_Name_User__c || new_task.BMCServiceDesk__Queue__c <> old_task.BMCServiceDesk__Queue__c || new_task.BMCServiceDesk__FKOpenBy__c <> old_task.BMCServiceDesk__FKOpenBy__c)
                  {
                       List<BMCServiceDesk__Task__c> task = [select Id,ownerid,DOED_Owner_Name_User__c,BMCServiceDesk__Queue__c, BMCServiceDesk__FKOpenBy__c from BMCServiceDesk__Task__c where BMCServiceDesk__FKIncident__c =: new_task.BMCServiceDesk__FKIncident__c];      
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
                               
                    
                        List<BMCServiceDesk__Incident__c> incident = [select Id,DOED_Task_Assignees__c from BMCServiceDesk__Incident__c where Id =: new_task.BMCServiceDesk__FKIncident__c limit 1];      
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
        }        
    }
  
   
}