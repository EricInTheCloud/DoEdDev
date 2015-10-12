trigger DOED_Create_Task_Attachments_From_Incident on Attachment (after insert) 
{

    Long cnt=0;
    Id incid;
    Set<Id> parentIds = new Set<Id>();
    
    for (Attachment a : trigger.new)
    {
        //Check to see if the Attachment has a Incident as the Parent Record
        String parentIdString = String.valueof(a.parentId);
        incid = a.parentId;
        parentIds.add(a.parentId); 
        if(parentIdString.substring(0,3) == 'a1T')
        {
            List<BMCServiceDesk__Task__c> task = [select Id,BMCServiceDesk__FKIncident__c from BMCServiceDesk__Task__c where BMCServiceDesk__FKIncident__c =: a.parentId];      
            if(!task.isEmpty())
            {
                  for(BMCServiceDesk__Task__c wo : task) 
                  {
                       //Select the Attachment body (it isn't in memory for an update)
                       Attachment body = [SELECT Body FROM Attachment WHERE Id = :a.Id];
                         
                       Attachment newA = New Attachment
                       (
                            Name = a.Name,
                            Body = body.Body,
                            ContentType = a.ContentType,
                            Description = a.Description,
                            OwnerId = a.OwnerId,
                            ParentId = wo.Id
                       );
                        
                        //Insert the new Attachment
                        insert newA;                                      
                  }
            }                                    
        }        
    }
    
                   
}