public inherited sharing class AccountsSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType(){
        return Account.sObjectType;
    }
   
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Account.Id,
            Account.Name,
            Account.Vendedor__c,
            Account.QualificacaoCliente__c,
            Account.CEP__c,
            Account.EnderecoCompletoSemNumero__c,
            Account.EnderecoNumero__c,
            Account.EnderecoEstado__c
        };
    }

    public Integer getMaxValueForQuantityField(){
        AggregateResult[] res = [SELECT MAX(Quantidade__c) quantidade FROM Account];
        return (res.get(0).get('quantidade') == null) ? 0 : Integer.valueOf(res.get(0).get('quantidade'));
    }

    public List<Account> selectAll(){
		return (List<Account>) Database.query(
			newQueryFactory().
            selectField(Account.Id).
            selectField(Account.Name).
            selectField(Account.Vendedor__c).
            selectField(Account.QualificacaoCliente__c).
            selectField(Account.CEP__c).
            selectField(Account.EnderecoCompletoSemNumero__c).
            selectField(Account.EnderecoNumero__c).
            selectField(Account.EnderecoEstado__c).
            toSOQL()
		);
    }

    public List<Account> selectByIds(Set<Id> accIds){
		return (List<Account>) Database.query(
			newQueryFactory().
            selectField(Account.Id).
            selectField(Account.Name).
            selectField(Account.Vendedor__c).
            selectField(Account.QualificacaoCliente__c).
            selectField(Account.CEP__c).
            selectField(Account.EnderecoCompletoSemNumero__c).
            selectField(Account.EnderecoNumero__c).
            selectField(Account.EnderecoEstado__c).
            setCondition('Id IN : accIds').
            toSOQL()
		);		
        //return (List<Account>) selectSObjectsById(accIds);        
    }

    public Account selectById(Id accId){
        Set<Id> ids = new Set<Id>();
        ids.add(accId);
        List<Account> accs = selectByIds(ids);
        if (accs.size() == 1) {return accs.get(0);} else {return null;}
    }

    public List<Account> selectAllWithoutEndereco(){
        return (List<Account>) Database.query(
			newQueryFactory().
            selectField(Account.Id).
            selectField(Account.Name).
            selectField(Account.Vendedor__c).
            selectField(Account.QualificacaoCliente__c).
            selectField(Account.CEP__c).
            selectField(Account.EnderecoCompletoSemNumero__c).
            selectField(Account.EnderecoNumero__c).
            selectField(Account.EnderecoEstado__c).
            setCondition('CEP__c is not null and EnderecoCompletoSemNumero__c is null').
            toSOQL()
		);       
    }

}