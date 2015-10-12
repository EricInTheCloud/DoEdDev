@IsTest
Private class Test_DOED_Update_Task_Ass_On_Delete
{
    static testMethod void validateIncidentQueue()
    {
        
        String userName = UserInfo.getUserName();
        User activeUser = [Select Id, Name, Email From User where Username = : userName limit 1];
        String userNm = activeUser.Name;
        
        String userId = activeUser.Id;

         //Create Urgency
        BMCServiceDesk__Urgency__c urgency = new BMCServiceDesk__Urgency__c(Name = 'Test_sbti_HIGH');
        insert urgency;
        
        //Create Category
        BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c(BMCServiceDesk__FKUrgency__c = urgency.Id, Name = 'Test_sbti_New Category', BMCServiceDesk__AvailableForIncidents__c=true);
        insert cat;
        
        //Create Status
        BMCServiceDesk__Status__c status1 = new BMCServiceDesk__Status__c(
                                            Name = 'SUBMITTED_1',  
                                            BMCServiceDesk__appliesToTask__c = true,
                                            
                                            BMCServiceDesk__state__c=true);
        insert status1;
        
         //Create Status
        BMCServiceDesk__Status__c status2 = new BMCServiceDesk__Status__c(
                                            Name = 'SUBMITTED_2',  
                                           
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__state__c=true);
        insert status2;
        
        //Create Status
        BMCServiceDesk__Status__c ca_email_sent_status = new BMCServiceDesk__Status__c(
                                            Name = 'Email Sent',  
                                           
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__state__c=true);
        insert ca_email_sent_status;
        
        //Create Status
        BMCServiceDesk__Status__c ca_email_received_status = new BMCServiceDesk__Status__c(
                                            Name = 'Email Received',  
                                           
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__state__c=true);
        insert ca_email_received_status;
        
        
        
        Test.startTest();
         //Create Incident
        BMCServiceDesk__Incident__c oInci = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status2.Id,
                BMCServiceDesk__State__c=true
                );
        insert oInci;
        
        //Create task
        BMCServiceDesk__Task__c oInc = new BMCServiceDesk__Task__c( //BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                //BMCServiceDesk__FKCategory__c = cat.Id,
                //BMCServiceDesk__openDateTime__c = System.now(),
                BMCServiceDesk__FKIncident__c = oInci.Id, 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true
                //BMCServiceDesk__EmailServiceAddress__c = userEmail1
                );
        insert oInc;
        
        
        
        delete oInc;     
        Test.stopTest();
    }    
}