@IsTest
Private class ca_assoc_user_to_cha_group_on_crea_TEST{

    static testMethod void validateIncidentQueue(){
        Test.startTest();
        String userName = UserInfo.getUserName();
        User activeUser = [Select Id, Name, Email From User where Username = : userName limit 1];
        String userNm = activeUser.Name;
        String userEmail1 = 'bmcrf_emailcreateincident@1a6r383e9ggc0pvj7g0mj9u5gkvsdv3zudcgdhj0g4mzwv12qi.i-aehceai.il.apex.salesforce.com';
        String userEmail2 = 'emailcreateincident1@2ku073hyrqjr9ck17c6ltwtr1sxhi04u0fhhwwcn0qw7twmuzr.i-aehceai.na15.apex.salesforce.com';
        String userId = activeUser.Id;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ServiceDesk Staff']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser102345234@testorg.com');
        insert u;
            

        
        
        
        Test.stopTest();
    }
}