@IsTest
Private class CA_Helper_FunctionsTestClass {
    static testMethod void validate_Helper_Functions(){
        Test.startTest();
         //Create User
         User CurrentUser=New User();
         CurrentUser=[select Id,Name from User where Id=: userinfo.getuserId()];

        String userNm = CA_Helper_Functions.returnstaffname(CurrentUser.Id);          
        Test.stopTest();
    }
}