@IsTest
Private class TestIncidentCreateOnIncidentQueue1and2{

    static testMethod void validateIncidentQueue(){
        
        String userName = UserInfo.getUserName();
        User activeUser = [Select Id, Name, Email From User where Username = : userName limit 1];
        String userNm = activeUser.Name;
        String userEmail1 = 'bmcrf_emailcreateincident@1a6r383e9ggc0pvj7g0mj9u5gkvsdv3zudcgdhj0g4mzwv12qi.i-aehceai.il.apex.salesforce.com';
        String userEmail2 = 'emailcreateincident1@2ku073hyrqjr9ck17c6ltwtr1sxhi04u0fhhwwcn0qw7twmuzr.i-aehceai.na15.apex.salesforce.com';
        String userId = activeUser.Id;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ServiceDesk Staff']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser102345234@testorg.com');
        insert u;
            
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
                                            BMCServiceDesk__appliesToTask__c=true,
                                            BMCServiceDesk__state__c=true);
        insert status1;
        
        //Create Status
        BMCServiceDesk__Status__c status2 = new BMCServiceDesk__Status__c(
                                            Name = 'CLOSED',    
                                            BMCServiceDesk__appliesToIncident__c=true,
                                            BMCServiceDesk__appliesToTask__c=true,
                                            BMCServiceDesk__state__c=false);
        insert status2;
        
        //updated Status
        BMCServiceDesk__Status__c updated_status = new BMCServiceDesk__Status__c(
                                            Name = 'UPDATED',    
                                            BMCServiceDesk__appliesToIncident__c=true,
                                            BMCServiceDesk__appliesToTask__c=true,
                                            BMCServiceDesk__state__c=true);
        insert updated_status;
        
        //updated Status
        BMCServiceDesk__Status__c analyzed_status = new BMCServiceDesk__Status__c(
                                            Name = 'ANALYZED',    
                                            BMCServiceDesk__appliesToIncident__c=true,
                                            BMCServiceDesk__appliesToTask__c=true,
                                            BMCServiceDesk__state__c=true);
        insert analyzed_status;
        
        Test.startTest();
        //Create Incident
        BMCServiceDesk__Incident__c oInc = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true,
                //BMCServiceDesk__incidentDescription__c='test description',
                
                BMCServiceDesk__EmailServiceAddress__c = userEmail1);
        insert oInc;
        
        //System.assertNotEquals(null, oInc.Owner);
        
        //Create Incident
        /* BMCServiceDesk__Incident__c oInc1 = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true,
                //BMCServiceDesk__incidentDescription__c='test description',
                BMCServiceDesk__EmailServiceAddress__c = userEmail2);
        insert oInc1; */
        
        //System.assertNotEquals(null, oInc1.Owner);
        
        BMCServiceDesk__Task__c otask = new BMCServiceDesk__Task__c(
        BMCServiceDesk__taskDescription__c = '',
        BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true,
                BMCServiceDesk__FKIncident__c= oInc.Id
        );
        
        insert otask;
        
        otask.BMCServiceDesk__FKStatus__c = updated_status.id;
        otask.ownerid = u.id;
        update otask;
        
        BMCServiceDesk__Task__c otask1 = new BMCServiceDesk__Task__c(
        BMCServiceDesk__taskDescription__c = '',
        BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true,
                BMCServiceDesk__FKIncident__c= oInc.Id
        );
        
        insert otask1;
        
        otask1.BMCServiceDesk__FKStatus__c = analyzed_status.id;
        //otask1.ownerid = u.id;
        update otask1;
                
        Test.stopTest();
    }
}