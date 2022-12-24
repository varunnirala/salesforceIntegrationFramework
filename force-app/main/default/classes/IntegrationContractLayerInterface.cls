public interface  IntegrationContractLayerInterface {

    String getRequestObjectJson();
    void setRequestObjectJson(String requestCode, object requestPayload);
    IntegrationContractedResponseInterface getResponseContractedDetails();
    void setResponseContractedDetails(string responseJson,String contractedResponseClass);

}