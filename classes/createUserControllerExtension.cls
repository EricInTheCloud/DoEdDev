public class createUserControllerExtension {
    public BMCServiceDesk__Incident__c i;

public createUserControllerExtension(ApexPages.StandardController stdController) {
        this.i = (BMCServiceDesk__Incident__c)stdController.getRecord();
    }
  public string accts {get; set;}  
  public string email1 {get; set;}
  public string email2 {get; set;}
  public string email3 {get; set;}
  public string uName {get; set;}
  public string uPhone {get; set;}
  public string fName {get; set;}
  public string lName {get; set;}
  public string uId {get; set;}
  public string updUserFound {get; set;}
  public string listFilter {get; set;}
  public string requiredVal {get; set;}
  public string searchCriteria {get; set;}
              public string a1;
        public string a2;
        public string a3;
        public string a4;
        public string a5;
        public string a6;
        public string a7;
        public string a8;
        public string a9;
        public string a10;
        public string a11;
        public string a12;
        public string a13;
        public string a14;
        public string a15;
        public string a16;
        public string a17;
        public string a18;
        public string a19;
        public string a20;
        string ab1;
        string ab2;
        string ab3;
        string ab4;
        string ab5;
        string ab6;
        string ab7;
        string ab8;
        string ab9;
        string ab10;
        string ab11;
        string ab12;
        string ab13;
        string ab14;
        string ab15;
        string ab16;
        string ab17;
        string ab18;
        string ab19;
        string ab20;
        string ac1;
        string ac2;
        string ac3;
        string ac4;
        string ac5;
        string ac6;
        string ac7;
        string ac8;
        string ac9;
        string ac10;
        string ac11;
        string ac12;
        string ac13;
        string ac14;
        string ac15;
        string ac16;
        string ac17;
        string ac18;
        string ac19;
        string ac20;
                string ad1;
        string ad2;
        string ad3;
        string ad4;
        string ad5;
        string ad6;
        string ad7;
        string ad8;
        string ad9;
        string ad10;
        string ad11;
        string ad12;
        string ad13;
        string ad14;
        string ad15;
        string ad16;
        string ad17;
        string ad18;
        string ad19;
        string ad20;
        string ae1;
        string ae2;
        string ae3;
        string ae4;
        string ae5;
        string ae6;
        string ae7;
        string ae8;
        string ae9;
        string ae10;
        string ae11;
        string ae12;
        string ae13;
        string ae14;
        string ae15;
        string ae16;
        string ae17;
        string ae18;
        string ae19;
        string ae20;
  public string tmpAccountId {get; set;}
  public boolean displayPopup {get; set;}
  public string result {get; set;}
  public string acctUser {get; set;}
  public integer intAcct {get; set;}

 
    public void closePopup() {
        displayPopup = false;
    }
 
    public void showPopup() {
        displayPopup = true;
    }
      
public PageReference runSearch() {
 try {
    List<User> usr1 = [SELECT Id,FirstName,LastName,Email,Email_Account_2__c,Email_Account_3__c,Phone,BMCServiceDesk__Account_Name__c FROM User WHERE username =: searchCriteria];
    System.Debug('test1 : List User '+usr1);
    System.debug('test2 : searchCriteria ' +searchCriteria);
    fName = usr1[0].FirstName;
    email1 = usr1[0].Email;
    lName = usr1[0].LastName;
    email2 = usr1[0].Email_Account_2__c;
    email3 = usr1[0].Email_Account_3__c;
    uPhone = usr1[0].Phone;
    uId = usr1[0].Id;
        If (usr1[0].BMCServiceDesk__Account_Name__c != null) {
    tmpAccountId = [SELECT Id FROM Account WHERE Name =: usr1[0].BMCServiceDesk__Account_Name__c].Id;
    i.BMCServiceDesk__FKAccount__c = tmpAccountId;
        }
     If (usr1.size() > 0) {
     usrFound();
     return null;
     }
     else { 
    return null;
    }
  }catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The username you entered could not be found'));
    }
    return null;
   }
   
    public PageReference usrFound() {
            updUserFound = 'true';
            return null;
           }


    public List<selectOption> getaccts1() {
        List<selectOption> options = new List<selectOption>(); 
//new list for holding all of the picklist options
        options.add(new selectOption('', '')); 
//add the first option of '- None -' in case the user doesn't want to select a value or in case no values are  returned from query below
        for (Account account : [SELECT Id, Name FROM Account]) { 
//query for Account records 
            options.add(new selectOption(account.id, account.Name)); 
//for all records found - add them to the picklist options
        }
        return options; //return the picklist options

    }
  public void reset() {
      requiredVal = null;
      fName = null;
      lName = null;
      email1 = null;
      email2 = null;
      email3 = null;
      uPhone = null;
      i.BMCServiceDesk__FKAccount__c = null;
      updUserFound = null;
      searchCriteria = null;
      uId = null;
      }
         
  public PageReference reset1() {
       requiredVal = null;
       listFilter = 'None';
       reset();
       return null;
       }    
      
          public PageReference createUser() {

        If (fName == '' || lname == '' || email1 == '' || i.BMCServiceDesk__FKAccount__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required fields missing. The following fields are required when creating or updating a user: First Name, Last Name, Email and Account'));
            return null;
            }
         else {    
      accts = i.BMCServiceDesk__FKAccount__c;
            try {
      User usr = new User (
      Username = email1,
      FirstName = fName,
      LastName = lName,
      Email = email1,
      Email_Account_2__c = email2,
      Email_Account_3__c = email3,
      Phone = uPhone,
      Alias = 'sparr',
      IsActive = true,
      TimezoneSidKey = 'America/New_York',
      LocaleSidKey = 'en_US',
      LanguageLocaleKey = 'en_US',
      EmailEncodingKey = 'ISO-8859-1',
      BMCServiceDesk__Account_Name__c = accts,
      UserRoleId = [SELECT Id FROM UserRole WHERE Name='Remedyforce Client'].Id,
      ProfileId = [SELECT Id FROM Profile WHERE Name='ServiceDesk Client'].Id);

      insert usr;
      System.debug(uId);
  createUserUtil.acctLink(string.ValueOf(accts),string.ValueOf(usr.Id));
      result = 'The user record for ' + email1 + ' was successfully created.';
    showPopup();  
    reset1();
    }
    
 catch (Exception e) {
  //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Customer Search did not return any records. Please search again.'));
 }
 } 
 return null;
 }
     
     public PageReference updateUser () {
     If (fName == '' || lname == '' || email1 == '' || i.BMCServiceDesk__FKAccount__c == null ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required fields missing. The following fields are required when creating or updating a user: First Name, Last Name, Email and Account'));
            return null;
            }   
         else {    
         try {
   
    User updUser = [SELECT Id, FirstName, LastName, Email, Email_Account_2__c, Email_Account_3__c, Phone FROM User WHERE Id = :uId];

        updUser.FirstName = fName;
        updUser.LastName = lName;
        updUser.Phone = uPhone;
        updUser.Email = Email1;
        updUser.Email_Account_2__c = Email2;
        updUser.Email_Account_3__c = Email3;
        
        update updUser;
        
        List<BMCServiceDesk__User_Account_Link__c> acctUser = [SELECT Id,BMCServiceDesk__FKUser__c,BMCServiceDesk__FKAccount__c  FROM BMCServiceDesk__User_Account_Link__c WHERE BMCServiceDesk__FKUser__c =: uId];
             If (acctUser.size() > 0) {
            BMCServiceDesk__User_Account_Link__c acctUserId = [SELECT Id,BMCServiceDesk__FKUser__c,BMCServiceDesk__FKAccount__c  FROM BMCServiceDesk__User_Account_Link__c WHERE BMCServiceDesk__FKUser__c =: uId];  
            acctUserId.BMCServiceDesk__FKUser__c = uId;
            acctUserId.BMCServiceDesk__FKAccount__c = i.BMCServiceDesk__FKAccount__c;
                   update acctUserId;
            }
           else {
           BMCServiceDesk__User_Account_Link__c acctUserId = new BMCServiceDesk__User_Account_Link__c (
           BMCServiceDesk__FKUser__c = uId,
           BMCServiceDesk__FKAccount__c = i.BMCServiceDesk__FKAccount__c);
           insert acctUserId;
           }

        result = 'The user record for ' + searchCriteria + ' was successfully updated.';
        showPopup();
        reset1();
     }       
    catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The record update returned an error. Please check your update criteria and try again.'));
 }
 }
return null;
}  
}