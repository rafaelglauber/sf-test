public class Accounts extends fflib_SObjectDomain {

    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }
    
    public void setAddress(Map<Id, AddressClient.AddressResponse> addresses, fflib_ISObjectUnitOfWork unitOfWork){
        
        System.debug('setAddress -> Accounts ' + Records.size());
        if (addresses.keySet().size() != Records.size()) {
            throw new AccountException('A quantidade de endereços não corresponde com a quantidade de contas.');
        }

        for(Account acc : (List<Account>) Records) {
            AddressClient.AddressResponse address = addresses.get(acc.Id);
            if (address != null){
                System.debug('setAddress -> ' + acc.Id + ' -> ' + address.logradouro);
                acc.EnderecoCompletoSemNumero__c = address.logradouro + ', ' + address.bairro + ', ' + address.localidade;
                acc.EnderecoEstado__c = address.uf;
            } else {
                System.debug('setAddress -> address not found for ' + acc.Id);
                acc.CEP__c.addError('Não localizado ou não disponível a consulta de CEP para: ' + acc.CEP__c);
            }                
        }

        unitOfWork.registerDirty((List<Account>) Records);
    }

    public void setDefaultVendedor(Map<Id, Id> vendedores, fflib_ISObjectUnitOfWork unitOfWork){

        if (vendedores.keySet().size() != Records.size()) {
            throw new AccountException('A quantidade de vendedores não corresponde com a quantidade de contas.');
        }

        for(Account acc : (List<Account>) Records) {
            if(acc.Vendedor__c == null) {
                Id idVendedor = vendedores.get(acc.Id);
                if (idVendedor != null){
                    acc.Vendedor__c = idVendedor;
                } else {
                    acc.Vendedor__c.addError('Não foi localizado nenhum vendedor padrão para esta conta.');
                }                
            }
        }

        unitOfWork.registerDirty((List<Account>) Records);
    }    
    
    public class AccountException extends Exception {}
}
