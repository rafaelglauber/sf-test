public with sharing class AccountUtils {

    public static List<Account> accountsByState(String st){
        return [SELECT Id, Name FROM Account WHERE BillingState = :st];
    }

}