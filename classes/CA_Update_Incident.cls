global class CA_Update_Incident implements Messaging.InboundEmailHandler 
{
    //Variables used to email data
    
    //Contains the email body
    Global String myPlainText = '';
    Global String myHTMLText = '';
    //Variable to identify if the Open and Close Delimeters are found for Description field
    Global String Match_Found = 'No';
    //Variable to identify if the Open and Close Delimeters are found for Priority field                                                  
    Global String Priority_Match_Found = 'No';
    //Variables used for extracting the start position of extraction content 
    Global Integer Open_Delimeter_Int;
    Global Integer Open_Delimeter_Int1;
    Global Integer Open_Delimeter_Int2;
    //Variable used for Inserting Incident
    Global sObject sInc;
    Global sObject sIncHis;
    Global sObject sInc_Not;
    Global List<String> SHI_Match_Found_Fields = new List<String>(); 
    Global String e_fromAddress = ''; //08_May_2015: Setting Variable to empty string
    Global String[] e_toAddress = new String[] {}; //08_May_2015: Setting Variable to empty list
    Global String[] e_ccAddress = new String[] {}; //08_May_2015: Setting Variable to empty list
    Global String e_toAddress_String = ''; //08_May_2015: Setting Variable to empty string
    Global String e_ccAddress_String = ''; //08_May_2015: Setting Variable to empty string
    Global String e_toAddress_All_String = '';
    Global String e_ccAddress_All_String = '';
    Global Boolean tr = Boolean.valueOf('true');
    Global String Fld_Category_Found = 'No';
    Global String Fld_Urgency_Found = 'No';
    Global String Fld_Impact_Found = 'No';
    Global String e_subject = ''; //08_May_2015: Setting Variable to empty string
    Global String[] e_references = new String[] {}; //08_May_2015: Setting Variable to empty list
    public Document d{get;set;}
    public ID folderid{get;set;}
    Global String CA_Image_URL_String = ''; //08_May_2015: Setting Variable to empty string
    Global Id ca_matched_incident_id;
    Global Id ca_matched_task_id;
    Global Boolean ca_matched_incident_state;
    Global Boolean ca_matched_task_state;
    Global String ca_reopen_closed_incident_client = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_reopen_closed_incident_all = ''; //08_May_2015: Setting Variable to empty string
    Global List<String> ca_reopen_closed_incident_user_emails = new List<String>();
    Global Set<Id> ca_client_ids = new Set<Id>();
    Global String ca_reopen_closed_incident_user_email_match = '';
    Global String ca_reassign_resolved_incident_to = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_reassign_resolved_incident_from = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_reassign_resolved_task_to = '';
    Global String ca_close_resolved_incident_to = '';
    Global String ca_close_resolved_task_to = '';
    Global String ca_close_task_to = '';
    Global String ca_approval_string = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_rejection_string = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_approval_decision = '';
    Global String ca_incident_can_be_updated = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_task_can_be_updated = ''; //08_May_2015: Setting Variable to empty string
    Global String ca_close_reopened_incident = '';
    Global String ca_close_reopened_incident_if_not_client_not_configured_users = '';
    Global String ca_incident_importance = 'nothing'; //08_May_2015: Setting Variable to empty string
    Global String ca_previous_status = '';
    Global String ca_previous_task_status = '';
    Global String ca_previous_status_match = '';
    Global String ca_task_resolution = '';
    Global Integer email_length_pt;
    Global Integer email_length_ht;
    Global String Urgency_Found_in_Subject_Body = 'No';
    Global String Impact_Found_in_Subject_Body = 'No';
    Global String sUrgencyId = ''; //08_May_2015: Setting Variable to empty string
    Global String sImpactId = ''; //08_May_2015: Setting Variable to empty string
    Global String myPlainTextSubject = ''; //08_May_2015: Setting Variable to empty string
    Global String myPlainTextBody = ''; //08_May_2015: Setting Variable to empty string
    Global Id ca_urgency_id;
    Global Id ca_impact_id;
    Global Id ca_client_id_from_email;
    Global Id ca_client_id_from_incident;
    Global Id ca_client_id_from_task;
    Global String ca_process_as_plain_text = 'No';
    Global String e_fromAddress_2 = '';
    Global String e_do_not_create_ticket = 'No';
    Global String Chk_Client = 'False';
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env)
    {
        // Create an inboundEmailResult object for returning 
        // the result of the Force.com Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        ca_reassign_resolved_incident_to = Ca_Utilities.getSettingValueByName('Reassign_Resolved_Incident_to');
        ca_reassign_resolved_task_to = Ca_Utilities.getSettingValueByName('Reassign_Resolved_Task_to');
        ca_reassign_resolved_incident_from = Ca_Utilities.getSettingValueByName('Reassign_Resolved_Incident_From');
        ca_close_resolved_incident_to = Ca_Utilities.getSettingValueByName('Close_Resolved_Incident_to');
        ca_close_resolved_task_to = Ca_Utilities.getSettingValueByName('Close_Resolved_Task_to');
        ca_close_task_to = Ca_Utilities.getSettingValueByName('Close_Task_to');
        ca_task_resolution = Ca_Utilities.getSettingValueByName('ca_task_resolution');
        //ca_task_resolution = 'Closed via Approval from the Client in Email';
       
        ca_approval_string = Ca_Utilities.getSettingValueByName('ca_approval_string');
        ca_rejection_string = Ca_Utilities.getSettingValueByName('ca_rejection_string');
        
        myPlainText = email.plainTextBody;
        myPlainText = (myPlainText == null ? '' : myPlainText);
        myPlainTextSubject = (email.subject == null ? '' : email.subject);
        
        
        If(String.isNotBlank(ca_approval_string) && String.isNotBlank(ca_rejection_string) && String.isNotBlank(myPlainTextSubject))
        {
            If(myPlainTextSubject.containsIgnoreCase(ca_approval_string) && myPlainTextSubject.length() > ca_approval_string.length())
            {
                if(myPlainTextSubject.substring(0,ca_approval_string.length()+1).containsIgnoreCase(ca_approval_string))
                {
                    ca_approval_decision = 'APPROVED';
                }
            }
            If(myPlainTextSubject.containsIgnoreCase(ca_rejection_string) && myPlainTextSubject.length() > ca_rejection_string.length())
            {
                if(myPlainTextSubject.substring(0,ca_rejection_string.length()+1).containsIgnoreCase(ca_rejection_string))
                {
                    ca_approval_decision = 'REJECTED';
                }
            }
        }
        
        If(String.isNotBlank(ca_approval_string) && String.isNotBlank(ca_rejection_string) && String.isNotBlank(myPlainText))
        {
            If(myPlainText.containsIgnoreCase(ca_approval_string) && myPlainText.length() > ca_approval_string.length())
            {
                if(myPlainText.substring(0,ca_approval_string.length()+1).containsIgnoreCase(ca_approval_string))
                {
                    ca_approval_decision = 'APPROVED';
                }
            }
            If(myPlainText.containsIgnoreCase(ca_rejection_string) && myPlainText.length() > ca_rejection_string.length())
            {
                if(myPlainText.substring(0,ca_rejection_string.length()+1).containsIgnoreCase(ca_rejection_string))
                {
                    ca_approval_decision = 'REJECTED';
                }
            }
        }
        
        //START : Pattern Matching in Email Subject
              String outpattern_1;
              Integer incident_number_length_1;
              Integer total_string_length_1;
              String str_pre_1;
              String str_post_1;
              Integer start_pos_1;
              Integer end_pos_1;
              Integer str_pre_1_length;
              Integer str_post_1_length;
              String sr_incident_1;
              List<String> ca_possible_incident_matches_1 = new List<String>();
              List<String> ca_possible_task_matches_1 = new List<String>();
              
              if(ca_matched_incident_id == null)
              {
              for (CA_Email_Reference_Pattern__c rp : [select Id, Name, CA_Incoming_Outgoing__c, Email_Pattern__c,CA_Order__c from CA_Email_Reference_Pattern__c order by CA_Order__c asc])
              {
                ca_possible_incident_matches_1.clear();
                outpattern_1 = rp.Email_Pattern__c;
                   system.debug('outpattern_1 is  ' + outpattern_1);
                incident_number_length_1 = outpattern_1.countMatches('x');
                system.debug('PRINTING INCIDENT NUMBER LENGTH (Subject Line): ' + incident_number_length_1);
                total_string_length_1 = outpattern_1.length();
                system.debug('PRINTING TOTAL STRING LENGTH (Subject Line): ' + total_string_length_1);
                start_pos_1 = outpattern_1.indexOfIgnoreCase('x');
                system.debug('PRINTING START POSITION (Subject Line): ' + start_pos_1);  
                if(start_pos_1 > 0)
                {
                    str_pre_1 = outpattern_1.substring(0,start_pos_1);
                    system.debug('PRINTING PRE STRING (Subject Line): ' + str_pre_1);
                    str_pre_1_length = str_pre_1.length();
                    system.debug('PRINTING PRE STRING LENGTH (Subject Line): ' + str_pre_1_length);
                    str_post_1 = outpattern_1.substring(str_pre_1_length+incident_number_length_1,total_string_length_1);
                    str_post_1_length = str_post_1.length();
                    system.debug('PRINTING POST STRING (Subject Line): ' + str_post_1);
                    system.debug('PRINTING POST STRING LENGTH (Subject Line): ' + str_post_1_length);
                    //sr_incident_1 = str_pre_1 + ca_incident_number + str_post_1;
                    
                        String i = myPlainTextSubject;
                        Integer a = i.indexOfIgnoreCase(str_pre_1);
                        
                        if(a != -1 && String.isNotBlank(str_post_1)){Integer b = i.indexOfIgnoreCase(str_pre_1);system.debug('Found the Incident Number in the Line (Subject Line): ' + i);Integer c = b + incident_number_length_1;If(c > i.length()) { c = i.length(); }system.debug('printing requested pattern (Subject Line): ' + outpattern_1);Integer d = c + 1;if(d > i.length()) { d = i.length(); }Integer e = b + 1;if(e > i.length()) { e = i.length(); }system.debug('printing the incident number (Subject Line): ' + i.substring(e,d));ca_possible_incident_matches_1.add(i.substring(e,d).trim().deleteWhitespace());}
                        
                        if(a != -1 && String.isBlank(str_post_1)){Integer b = i.indexOfIgnoreCase(str_pre_1);system.debug('Found the Incident Number in the Line (Subject Line)(no end delimeter): ' + i);Integer c = b + incident_number_length_1 + str_pre_1_length;If(c > i.length()) { c = i.length(); }system.debug('printing requested pattern (Subject Line)(no end delimeter): ' + outpattern_1);Integer e = b + 1;if(e > i.length()) { e = i.length(); }Integer f = b + str_pre_1_length;if(f > c) { f = c; }system.debug('printing the incident number (Subject Line)(no end delimeter): ' + i.substring(f,c));system.debug(i + ' str_pre_1: ' + str_pre_1 + ' str_pre_1_length: ' + str_pre_1_length + ' str_post_1: ' + str_post_1 + ' str_post_1_length: ' + str_post_1_length + ' incident_number_length_1:' + incident_number_length_1 + ' total_string_length_1: ' + total_string_length_1 + ' line length : ' + i.length() + ' value of e: ' + e + ' value of c: ' + c + ' value of b:' + b + ' value of f:' + f);ca_possible_incident_matches_1.add(i.substring(f,c).trim().deleteWhitespace());}                      
                }
                //print all the possible matches for present comparison
                system.debug('possible matches for pattern (Subject Line): ' + outpattern_1);
                Integer iu = 0;
                  
                  
                for(String pm : ca_possible_incident_matches_1) {
                    
                   
                    iu = iu + 1; system.debug(iu + ' ' + pm);    }
                
                //From the possible patterns find the Incident Number for which this email needs to be associated
                ///List<BMCServiceDesk__Incident__c> inps = [select id,name from BMCServiceDesk__Incident__c where name in : ca_possible_incident_matches_1 and BMCServiceDesk__state__c = true];
                List<BMCServiceDesk__Incident__c> inps = [select id,name,BMCServiceDesk__state__c,BMCServiceDesk__clientEmail__c,BMCServiceDesk__Status_ID__c, BMCServiceDesk__FKClient__c from BMCServiceDesk__Incident__c where name in : ca_possible_incident_matches_1];   
                for(BMCServiceDesk__Incident__c inp : inps)
                {
                    system.debug('INCIDENT NUMBER MATCH (Subject Line): ' + inp.name + ' (' + inp.id + ')');
                    ca_matched_incident_id = inp.id;
                    ca_matched_incident_state = inp.BMCServiceDesk__state__c;
                    ca_previous_status = inp.BMCServiceDesk__Status_ID__c;
                    ca_client_id_from_incident = inp.BMCServiceDesk__FKClient__c;
                    if(ca_reopen_closed_incident_client == 'Yes')
                    {
                        ca_reopen_closed_incident_client = inp.BMCServiceDesk__clientEmail__c.toUpperCase().trim();
                    }
                    break;
                }               
              }
              }  
            //END : Pattern Matching in Email Subject
            
            //Update Task - START
            for (CA_Email_Reference_Pattern__c rp : [select Id, Name, CA_Incoming_Outgoing__c, Email_Pattern__c,CA_Order__c from CA_Email_Reference_Pattern__c where Name like 'Task%' order by CA_Order__c asc])
              {
                ca_possible_task_matches_1.clear();
                outpattern_1 = rp.Email_Pattern__c;
                   system.debug('outpattern_1 is  ' + outpattern_1);
                incident_number_length_1 = outpattern_1.countMatches('x');
                system.debug('PRINTING INCIDENT NUMBER LENGTH (Subject Line): ' + incident_number_length_1);
                total_string_length_1 = outpattern_1.length();
                system.debug('PRINTING TOTAL STRING LENGTH (Subject Line): ' + total_string_length_1);
                start_pos_1 = outpattern_1.indexOfIgnoreCase('x');
                system.debug('PRINTING START POSITION (Subject Line): ' + start_pos_1);  
                if(start_pos_1 > 0)
                {
                    str_pre_1 = outpattern_1.substring(0,start_pos_1);
                    system.debug('PRINTING PRE STRING (Subject Line): ' + str_pre_1);
                    str_pre_1_length = str_pre_1.length();
                    system.debug('PRINTING PRE STRING LENGTH (Subject Line): ' + str_pre_1_length);
                    str_post_1 = outpattern_1.substring(str_pre_1_length+incident_number_length_1,total_string_length_1);
                    str_post_1_length = str_post_1.length();
                    system.debug('PRINTING POST STRING (Subject Line): ' + str_post_1);
                    system.debug('PRINTING POST STRING LENGTH (Subject Line): ' + str_post_1_length);
                    //sr_incident_1 = str_pre_1 + ca_incident_number + str_post_1;
                    
                        String i = myPlainTextSubject;
                        Integer a = i.indexOfIgnoreCase(str_pre_1);
                        
                        if(a != -1 && String.isNotBlank(str_post_1)){Integer b = i.indexOfIgnoreCase(str_pre_1);system.debug('Found the Incident Number in the Line (Subject Line): ' + i);Integer c = b + incident_number_length_1;If(c > i.length()) { c = i.length(); }system.debug('printing requested pattern (Subject Line): ' + outpattern_1);Integer d = c + 1;if(d > i.length()) { d = i.length(); }Integer e = b + 1;if(e > i.length()) { e = i.length(); }system.debug('printing the incident number (Subject Line): ' + i.substring(e,d));ca_possible_task_matches_1.add(i.substring(e,d).trim().deleteWhitespace());}
                        
                        if(a != -1 && String.isBlank(str_post_1)){Integer b = i.indexOfIgnoreCase(str_pre_1);system.debug('Found the Incident Number in the Line (Subject Line)(no end delimeter): ' + i);Integer c = b + incident_number_length_1 + str_pre_1_length;If(c > i.length()) { c = i.length(); }system.debug('printing requested pattern (Subject Line)(no end delimeter): ' + outpattern_1);Integer e = b + 1;if(e > i.length()) { e = i.length(); }Integer f = b + str_pre_1_length;if(f > c) { f = c; }system.debug('printing the incident number (Subject Line)(no end delimeter): ' + i.substring(f,c));system.debug(i + ' str_pre_1: ' + str_pre_1 + ' str_pre_1_length: ' + str_pre_1_length + ' str_post_1: ' + str_post_1 + ' str_post_1_length: ' + str_post_1_length + ' incident_number_length_1:' + incident_number_length_1 + ' total_string_length_1: ' + total_string_length_1 + ' line length : ' + i.length() + ' value of e: ' + e + ' value of c: ' + c + ' value of b:' + b + ' value of f:' + f);ca_possible_task_matches_1.add(i.substring(f,c).trim().deleteWhitespace());}                      
                }
                //print all the possible matches for present comparison
                system.debug('possible matches for pattern (Subject Line): ' + outpattern_1);
                Integer iu = 0;
                  
                  
                for(String pm : ca_possible_task_matches_1) {
                    
                   
                    iu = iu + 1; system.debug(iu + ' ' + pm);    }
                
                //From the possible patterns find the Incident Number for which this email needs to be associated
                ///List<BMCServiceDesk__Incident__c> inpts = [select id,name from BMCServiceDesk__Incident__c where name in : ca_possible_task_matches_1 and BMCServiceDesk__state__c = true];
                List<BMCServiceDesk__Task__c> inpts = [select id,name,BMCServiceDesk__state__c,BMCServiceDesk__Status_ID__c, BMCServiceDesk__FKClient__c from BMCServiceDesk__Task__c where name in : ca_possible_task_matches_1];   
                for(BMCServiceDesk__Task__c inp : inpts)
                {
                    system.debug('INCIDENT NUMBER MATCH (Subject Line): ' + inp.name + ' (' + inp.id + ')');
                    ca_matched_task_id = inp.id;
                    ca_matched_task_state = inp.BMCServiceDesk__state__c;
                    ca_previous_task_status = inp.BMCServiceDesk__Status_ID__c;
                    ca_client_id_from_task = inp.BMCServiceDesk__FKClient__c;
                    break;
                }               
              }
            //Update Task - END
            
            List<User> usr1 = new List<User>();
            Boolean client_isactive = true;
            usr1 = [select Id,Name,Username from User where Email = :email.fromAddress and isactive = :client_isactive];        //User from which the email is received
            if(usr1!=null && !usr1.isEmpty())
            {
                if(usr1.size() > 0)
                {
                    for(User u1 : usr1)
                    {
                        ca_client_id_from_email = u1.Id;
                        Chk_Client = 'True';
                        ca_client_ids.add(u1.Id);
                    }
                }
            }
            
            if(ca_matched_incident_id != null)  //Existing Incident - Open or Closed
            {
                    if(String.isNotBlank(ca_reassign_resolved_incident_to) && String.isNotBlank(ca_reassign_resolved_incident_from) && ca_matched_incident_state == true && String.isNotBlank(ca_approval_string) && String.isNotBlank(ca_rejection_string) && String.isNotBlank(ca_close_resolved_incident_to))
                    {
                        if(ca_previous_status == ca_reassign_resolved_incident_from)
                        {
                            //if(ca_client_id_from_email != null && ca_client_id_from_incident != null)
                            if(!ca_client_ids.isEmpty() && ca_client_id_from_incident != null)
                            {
                                //if(ca_client_id_from_email == ca_client_id_from_incident)
                                if(ca_client_ids.contains(ca_client_id_from_incident))
                                {if(ca_approval_decision == 'REJECTED'){List<BMCServiceDesk__Incident__c> inc_up = [select id,name,BMCServiceDesk__FKStatus__c from BMCServiceDesk__Incident__c where id =: ca_matched_incident_id limit 1];for(BMCServiceDesk__Incident__c inp : inc_up){Boolean applies_to_incident = true;Boolean is_inactive = false;for(BMCServiceDesk__Status__c st : [select id, Name, BMCServiceDesk__appliesToIncident__c, BMCServiceDesk__inactive__c FROM BMCServiceDesk__Status__c where Name =: ca_reassign_resolved_incident_to and BMCServiceDesk__appliesToIncident__c =: applies_to_incident and BMCServiceDesk__inactive__c =: is_inactive limit 1]){inp.BMCServiceDesk__FKStatus__c = st.id;ca_incident_can_be_updated = 'Yes';}}if(ca_incident_can_be_updated == 'Yes'){update inc_up;}}if(ca_approval_decision == 'APPROVED'){List<BMCServiceDesk__Incident__c> inc_up = [select id,name,BMCServiceDesk__FKStatus__c from BMCServiceDesk__Incident__c where id =: ca_matched_incident_id limit 1];for(BMCServiceDesk__Incident__c inp : inc_up){Boolean applies_to_incident = true;Boolean is_inactive = false;for(BMCServiceDesk__Status__c st : [select id, Name, BMCServiceDesk__appliesToIncident__c, BMCServiceDesk__inactive__c FROM BMCServiceDesk__Status__c where Name =: ca_close_resolved_incident_to and BMCServiceDesk__appliesToIncident__c =: applies_to_incident and BMCServiceDesk__inactive__c =: is_inactive limit 1]){inp.BMCServiceDesk__FKStatus__c = st.id;ca_incident_can_be_updated = 'Yes';}}if(ca_incident_can_be_updated == 'Yes'){update inc_up;}}}}}                               
                    }              
            }
            
            if(ca_matched_task_id != null)  //Existing task - Open or Closed
            {
                    if(String.isNotBlank(ca_reassign_resolved_task_to) && ca_matched_task_state == true && String.isNotBlank(ca_approval_string) && String.isNotBlank(ca_rejection_string) && String.isNotBlank(ca_close_resolved_task_to))
                    {
                            //if(ca_client_id_from_email != null && ca_client_id_from_task != null)
                            if(!ca_client_ids.isEmpty() && ca_client_id_from_task != null)
                            {
                                //if(ca_client_id_from_email == ca_client_id_from_task)
                                if(ca_client_ids.contains(ca_client_id_from_task))
                                {
                                    if(ca_approval_decision == 'REJECTED')
                                    {
                                        List<BMCServiceDesk__Task__c> inc_up = [select id,name,BMCServiceDesk__FKStatus__c from BMCServiceDesk__Task__c where id =: ca_matched_task_id limit 1];
                                        for(BMCServiceDesk__Task__c inp : inc_up)
                                        {
                                            Boolean applies_to_incident = true;
                                            Boolean is_inactive = false;
                                            for(BMCServiceDesk__Status__c st : [select id, Name, BMCServiceDesk__appliesToTask__c, BMCServiceDesk__inactive__c FROM BMCServiceDesk__Status__c where Name =: ca_reassign_resolved_task_to and BMCServiceDesk__appliesToTask__c =: applies_to_incident and BMCServiceDesk__inactive__c =: is_inactive limit 1])
                                            {
                                                inp.BMCServiceDesk__FKStatus__c = st.id;
                                                ca_task_can_be_updated = 'Yes';
                                            }
                                        }
                                        if(ca_task_can_be_updated == 'Yes')
                                        {
                                            update inc_up;
                                        }
                                    }
                                    if(ca_approval_decision == 'APPROVED')
                                    {
                                        List<BMCServiceDesk__Task__c> inc_up = [select id,name,BMCServiceDesk__FKStatus__c, BMCServiceDesk__taskResolution__c from BMCServiceDesk__Task__c where id =: ca_matched_task_id limit 1];
                                        for(BMCServiceDesk__Task__c inp : inc_up)
                                        {
                                            Boolean applies_to_incident = true;
                                            Boolean is_inactive = false;
                                            for(BMCServiceDesk__Status__c st : [select id, Name, BMCServiceDesk__appliesToTask__c, BMCServiceDesk__inactive__c FROM BMCServiceDesk__Status__c where Name =: ca_close_resolved_task_to and BMCServiceDesk__appliesToTask__c =: applies_to_incident and BMCServiceDesk__inactive__c =: is_inactive limit 1])
                                            {
                                                inp.BMCServiceDesk__FKStatus__c = st.id;
                                                inp.BMCServiceDesk__taskResolution__c = ca_task_resolution;
                                                ca_task_can_be_updated = 'Yes';
                                            }
                                        }
                                        if(ca_task_can_be_updated == 'Yes')
                                        {
                                            update inc_up;
                                        }
                                    }
                               }
                           }                               
                    }              
            } 
            
        return result;
    }
}