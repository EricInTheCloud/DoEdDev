@IsTest(SeeAllData=true)
private class CA_Update_Incident_TestClass {
       
 static testMethod void validate_Update_IncidentCase1(){
      
     Test.startTest();
        
        // Create a new email, envelope object and Attachment
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEmail.Header emailheader = new Messaging.InboundEmail.Header();
       emailheader.name = 'v1';
       emailheader.value = 'v2';
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();       
    
       email.subject = 'yes (INC00003581) this is approved';
       email.plainTextBody = 'yes (INC00003581) this is test (Incident Number: Inc 00001856 fssdf sfd sdf';
       email.htmlBody = 'yes this is test (Incident Number: Inc 00001856 fssdf sfd sdf';
       env.fromAddress = 'test@gmail.com';
       String ca_toemail = 'miteshgiddia@gmail.com';
       String[] e_toAddress = new String[] {ca_toemail};
       email.toAddresses = e_toAddress;
       email.messageId = '12345';
     
      CA_Update_Incident abc = new CA_Update_Incident();
       abc.ca_reopen_closed_incident_client='Yes';
       abc.handleInboundEmail(email, env );
     Test.stopTest();
 }
 
 static testMethod void validate_Update_IncidentCase2(){
     Test.startTest();
        
        // Create a new email, envelope object and Attachment
       Messaging.InboundEmail email = new Messaging.InboundEmail();
       Messaging.InboundEmail.Header emailheader = new Messaging.InboundEmail.Header();
       emailheader.name = 'v1';
       emailheader.value = 'v2';
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();       
    
       email.subject = 'No (INC00003581)this is not approved';
       email.plainTextBody = 'No (INC00003581) this is nottest (Incident Number: Inc 00001856 fssdf sfd sdf';
       email.htmlBody = 'No this is nottest (Incident Number: Inc 00001856 fssdf sfd sdf';
       env.fromAddress = 'test@gmail.com';
       String ca_toemail = 'miteshgiddia@gmail.com';
       String[] e_toAddress = new String[] {ca_toemail};
       email.toAddresses = e_toAddress;
       email.messageId = '12345';
       
      CA_Update_Incident abc = new CA_Update_Incident();
      abc.ca_reopen_closed_incident_client='Yes';
     Document d1=new Document();
     	abc.d=d1;
   		abc.folderid=d1.ID;
       abc.handleInboundEmail(email, env );
     Test.stopTest();
 }
 
}