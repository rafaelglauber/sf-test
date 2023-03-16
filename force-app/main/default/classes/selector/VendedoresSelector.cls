public inherited sharing class VendedoresSelector extends fflib_SObjectSelector {
    
    public Schema.SObjectType getSObjectType(){
        return Vendedor__c.sObjectType;
    }
   
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Vendedor__c.Id,
            Vendedor__c.Name
        };
    }

    public List<Vendedor__c> selectAll(){
        /*
        fflib_QueryFactory query = newQueryFactory();           
        //query.setCondition('Name IN :names');
        return (List<Vendedor__c>) Database.query( query.toSOQL() );        
        */
        return [SELECT Id, Name, RecordType.Name FROM Vendedor__c];
    }

    public List<Vendedor__c> selectAllWithAccounts(){
        /*
        fflib_QueryFactory query = newQueryFactory();           
        //query.setCondition('Name IN :names');
        return (List<Vendedor__c>) Database.query( query.toSOQL() );        
        */
        return [SELECT Id, Name, RecordType.Name, (SELECT Id, Name, QualificacaoCliente__c FROM Accounts__r) FROM Vendedor__c];
    }

}