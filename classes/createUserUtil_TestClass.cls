@IsTest
Private class createUserUtil_TestClass {
  static testMethod void validate_createUserUtil() {
      test.startTest();
      User CurrentUser=New User();
     
        Account cat = new Account (Name = 'TSTCAT');
        insert cat;
      
      CurrentUser=[select Id,Name from User where Id=: userinfo.getuserId()];

      createUserUtil.acctLink(cat.Id,userinfo.getuserId());
      test.stopTest();
  }
}