trigger DOED_Update_Resolution_Flag_After_Update on BMCServiceDesk__Task__c (before update) 
{
    for(BMCServiceDesk__Task__c tsk : Trigger.new)
    {
        if(String.isBlank(tsk.BMCServiceDesk__taskResolution__c))
        {
            if(tsk.BMCServiceDesk__state__c)
            {
                tsk.Is_Resolution_NULL__c = 'Yes';        
            }
        }
        else
        {
            if(tsk.BMCServiceDesk__state__c)
            {
                tsk.Is_Resolution_NULL__c = 'No'; 
            }
        }
    }
}