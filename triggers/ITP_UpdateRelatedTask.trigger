trigger ITP_UpdateRelatedTask on BMCServiceDesk__Incident__c (after update) {
    
    BMCServiceDesk__Incident__c[] incOld = trigger.old;
    BMCServiceDesk__Incident__c[] incNew = trigger.new;
    Set<Id> incId = new Set<Id>();
    Set<Id> inc1Id = new Set<Id>();

    List<BMCServiceDesk__Status__c> statusId = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name =: incNew[0].ITP_TaskUpdate__c
                                                 AND BMCServiceDesk__appliesToTask__c = true];

    If (incOld[0].ITP_IMRNum__c == null && incNew[0].ITP_IMRNum__c != null && incOld[0].ITP_IMRDesc__c == null && incNew[0].ITP_IMRDesc__c != null) {for (BMCServiceDesk__Incident__c incNew1 : trigger.new) {incId.add(incNew1.Id);List<BMCServiceDesk__Task__c> relTskUpd = new List<BMCServiceDesk__Task__c>();relTskUpd.add(new BMCServiceDesk__Task__c(Id = [SELECT Id FROM BMCServiceDesk__Task__c WHERE BMCServiceDesk__FKIncident__c IN: incId LIMIT 1].Id,IMR__c = incNew1.ITP_IMRNum__c,IMR_Detail__c = incNew1.ITP_IMRDesc__c));update relTskUpd;}} 
       If (incNew[0].ITP_TaskUpdate__c != incOld[0].ITP_TaskUpdate__c && incNew[0].ITP_TaskUpdate__c != null){for (BMCServiceDesk__Incident__c incNew2 : trigger.new) {inc1Id.add(incNew2.Id);List<BMCServiceDesk__Task__c> relTskUpd2 = new List<BMCServiceDesk__Task__c>();relTskUpd2.add(new BMCServiceDesk__Task__c(Id = [SELECT Id FROM BMCServiceDesk__Task__c WHERE BMCServiceDesk__FKIncident__c IN: inc1Id LIMIT 1].Id,BMCServiceDesk__FKStatus__c = statusId[0].Id));update relTskUpd2;}
      }  
    }