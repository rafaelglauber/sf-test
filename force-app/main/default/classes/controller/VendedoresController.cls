public with sharing class VendedoresController {

    @AuraEnabled(cacheable=true)
    public static List<Vendedor__c> getVendedoresWithAccounts(){
        try {
            VendedoresSelector selector = (VendedoresSelector) Application.selector.newInstance(Vendedor__c.sObjectType);
            return selector.selectAllWithAccounts();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}