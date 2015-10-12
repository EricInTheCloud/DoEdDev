@isTest 
private class ITP_UpdateRelatedTaskTestClass {
    static testMethod void validateITP_UpdateRelatedTask() {

  test.StartTest();
    List<User> usr = [SELECT Id FROM User];
   
        BMCServiceDesk__Status__c status = new BMCServiceDesk__Status__c (
        BMCServiceDesk__appliesToTask__c = true,
        Name = 'MYSTATUS');
        insert status;
        
        
        BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c (
        Name = 'TSTCAT',
        BMCServiceDesk__AvailableForServiceCatalog__c = true,
        BMCServiceDesk__AvailableForIncidents__c = true);
        insert cat;

          User CurrentUser=New User();
         CurrentUser=[select Id,Name from User where Id=: userinfo.getuserId()];

    
       BMCServiceDesk__Incident__c inc = new BMCServiceDesk__Incident__c (
       BMCServiceDesk__FKCategory__c = cat.Id,
       BMCServiceDesk__FKClient__c = CurrentUser.Id,
       ITP_IMRNum__C = Null,      
       ITP_TaskUpdate__c =Null
       );
       insert inc;
        
       BMCServiceDesk__Task__c tsk = new BMCServiceDesk__Task__c (
       BMCServiceDesk__FKClient__c = usr[0].Id,
       BMCServiceDesk__FKIncident__c = inc.Id);
       insert tsk;
        
       inc.ITP_TaskUpdate__c = 'MYSTATUS';       
       inc.ITP_IMRNum__C = '12345';
       inc.ITP_IMRDesc__c = 'My Description';

     
       
       update inc;
       test.StopTest();

    }
}