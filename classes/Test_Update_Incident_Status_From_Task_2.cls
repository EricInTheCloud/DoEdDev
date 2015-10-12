@IsTest
Private class Test_Update_Incident_Status_From_Task_2
{
    static testMethod void validateIncidentQueue_closed()
    {
        Test.startTest();
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
                                            Name = 'SUBMITTED',  
                                            BMCServiceDesk__appliesToTask__c = true,
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__state__c=true);
        insert status1;
          
        //Create Status
        BMCServiceDesk__Status__c status3 = new BMCServiceDesk__Status__c(
                                            Name = 'ASSIGNED',  
                                           
                                            BMCServiceDesk__appliesToTask__c = true,
                                            BMCServiceDesk__state__c=true);
        insert status3;

        //testing for updating incident status from task for CLOSED and TASK TESOLVED
        
         //Create Incident
        BMCServiceDesk__Incident__c oInci_1 = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__State__c=true
                );
        insert oInci_1;
        
        //Create task
        BMCServiceDesk__Task__c oInc_1 = new BMCServiceDesk__Task__c( 
                BMCServiceDesk__FKClient__c = userId ,
             
                BMCServiceDesk__FKIncident__c = oInci_1.Id, 
                BMCServiceDesk__FKStatus__c = status1.Id,
                BMCServiceDesk__taskResolution__c = 'resolution',
                BMCServiceDesk__State__c=true            
                );
        insert oInc_1;
        
        User activeUser1 = [Select Id, Name, Email From User where alias like 'sba%' limit 1];       
        String userId1 = activeUser1.Id;
        
        oInc_1.BMCServiceDesk__FKStatus__c = status3.Id;
        oInc_1.ownerid = userId1;
        update oInc_1;

        Test.stopTest();
    }    
    
    }