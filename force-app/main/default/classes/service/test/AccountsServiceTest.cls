@isTest
public with sharing class AccountsServiceTest {

    // Given - When - Then
    @isTest
    private static void setDefaultVendedorForAccountSucessTest(){
        
		List<Account> accs = new List<Account>
		{
			new Account(Name = 'A1', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Ouro'),
			new Account(Name = 'B1', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Prata'),
			new Account(Name = 'C1', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Bronze'),
			new Account(Name = 'A2', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Ouro'),
			new Account(Name = 'B2', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Prata'),
			new Account(Name = 'C2', Id = fflib_IDGenerator.generate(Schema.Account.SObjectType), QualificacaoCliente__c = 'Bronze')
		};
        Set<Id> recordIds = new Map<Id, SObject>(accs).keySet();

        List<Schema.RecordTypeInfo> rtis = Vendedor__c.SObjectType.getDescribe().getRecordTypeInfos();
        List<Vendedor__c> vendedores = new List<Vendedor__c>
        {
            new Vendedor__c(Name = 'V1', Id = fflib_IDGenerator.generate(Schema.Vendedor__c.SObjectType), RecordTypeId = rtis.get(0).getRecordTypeId()),
            new Vendedor__c(Name = 'V2', Id = fflib_IDGenerator.generate(Schema.Vendedor__c.SObjectType), RecordTypeId = rtis.get(0).getRecordTypeId()),
            new Vendedor__c(Name = 'V3', Id = fflib_IDGenerator.generate(Schema.Vendedor__c.SObjectType), RecordTypeId = rtis.get(1).getRecordTypeId()),
            new Vendedor__c(Name = 'V4', Id = fflib_IDGenerator.generate(Schema.Vendedor__c.SObjectType), RecordTypeId = rtis.get(1).getRecordTypeId())
        };
        Set<Id> vIds = new Map<Id, SObject>(vendedores).keySet();
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();

		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);		
        AccountsSelector selectorAccountsMock = (AccountsSelector) mocks.mock(AccountsSelector.class);
        VendedoresSelector selectorVendedoresMock = (VendedoresSelector) mocks.mock(VendedoresSelector.class);		
        fflib_ISObjectDomain domainMock = (fflib_ISObjectDomain) mocks.mock(Accounts.class);

		mocks.startStubbing();
		    mocks.when(selectorAccountsMock.sObjectType()).thenReturn(Schema.Account.SObjectType);
		    mocks.when(selectorAccountsMock.selectSObjectsById(recordIds)).thenReturn(accs);
		    mocks.when(selectorAccountsMock.selectByIds(recordIds)).thenReturn(accs);            
		    mocks.when(selectorVendedoresMock.sObjectType()).thenReturn(Schema.Vendedor__c.SObjectType);
		    mocks.when(selectorVendedoresMock.selectSObjectsById(vIds)).thenReturn(vendedores);
		    mocks.when(selectorVendedoresMock.selectAllWithAccounts()).thenReturn(vendedores);
            mocks.when(domainMock.getType()).thenReturn(Schema.Account.SObjectType);
		    mocks.when(domainMock.getRecords()).thenReturn(accs);
            // What???
            //((fflib_ISObjectUnitOfWork) mocks.doThrowWhen(new DmlException(), uowMock)).commitWork();
			//
			// Simulated exception.
			//mocks.when(selectorVendedoresMock.selectSObjectsById(vIds)).thenThrow(new DmlException());
		mocks.stopStubbing();

		Application.UOW.setMock(uowMock);
		Application.domain.setMock(domainMock);
		Application.selector.setMock(selectorAccountsMock);
        Application.selector.setMock(selectorVendedoresMock);

		// WHEN we update the Vendedor for account
		try {
			Test.startTest();
			AccountsService.setDefaultVendedorForAccount(recordIds);
			Test.stopTest();				
		} catch (Exception e) {
			System.debug('Exceptionn in AccountsServiceTest');
			System.assert(e instanceof DmlException);
		}

		// THEN 
		//
		// verify - checa as execuções baseadas nos mocks
		((AccountsSelector) mocks.verify(selectorAccountsMock)).selectSObjectsById(recordIds);
		//
		// Se quiser checar quantas vezes o determinado método foi chamado ou se nunca foi chamado (NEVER)
		//((Accounts) mocks.verify(domainMock, 1)).setDefaultVendedor(vendedores, uowMock);
        //
		// atualizações de banco de dados
		((fflib_ISObjectUnitOfWork)	mocks.verify(uowMock)).registerDirty(accs);
		((fflib_ISObjectUnitOfWork)	mocks.verify(uowMock)).commitWork();
		//
		// Testar a regra de negócio aqui: criar os asserts da regra de negócio 
		// (para quais vendedores associou as contas)
		// ...

    }
}