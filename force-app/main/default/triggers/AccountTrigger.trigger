trigger AccountTrigger on Account (
    before insert, after insert, 
    before delete, after delete, 
    before update, after update, 
    after undelete) {    
    // call handler triggers methods
    fflib_SObjectDomain.triggerHandler(AccountsHandlerTrigger.class);
}