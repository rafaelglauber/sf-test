public with sharing class ConfigMetadata {
    
    private static String INSTANCE_NAME_CONFIG = 'accountGetAddressConfigDev';
    private static AccountGetAddressConfig__mdt config = 
        AccountGetAddressConfig__mdt.getInstance(INSTANCE_NAME_CONFIG);  

    public static Boolean isBuscaCepViaScheduledApex(){
        if (config == null)
          return false;
        return config.BuscaCepViaScheduledApex__c;
    }

    public static Boolean isBuscaCepViaTrigger(){
        if (config == null)
          return false;
        return config.BuscaCepViaTrigger__c;
    }

    public static String getURLApiBuscaCep(){
        if (config == null)
          return 'https://viacep.com.br/ws/';
        return config.BuscaCepURLApi__c;
    }
    
}