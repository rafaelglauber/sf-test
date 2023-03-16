public with sharing class AccountsHandlerTrigger extends fflib_SObjectDomain {

    public AccountsHandlerTrigger(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new AccountsHandlerTrigger(sObjectList);
        }
    }

    public override void onApplyDefaults() {
	}

	public override void onValidate() {
        // call business rules, except in System.isFuture()
        if (!System.isFuture()){
            if (ConfigMetadata.isBuscaCepViaTrigger()){
                FutureAddressForAccountProcessing.process((new Map<Id, SObject>(Records)).keySet());
            }
        }        
    }

	public override void onAfterInsert() {
        AccountsService.setDefaultVendedorForAccount((new Map<Id, SObject>(Records)).keySet());
	}

}