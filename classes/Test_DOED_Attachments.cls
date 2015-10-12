@IsTest
Private class Test_DOED_Attachments
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
        
       Attachment attach=new Attachment();      
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.Description = 'v';
        attach.body=bodyBlob;
        attach.parentId=oInci_1.id;
        insert attach;
        
        
 //        List<Attachment> a = [select Id, Name, ContentType, Description, OwnerId from Attachment where Id ='00Pc0000000WaIuEAK'];      
 //           if(!a.isEmpty())
 //           {
         //Select the Attachment body (it isn't in memory for an update)
 //                      Attachment body = [SELECT Body FROM Attachment WHERE Id = '00Pc0000000WaIuEAK'];
                         
 //                      Attachment newA = New Attachment
 //                      (
 //                           Name = 'pastedGraphic.png',
  //                          Body = body.Body,
  //                          ContentType = 'image/jpeg',
  //                          Description = 'v',
   //                         OwnerId = '005i0000001kY0nAAE',
  //                          ParentId = oInci_1.Id
  //                     );
                        
                        //Insert the new Attachment
   //                     insert newA;    
   //         }
            
        Test.stopTest();
    }    
    }