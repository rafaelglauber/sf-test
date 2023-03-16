public with sharing class AccountsService {
    
    public static void setAddressForAccount(Set<Id> recordIds){

        fflib_ISObjectDomain objectDomain = (fflib_ISObjectDomain) Application.domain.newInstance(recordIds);
        fflib_ISObjectSelector objectSelector = Application.selector.newInstance(Account.SObjectType);
		fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();
        
        // Lista de contas para obter o CEP
        List<Account> accs = objectSelector.selectSObjectsById(recordIds);

        // Map de endereços
        Map<Id, AddressClient.AddressResponse> mapAddress = new Map<Id, AddressClient.AddressResponse>();

        // Client HTTP que busca o endereço por WS
        AddressClient addressClient1 = ViaCepAddressClient.create();

        for (Account acc : accs){
            if(String.isBlank(acc.CEP__c) | !String.isBlank(acc.EnderecoCompletoSemNumero__c)){
                System.debug('Account CEP isBlank -> ' + acc.Id);
                mapAddress.put(acc.Id, null);
            } else {
                AddressClient.AddressResponse result = addressClient1.getAddress(acc.CEP__c);
                System.debug('Account CEP return -> ' + result.cep + ' for ' + acc.Id);
                mapAddress.put(acc.Id, result);
            }
        }

        Accounts domainAccount = (Accounts) objectDomain;
        domainAccount.setAddress(mapAddress, unitOfWork);

		try{
			unitOfWork.commitWork();
		}
		catch(Exception e){
			throw e;
		}        
    }

    private enum TipoVendedor {
        INTERNO,
        EXTERNO,
        AMBOS    
    }

    private static TipoVendedor converterTipoVendedor(String tp){
        return (tp == 'Interno') ? TipoVendedor.INTERNO : TipoVendedor.EXTERNO;
    }

    private static TipoVendedor converterQualificacaoCliente(String qualificacao){
        if (qualificacao == 'Prata'){
            return TipoVendedor.AMBOS;
        } else if (qualificacao == 'Bronze'){
            return TipoVendedor.EXTERNO;
        }
        return TipoVendedor.INTERNO;
    }

    public static void setDefaultVendedorForAccount(Set<Id> recordIds){

        Integer maxQuantidadeContas;
    
        fflib_ISObjectDomain objectDomain = (fflib_ISObjectDomain) Application.domain.newInstance(recordIds);        
        AccountsSelector accSelector = (AccountsSelector) Application.selector.newInstance(Account.SObjectType);
        VendedoresSelector vendedorSelector = (VendedoresSelector) Application.selector.newInstance(Vendedor__c.sObjectType); 
        fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();
        List<Vendedor__c> vendedores = vendedorSelector.selectAllWithAccounts();
        List<Account> accs = accSelector.selectByIds(recordIds);

        // Map de Vendedores que serão atualizados nas contas
        Map<Id, Id> mapVendedor = new Map<Id, Id>();

        for (Account acc : accs){
            if (acc.Vendedor__c == null){
                Integer menorQuantidadeContas = 2147483647; // max positive value 
                Integer idxVendedor = null;        
                TipoVendedor tp = converterQualificacaoCliente(acc.QualificacaoCliente__c);
                for (Vendedor__c vendedor : vendedores){                        
                    if ((converterTipoVendedor(vendedor.RecordType.Name) == tp) | (tp == TipoVendedor.AMBOS)){
                        if (vendedor.Accounts__r.size() < menorQuantidadeContas){
                            menorQuantidadeContas = vendedor.Accounts__r.size();
                            idxVendedor = vendedores.indexOf(vendedor);                    
                        }    
                    }
                }                          
                if (idxVendedor != null){
                    vendedores.get(idxVendedor).Accounts__r.add(acc);
                    mapVendedor.put(acc.Id, vendedores.get(idxVendedor).Id);
                } else {
                    mapVendedor.put(acc.Id, null);
                }        
            } else {
                mapVendedor.put(acc.Id, null); // keep default
            }
        }
        
        Accounts domainAccount = (Accounts) objectDomain;
        domainAccount.setDefaultVendedor(mapVendedor, unitOfWork);

		try{
			unitOfWork.commitWork();
		}
		catch(Exception e){
			throw e;
		}               
    }

    public static void setAddressForAllAccount(){
        AccountsSelector accSelector = (AccountsSelector) Application.selector.newInstance(Account.SObjectType);
        Set<Id> recordIds = new Set<Id>();
        for (Account acc : accSelector.selectAllWithoutEndereco()){
            recordIds.add(acc.Id);
        }
        setAddressForAccount(recordIds); 
    }
}    