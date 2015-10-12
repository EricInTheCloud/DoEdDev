trigger DoED_Update_IMRNum_IMRDesc_Status on BMCServiceDesk__IncidentHistory__c (after insert) 
{
    String Subject;
    String task_identifier = 'Task##';
    String task_end_identifier = '##';
    String task_number;
    String Body;
    String IMRNum_identifier = 'IMR Number##';
    String IMRNum_end_identifier = '##';
    String IMRNum;
    String IMRDescription_identifier = 'IMR Detail##';
    String IMRDescription_end_identifier = '##';
    String IMRDescription;
    String Status_Identifier = 'Task Update##';
    String Status_end_Identifier = '##';
    String Status;
    String status_found;
    String Resolution_Identifier = 'Resolution##';
    String Resolution_end_Identifier = '##';
    String Resolution;
    String ca_email_listener_1 = Ca_Utilities.getSettingValueByName('ca_email_listener_1');
    String ca_email_listener_2 = Ca_Utilities.getSettingValueByName('ca_email_listener_2');
    String ca_email_listener_3 = Ca_Utilities.getSettingValueByName('ca_email_listener_3');
    String ca_email_listener_4 = Ca_Utilities.getSettingValueByName('ca_email_listener_4');
    String ca_email_listener_5 = Ca_Utilities.getSettingValueByName('ca_email_listener_5');
    
    for(BMCServiceDesk__IncidentHistory__c inchis : Trigger.new)
    {
        Subject = inchis.BMCServiceDesk__description__c;
        Body = inchis.BMCServiceDesk__note__c;
        
        if(Subject.contains(task_identifier))
        {
            Integer s1;
            s1 = Subject.indexOf(task_identifier);
            s1 = s1 + 6;
            Integer s2;
            s2 = Subject.indexOf(task_end_identifier,s1);
            task_number = Subject.substring(s1,s2);
            
            if(Body.contains(IMRNum_identifier))
            {
                Integer s3;
                s3 = Body.indexOf(IMRNum_identifier);
                s3 = s3 + 12;
                Integer s4;
                s4 = Body.indexOf(IMRNum_end_identifier,s3);
                IMRNum = Body.substring(s3,s4);
                
                if(IMRNum.length() > 25){IMRNum = Body.substring(s3,s3+25);}
                
                
            }
            
            if(Body.contains(IMRDescription_identifier)){Integer s5;s5 = Body.indexOf(IMRDescription_identifier);s5 = s5 + 12;Integer s6;s6 = Body.indexOf(IMRDescription_end_identifier,s5);IMRDescription = Body.substring(s5,s6);} 

           If(Body.contains(Resolution_Identifier))
            {
                Integer s9;
                s9 = Body.indexOf(Resolution_Identifier);
                s9 = s9 + 12;
                Integer s10;
                s10 = Body.indexOf(Resolution_end_Identifier,s9);
                Resolution = Body.substring(s9,s10);
                Resolution = Resolution.trim();
            } 

            
            if(Body.contains(Status_Identifier))
            {
                Integer s7;
                s7 = Body.indexOf(Status_Identifier);
                s7 = s7 + 13;
                Integer s8;
                s8 = Body.indexOf(Status_end_Identifier,s7);
                Status = Body.substring(s7,s8);
                
                List<BMCServiceDesk__Status__c> status_query = [SELECT Id FROM BMCServiceDesk__Status__c WHERE Name =: Status AND BMCServiceDesk__appliesToTask__c = true limit 1];      
                if(!status_query.isEmpty()){for(BMCServiceDesk__Status__c wo : status_query){status_found = wo.Id;}  
                }
                
               
            } 
           
            If(String.isNotBlank(IMRNum) || String.isNotBlank(IMRDescription) || String.isNotBlank(status_found))
            {
                List<BMCServiceDesk__Task__c> task_to_update = [select Id,IMR__c,IMR_Detail__c,BMCServiceDesk__FKStatus__c,Is_Resolution_NULL__c from BMCServiceDesk__Task__c where Name =: task_number limit 1];      
                if(!task_to_update.isEmpty()){for(BMCServiceDesk__Task__c wo : task_to_update){if(String.isNotBlank(IMRNum)){wo.IMR__c = IMRNum;}if(String.isNotBlank(IMRDescription)){wo.IMR_Detail__c = IMRDescription;}if(String.isNotBlank(status_found)){if(Status == 'CLOSED'){if( (String.isNotBlank(Resolution) || wo.Is_Resolution_NULL__c == 'No') ){wo.BMCServiceDesk__FKStatus__c = status_found;}}else{wo.BMCServiceDesk__FKStatus__c = status_found;}}if(String.isNotBlank(Resolution)){wo.BMCServiceDesk__taskResolution__c = Resolution;}}update task_to_update;
                }
            }
                                            
        }
        else
        {
            List<BMCServiceDesk__Incident__c> incident_to_update = [select Id, BMCServiceDesk__FKStatus__c from BMCServiceDesk__Incident__c where id =: inchis.BMCServiceDesk__FKIncident__c limit 1];
            for(BMCServiceDesk__Incident__c inc : incident_to_update)
            {
                if(inchis.BMCServiceDesk__actionId__c == 'Email Sent'){inc.BMCServiceDesk__FKStatus__c = Ca_Utilities.getSettingValueByName('ca_email_sent_status');}
                
                if(inchis.BMCServiceDesk__actionId__c == 'Email Received')
                {
                    inc.BMCServiceDesk__FKStatus__c = Ca_Utilities.getSettingValueByName('ca_email_received_status');
                }
            }
            
            if(incident_to_update.size() > 0)
            {
                if(String.isNotBlank(ca_email_listener_1) && String.isNotBlank(ca_email_listener_2) && String.isNotBlank(ca_email_listener_3) && String.isNotBlank(ca_email_listener_4) && String.isNotBlank(ca_email_listener_5))
                {
                    // 2015.9.29 EOLSON - Adding a condition to the Body.contains() check for the edcaps.reply address (ca_email_listener_4). 
                    // If the body contains the email conversation string, the else branch should be executed to update the status.
                    //* 
                    system.debug('~~ ca_email_listener_1: ' + ca_email_listener_1);
                    system.debug('~~ ca_email_listener_2: ' + ca_email_listener_2);
                    system.debug('~~ ca_email_listener_3: ' + ca_email_listener_3);
                    system.debug('~~ ca_email_listener_4: ' + ca_email_listener_4);
                    system.debug('~~ ca_email_listener_5: ' + ca_email_listener_5);
                    //system.debug('~~ Body: ' + Body);
                    
                    system.debug('~~ Body.containsIgnoreCase(ca_email_listener_1): ' + Body.containsIgnoreCase(ca_email_listener_1));
                    system.debug('~~ Body.containsIgnoreCase(ca_email_listener_2): ' + Body.containsIgnoreCase(ca_email_listener_2));
                    system.debug('~~ Body.containsIgnoreCase(ca_email_listener_3): ' + Body.containsIgnoreCase(ca_email_listener_3));
                    system.debug('~~ Body.containsIgnoreCase(ca_email_listener_4): ' + Body.containsIgnoreCase(ca_email_listener_4));
                    system.debug('~~ Body.containsIgnoreCase(ca_email_listener_5): ' + Body.containsIgnoreCase(ca_email_listener_5));

                    system.debug('~~ Subject contains Ref:IN: ' + Subject.containsIgnoreCase('(Ref:IN'));
                    system.debug('~~ if() condition evaluates to: ' + (Body.containsIgnoreCase(ca_email_listener_1) || 
                        Body.containsIgnoreCase(ca_email_listener_2) || 
                        Body.containsIgnoreCase(ca_email_listener_3) || 
                        //(Body.containsIgnoreCase(ca_email_listener_4) && !Subject.containsIgnoreCase('(Ref:IN')) ||
                        Body.containsIgnoreCase(ca_email_listener_5))); //*/
                    
                    if(
                        Body.containsIgnoreCase(ca_email_listener_1) || 
                        Body.containsIgnoreCase(ca_email_listener_2) || 
                        Body.containsIgnoreCase(ca_email_listener_3) || 
                        //Body.containsIgnoreCase(ca_email_listener_4) ||
                    	Body.containsIgnoreCase(ca_email_listener_5)
                    ) //END EOLSON
                    {
                        
                    }
                    else
                    {
                        update incident_to_update;
                    }
                }
            }              
        }
    }
}