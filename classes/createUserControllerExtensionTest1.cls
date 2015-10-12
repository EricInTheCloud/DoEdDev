@IsTest
    private class createUserControllerExtensionTest1 {
    

   

        
        static testMethod void testGeneral() {
        
        
 
System.runAs ( new User(Id = UserInfo.getUserId()) ) {
    UserRole r = new UserRole(name = 'Remedyforce Client');
        insert r;
}
     
     
        
        BMCServiceDesk__Incident__c i = new BMCServiceDesk__Incident__c();
        Account acct = new Account (
        Name = 'MYACCOUNT');
        insert acct;
        
        
        
        string accts = 'New Accounts';
        string email1 = 'test@mytest.com';
        string email2 = 'test@mytest2.com';
        string email3 = 'test@mytest3.com';
        string uName = 'test@username.com';
        string uPhone = '770555-5555';
        string fName = 'Tester';
        string lName = 'MyTester';
        string uId = [SELECT Id FROM USER LIMIT 1].Id;
        string updUserFound = 'true';
        string listFilter = 'Create User';
        string requiredVal = 'true';
        string searchCriteria = 'jscottp99@msn.com';
        string tmpAccountId = acct.Id;
        boolean displayPopup = true;
        string result = 'My Result';
        string acctUser = 'MyAcctUser';
        integer intAcct = 4;
        string a1;
        string a2;
        string a3;
        string a4;
        string a5;
        string a6;
        string a7;
        string a8;
        string a9;
        string a10;
        string a11;
        string a12;
        string a13;
        string a14;
        string a15;
        string a16;
        string a17;
        string a18;
        string a19;
        string a20;
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
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(i);
        createUserControllerExtension ctlr = new createUserControllerExtension(stdController);
        test.StartTest ();
        ctlr.getaccts1();
        ctlr.reset();
        ctlr.showPopup();
        ctlr.closePopup();
        ctlr.reset1();
        ctlr.usrFound();
        test.StopTest ();
        }
   static testMethod void testUserInsert() {
        BMCServiceDesk__Incident__c i = new BMCServiceDesk__Incident__c();
        
         ApexPages.StandardController stdController = new ApexPages.StandardController(i);
        createUserControllerExtension ctlr = new createUserControllerExtension(stdController);
        
        User usr = new User (
        Username = 'testUser100@msn.com',
        FirstName = 'MyTester1',
        LastName = 'MyTesterLname',
        Email = 'testUser100@msn.com',
        Email_Account_2__c = 'testUser101@msn.com',
        Email_Account_3__c = 'testUser102@msn.com',
        Phone = '7705555551',
        Alias = 'sparr',
        IsActive = true,
        TimezoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'ISO-8859-1',
        //UserRoleId = [SELECT Id FROM UserRole WHERE Name='Remedyforce Client'].Id,
        ProfileId = [SELECT Id FROM Profile WHERE Name='ServiceDesk Client'].Id);
        insert usr;
        test.StartTest ();
        ctlr.createUser();
        test.StopTest ();
        } 
        static testMethod void testUserSearch() {
                BMCServiceDesk__Incident__c i = new BMCServiceDesk__Incident__c();
        
         ApexPages.StandardController stdController = new ApexPages.StandardController(i);
        createUserControllerExtension ctlr = new createUserControllerExtension(stdController);
               
        User usr = new User (
        Username = 'testUser105@msn.com',
        FirstName = 'MyTester1',
        LastName = 'MyTesterLname',
        Email = 'testUser100@msn.com',
        Email_Account_2__c = 'testUser101@msn.com',
        Email_Account_3__c = 'testUser102@msn.com',
        Phone = '7705555551',
        Alias = 'sparr',
        IsActive = true,
        TimezoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'ISO-8859-1',
        //UserRoleId = [SELECT Id FROM UserRole WHERE Name='Remedyforce Client'].Id,
        ProfileId = [SELECT Id FROM Profile WHERE Name='ServiceDesk Client'].Id);
        insert usr;
        
        List<User> usr1 = [SELECT Id,FirstName,LastName,Email,Email_Account_2__c,Email_Account_3__c,Phone,BMCServiceDesk__Account_Name__c FROM User WHERE username = 'testUser105@msn.com'];
  
        string email1 = usr1[0].email;
        string email2 = usr1[0].Email_Account_2__c;
        string email3 = usr1[0].Email_Account_3__c;
        string uPhone = usr1[0].Phone;
        string fName = usr1[0].FirstName;
        string lName = usr1[0].LastName;
        string searchCriteria = 'testUser105@msn.com';
        
         ctlr.runSearch();

         System.AssertEquals('MyTesterLname',lName);
         System.AssertEquals('MyTester1',fName);
         System.AssertEquals('7705555551',uPhone); 
       }
              static testMethod void testUserUpdate() {
                BMCServiceDesk__Incident__c i = new BMCServiceDesk__Incident__c();
        
         ApexPages.StandardController stdController = new ApexPages.StandardController(i);
        createUserControllerExtension ctlr = new createUserControllerExtension(stdController);
        
        User usr = new User (
        Username = 'testUser105@msn.com',
        FirstName = 'MyTester1',
        LastName = 'MyTesterLname',
        Email = 'testUser100@msn.com',
        Email_Account_2__c = 'testUser101@msn.com',
        Email_Account_3__c = 'testUser102@msn.com',
        Phone = '7705555551',
        Alias = 'sparr',
        IsActive = true,
        TimezoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'ISO-8859-1',
        //UserRoleId = [SELECT Id FROM UserRole WHERE Name='Remedyforce Client'].Id,
        ProfileId = [SELECT Id FROM Profile WHERE Name='ServiceDesk Client'].Id);
        insert usr;
 
         usr.FirstName = 'MyFirstName';
         usr.LastName = 'MyLastName';
         usr.Email = 'MyEmail@101.com';
         usr.Email_Account_2__c = 'Myemail2@101.com';
         usr.Email_Account_3__c = 'Myemail3@101.com';
         update usr;

         
         test.StartTest();
         ctlr.updateUser();
         test.StopTest();
         System.AssertEquals('MyFirstName',usr.FirstName);
         System.AssertEquals('MyLastName',usr.LastName);
         System.AssertEquals('MyEmail@101.com',usr.Email);
         System.AssertEquals('Myemail2@101.com',Usr.Email_Account_2__c);
         System.AssertEquals('Myemail3@101.com',Usr.Email_Account_3__c);
         }
         
       }