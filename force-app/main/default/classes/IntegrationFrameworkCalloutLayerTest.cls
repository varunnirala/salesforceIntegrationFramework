@isTest
public class IntegrationFrameworkCalloutLayerTest {
    

    @isTest
    static void testHttpCallout() {

        Test.setMock(HttpCalloutMock.class, new IntegrationFrameworkCalloutMockTest());
        Test.startTest();
        
        Map<String,String> dealQuery = new Map<String,String>();
        dealQuery.put('dealCode','deal-2021');
    	IntegrationContractLayerInterface  integration001 = IntegrationFrameworkCalloutLayer.invoke('INT0001',dealQuery);
        IntegrationContractedResponseInterface contractedResponse = integration001.getResponseContractedDetails();

        Test.stopTest();

        
    }


}