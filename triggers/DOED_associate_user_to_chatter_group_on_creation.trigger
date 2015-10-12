trigger DOED_associate_user_to_chatter_group_on_creation on User (after insert) {
List<String> ca_chatter_groups = new List<String>();
for(User us : Trigger.new){
if(us.IsActive == true){
for (Cloudaction_Settings__c cs : [select Id, Name, Setting_Name__c, Setting_Value__c from Cloudaction_Settings__c where Setting_Name__c like 'ca_chatter_groups_%' order by Setting_Name__c asc]){
ca_chatter_groups.add(cs.Setting_Value__c);
}
CollaborationGroupMember[] cgm = new List<CollaborationGroupMember>();
for(String cg : ca_chatter_groups){
CollaborationGroupMember a = new CollaborationGroupMember(CollaborationGroupId = cg, MemberId = us.Id);
cgm.add(a);
}
if(cgm.size() > 0){
insert cgm;
}
}
}
}