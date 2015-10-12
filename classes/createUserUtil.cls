public class createUserUtil {
    @future
    public static void acctLink(
        String acctId, String uId) {    
        BMCServiceDesk__User_Account_Link__c al = new BMCServiceDesk__User_Account_Link__c (
        BMCServiceDesk__FKAccount__c = acctId,
        BMCServiceDesk__FKUser__c = uId);
        insert al;
}
 
}