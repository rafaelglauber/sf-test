global class FutureAddressForAccountProcessing {
    
    @future(callout=true)
    public static void process(Set<Id> recordIds) {
        AccountsService.setAddressForAccount(recordIds);
    }

}