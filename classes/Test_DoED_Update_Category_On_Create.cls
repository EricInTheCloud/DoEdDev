@IsTest
Private class Test_DoED_Update_Category_On_Create
{
    static testMethod void validateIncidentQueue()
    {
        Test.startTest();
        String userName = UserInfo.getUserName();
        User activeUser = [Select Id, Name, Email From User where Username = : userName limit 1];
        String userNm = activeUser.Name;
        
        String userId = activeUser.Id;
               
         //Create Status
        BMCServiceDesk__Status__c status2 = new BMCServiceDesk__Status__c(
                                            Name = 'SUBMITTED_2',  
                                           
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__state__c=true);
        insert status2;
        
       //Create Category
        BMCServiceDesk__Category__c cat = new BMCServiceDesk__Category__c( Name = 'Test_sbti_New Category', BMCServiceDesk__AvailableForIncidents__c=true);
        insert cat;

        //testing for updating incident status from task for CLOSED and TASK TESOLVED
        
         //Create Incident
        BMCServiceDesk__Incident__c oInci_1 = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status2.Id,
                //BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__State__c=true,
                BMCServiceDesk__contactType__c = 'Mail Listen',
                BMCServiceDesk__EmailServiceAddress__c = 'doed_edcapsuser@21l0od3zp6dokpamb1p237tz25jcm9lx72y1fywlib5awhq7a8.i-hduweaa.na15.apex.salesforce.com' 
                );
        insert oInci_1;
        
       
          //Create Incident
        BMCServiceDesk__Incident__c oInci_2 = new BMCServiceDesk__Incident__c( BMCServiceDesk__incidentDescription__c = 'Test_sbti_IncidentControllerTest', 
                BMCServiceDesk__FKClient__c = userId ,
                
                BMCServiceDesk__openDateTime__c = System.now(), 
                BMCServiceDesk__FKStatus__c = status2.Id,
                BMCServiceDesk__State__c=true,
                //BMCServiceDesk__FKCategory__c = cat.Id,
                BMCServiceDesk__contactType__c = 'Mail Listen',
                BMCServiceDesk__EmailServiceAddress__c = 'doed_edcapshelpdesk@m-1pahrtrsq2vuouurfciz166q5i6s5otqwlfo9ne6ektvyym7en.i-hduweaa.na15.apex.salesforce.com' 
                );
        insert oInci_2;       
                
                       
        
             
        Test.stopTest();
    }    
}