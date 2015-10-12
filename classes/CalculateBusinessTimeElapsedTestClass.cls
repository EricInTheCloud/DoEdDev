@IsTest
Private class CalculateBusinessTimeElapsedTestClass{

    static testMethod void validateBusinessTimeElapsed(){
        Test.startTest();
        String userName = UserInfo.getUserName();
        User activeUser = [Select Id, Name, Email From User where Username = : userName limit 1];
        String userNm = activeUser.Name;
        String userEmail = activeUser.Email;
        String userId = activeUser.Id;
        
        //Create Urgency
        BMCServiceDesk__Urgency__c urgency = new BMCServiceDesk__Urgency__c(Name = 'Test_sbti_HIGH');
        insert urgency;
        
        //Create Category
        BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c(BMCServiceDesk__FKUrgency__c = urgency.Id, Name = 'Test_sbti_New Category', BMCServiceDesk__AvailableForIncidents__c=true);
        insert cat;
        
        //Create Status
        BMCServiceDesk__Status__c status1 = new BMCServiceDesk__Status__c(
                                            Name = 'OPEN',  
                                            BMCServiceDesk__appliesToIncident__c=true,
                                            BMCServiceDesk__state__c=true);
        insert status1;
        
        //Create Status
        BMCServiceDesk__Status__c status2 = new BMCServiceDesk__Status__c(
                                            Name = 'CLOSED',    
                                            BMCServiceDesk__appliesToIncident__c=true,
                                            BMCServiceDesk__state__c=false);
        insert status2;
        
        //Create Incident
        BMCServiceDesk__Incident__c oInc = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true);
        insert oInc;
        
        //Update Incident->Responded Date
        oInc.BMCServiceDesk__respondedDateTime__c = System.now().addDays(1);
        update oInc;
    
        BMCServiceDesk__Incident__c updInc = [Select BMCServiceDesk__openDateTime__c,BMCServiceDesk__respondedDateTime__c,BMCServiceDesk__incidentDescription__c from BMCServiceDesk__Incident__c where id =: oInc.Id];
        
        Long timediff = 0;
        String string_output;
        
        timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(NULL,NULL);
        updInc.BMCServiceDesk__incidentDescription__c = String.valueOf(timediff);
        update updInc; 
        
        timediff = CalculateBusinessTimeElapsed.calculateBusinessSeconds(updInc.BMCServiceDesk__openDateTime__c,System.now().addDays(1));
        updInc.BMCServiceDesk__incidentDescription__c = String.valueOf(timediff);
        update updInc;               
        
        timediff = CalculateBusinessTimeElapsed.calculateBusinessHours(NULL,NULL);
        updInc.BMCServiceDesk__incidentDescription__c = String.valueOf(timediff);
        update updInc; 
        
        timediff = CalculateBusinessTimeElapsed.calculateBusinessHours(updInc.BMCServiceDesk__openDateTime__c,System.now().addDays(1));
        updInc.BMCServiceDesk__incidentDescription__c = String.valueOf(timediff);
        update updInc;
        
        
        string_output = CalculateBusinessTimeElapsed.calculateBusinessHMS(updInc.BMCServiceDesk__openDateTime__c,System.now().addDays(1));
        updInc.BMCServiceDesk__incidentDescription__c = string_output;
        update updInc; 
        
        System.assertNotEquals(null, updInc.BMCServiceDesk__incidentDescription__c);
                
        
        
        Test.stopTest();
    }
}