public with sharing class IntegrationFrameworkCalloutMockTest implements HttpCalloutMock {

    private static Map<String, String> RESPONSE_BODY = new Map<String, String>();
    static{
        RESPONSE_BODY.put('dealCode', 'Varun Nirala');
        RESPONSE_BODY.put('details', 'This is confidential deal with the client. Please do not disclose information you see.');
        RESPONSE_BODY.put('closeDate', '2020-01-01');
        RESPONSE_BODY.put('amount', '205000.0');
        RESPONSE_BODY.put('owner', 'Mr. King');
        RESPONSE_BODY.put('customer', 'XXXX');
    }
    private static final String RESPONSE_HEADER_PARAM_NAME = 'Content-Type';
    private static final String RESPONSE_HEADER_CONTENT_TYPE = 'application/json';
    
    public HTTPResponse respond(HttpRequest req){
        HttpResponse resp=new HttpResponse();
        resp.setHeader(RESPONSE_HEADER_PARAM_NAME, RESPONSE_HEADER_CONTENT_TYPE);
        resp.setBody( JSON.serialize(RESPONSE_BODY) );
        resp.setStatusCode(200);
        return resp;
        
        }
        

}