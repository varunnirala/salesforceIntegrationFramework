public with sharing class ExampleDealLWCController {
    @AuraEnabled(cacheable=false)
    public static String  getDealDetails(String dealCd){
        
        Map<String,String> dealQuery = new Map<String,String>();
        dealQuery.put('dealCode',dealCd);
		// Integration invocation through framework      
    	IntegrationContractLayerInterface  integration001 = IntegrationFrameworkCalloutLayer.invoke('INT0001',dealQuery);
        IntegrationContractedResponseInterface contractedResponse = integration001.getResponseContractedDetails();
        
        return JSON.serialize(contractedResponse);
    
}
}