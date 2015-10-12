trigger ITP_UpdateIncidentStatus on BMCServiceDesk__Task__c (after update) {
    
    Set<Id> incidentId = new Set<Id>();
    List<BMCServiceDesk__Status__c> statusId = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name = 'RESOLVED'
                                                 AND BMCServiceDesk__appliesToIncident__c = true];

    for (BMCServiceDesk__Task__c to : trigger.old) {
        IF (to.BMCServiceDesk__Status_ID__c != 'CLOSED') {
      for (BMCServiceDesk__Task__c t : trigger.new) {
        IF (t.BMCServiceDesk__Status_ID__c == 'CLOSED' && t.BMCServiceDesk__FKIncident__c != null){incidentId.add(t.BMCServiceDesk__FKIncident__c);List<BMCServiceDesk__Incident__c> incStatus = new List<BMCServiceDesk__Incident__c>();incStatus.add(new BMCServiceDesk__Incident__c(Id = [SELECT Id FROM BMCServiceDesk__Incident__c WHERE Id IN :incidentId LIMIT 1].Id,BMCServiceDesk__FKStatus__c = statusId[0].Id));update incStatus;}
      }  
    }
  }  
}