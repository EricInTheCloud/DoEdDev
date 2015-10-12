trigger DOED_Update_CheckBox_From_Attachments on Attachment (before insert) {
List<BMCServiceDesk__Incident__c> co = [select id, DOED_Attachment_Added__c from BMCServiceDesk__Incident__c where id =: Trigger.New[0].ParentId and DOED_Attachment_Added__c = false];
                        if(co.size()>0)
                        {
                                    co[0].DOED_Attachment_Added__c = true;
                                    update co;
                        }        
}