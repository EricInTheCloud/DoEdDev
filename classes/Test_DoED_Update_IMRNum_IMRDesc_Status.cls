@IsTest
Private class Test_DoED_Update_IMRNum_IMRDesc_Status
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
        
        Cloudaction_Settings__c ab1 = new Cloudaction_Settings__c(Name='BMCServiceDesk__FKCategory__c', Description__c ='ca_email_sent_status', Detail__c ='ca_email_sent_status', Setting_Name__c='ca_email_sent_status', Setting_Value__c=ca_email_sent_status.id);
        insert ab1;
        
        Cloudaction_Settings__c ab2 = new Cloudaction_Settings__c(Name='BMCServiceDesk__FKCategory__c1', Description__c ='ca_email_received_status', Detail__c ='ca_email_received_status', Setting_Name__c='ca_email_received_status', Setting_Value__c=ca_email_received_status.id);
        insert ab2;
        
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
        
        //System.assertNotEquals(null, oInc.Owner);
        //System.assertNotEquals(null, oInc1.Owner);
        
        //Create Action
        BMCServiceDesk__Action__c action = new BMCServiceDesk__Action__c(
                                            Name = 'Email Received',  
                                            BMCServiceDesk__appliesToIncident__c = true,
                                            BMCServiceDesk__inactive__c = false);
        insert action;
        
        String history_description = 'Email Received-Re: Sandbox: Task##' + oInc.Name + '## has been opened and assigned to test 1 Edcaps (Ref:IN:' + oInci.Name + ')';
        
        String notes_data = 'From:gbsai6@gmail.com To:edcaps.reply.sandbox@outlook.com; Cc:Subject:Re: Sandbox: Task##00000286## has been opened and assigned to test 1 Edcaps (Ref:IN:00000576)On Tue, Jan 14, 2014 at 7:20 PM, EDCAPS Reply Sandbox <edcaps.reply.sandbox@outlook.com> wrote:';
        notes_data = notes_data + '> IMR Number##700000##' + '> IMR Description##IMR DESCRIPTION GOES HERE##> Task Update##IN PROGRESS## Resolution##RESOLUTION GOES HERE##';
        
        //create incident history
        BMCServiceDesk__IncidentHistory__c oInc1 = new BMCServiceDesk__IncidentHistory__c( 
                BMCServiceDesk__FKAction__c = action.Id,
                BMCServiceDesk__description__c = history_description,
                BMCServiceDesk__note__c = notes_data,
                BMCServiceDesk__EmailConversationData__c = 'From:bala.gopalakrishnan@sbti.com#@#@#@#To:sbtihelpdesk@outlook.com; #@#@#@#Cc:',
                BMCServiceDesk__FKIncident__c = oInci.Id,
                BMCServiceDesk__FKUser__c = userId
               
                );
        insert oInc1;
        
        String history_description1 = 'Email Received-Re: Sandbox: Task##' + oInc.Name + '## has been opened and assigned to test 1 Edcaps (Ref:IN:' + oInci.Name + ')';
        String history_description2 = 'Email Received-Re: Sandbox: ' + oInc.Name + '## has been opened and assigned to test 1 Edcaps (Ref:IN:' + oInci.Name + ')';

                
        String notes_data1 = 'From:gbsai6@gmail.com To:edcaps.reply.sandbox@outlook.com; Cc:Subject:Re: Sandbox: Task##00000286## has been opened and assigned to test 1 Edcaps (Ref:IN:00000576)On Tue, Jan 14, 2014 at 7:20 PM, EDCAPS Reply Sandbox <edcaps.reply.sandbox@outlook.com> wrote:';
        notes_data1 = notes_data1 + '> IMR Number##900000##' + '> IMR Description##IMR DESCRIPTION GOES HERE##> Task Update##CLOSED## Resolution##RESOLUTION GOES HERE##';
        
        //create incident history
        BMCServiceDesk__IncidentHistory__c oInc2 = new BMCServiceDesk__IncidentHistory__c( 
                BMCServiceDesk__FKAction__c = action.Id,
                BMCServiceDesk__description__c = history_description1,
                BMCServiceDesk__note__c = notes_data1,
                BMCServiceDesk__EmailConversationData__c = 'From:bala.gopalakrishnan@sbti.com#@#@#@#To:sbtihelpdesk@outlook.com; #@#@#@#Cc:',
                BMCServiceDesk__FKIncident__c = oInci.Id,
                BMCServiceDesk__FKUser__c = userId
               
                );
        insert oInc2;
        
        //create incident history
        BMCServiceDesk__IncidentHistory__c oInc3 = new BMCServiceDesk__IncidentHistory__c( 
                BMCServiceDesk__FKAction__c = action.Id,
                BMCServiceDesk__description__c = history_description2,
                BMCServiceDesk__note__c = notes_data1,
                BMCServiceDesk__EmailConversationData__c = 'From:bala.gopalakrishnan@sbti.com#@#@#@#To:sbtihelpdesk@outlook.com; #@#@#@#Cc:',
                BMCServiceDesk__FKIncident__c = oInci.Id,
                BMCServiceDesk__FKUser__c = userId
               
                );
        insert oInc3;
        
        Date a = null;
        Date b = null;
        
        String abc1 = CalculateBusinessTimeElapsed.calculateBusinessHMS(a,b);
        Long bc1 = CalculateBusinessTimeElapsed.calculateBusinessSeconds(a,b);
        Long cd1 = CalculateBusinessTimeElapsed.calculateBusinessHours(a,b);
        
        String abc = CalculateBusinessTimeElapsed.calculateBusinessHMS(System.now(),System.now());
        Long bc = CalculateBusinessTimeElapsed.calculateBusinessSeconds(System.now(),System.now());
        Long cd = CalculateBusinessTimeElapsed.calculateBusinessHours(System.now(),System.now());
        
        //delete oInc;     
        Test.stopTest();
    }    
}