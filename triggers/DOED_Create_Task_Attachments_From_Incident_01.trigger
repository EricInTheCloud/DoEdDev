trigger DOED_Create_Task_Attachments_From_Incident_01 on BMCServiceDesk__Task__c (after insert) 
{
    for(BMCServiceDesk__Task__c task : trigger.new)
    {
        if(String.isBlank(task.BMCServiceDesk__FKIncident__c))
        {
                    
        }
        else
        {
            if(task.BMCServiceDesk__state__c == true)
            {
                List<Attachment> att = [SELECT Id,Body,Name,ContentType,Description,OwnerId FROM Attachment WHERE ParentId =: task.BMCServiceDesk__FKIncident__c];      
                if(!att.isEmpty())
                {
                    for(Attachment wo : att){Attachment body = [SELECT Body FROM Attachment WHERE Id =: wo.Id];Attachment newA = New Attachment(Name = wo.Name,Body = body.Body,ContentType = wo.ContentType,Description = wo.Description,OwnerId = wo.OwnerId,ParentId = task.Id);insert newA;}  
                }
            }            
        }
    }        
}