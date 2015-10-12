@isTest 
private class ITP_UpdateRelatedIncidentTestClass {
    static testMethod void validateITP_UpdateRelatedIncident() {

    
    List<User> usr = [SELECT Id FROM User];
   
        BMCServiceDesk__Status__c status = new BMCServiceDesk__Status__c (
        BMCServiceDesk__appliesToTask__c = true,
        BMCServiceDesk__appliesToIncident__c = true,
        Name = 'CLOSED');
        insert status;
        
        BMCServiceDesk__Status__c status1 = new BMCServiceDesk__Status__c (
        BMCServiceDesk__appliesToTask__c = true,
        BMCServiceDesk__appliesToIncident__c = true,
        Name = 'RESOLVED');
        insert status1;
                
        BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c (
        Name = 'TSTCAT',
        BMCServiceDesk__AvailableForServiceCatalog__c = true,
        BMCServiceDesk__AvailableForIncidents__c = true);
        insert cat;

       BMCServiceDesk__Incident__c inc = new BMCServiceDesk__Incident__c (
       
       BMCServiceDesk__FKCategory__c = cat.Id,
       BMCServiceDesk__FKClient__c = usr[0].Id);
       insert inc;
       
       BMCServiceDesk__Task__c tsk = new BMCServiceDesk__Task__c (
       BMCServiceDesk__FKClient__c = usr[0].Id,
       BMCServiceDesk__FKIncident__c = inc.Id);
       insert tsk;
       

       tsk.BMCServiceDesk__FKStatus__c = status1.Id;
       test.StartTest();
       update tsk;
       test.StopTest();

    }
}