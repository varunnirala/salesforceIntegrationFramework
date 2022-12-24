public virtual class IntegrationLayerVirtualClass implements IntegrationContractLayerInterface{
/**
 * This Apex class was developed by Varun Nirala on 12/23/2022.
 *
 * This class facilitates the integration framework to exchange data with the caller.
 * Any contract class should extend this class (IntegrationLayerVirtualClass)
 */
    
    Object requestDetails;
    String contractedResponseClass='ContractedResponse';
    public IntegrationContractedResponseInterface contractedResponse {get;set;}

    private String integrationCode {get;set;}

    public void setRequestObjectJson(String integrationCode,Object requestPayload){
        this.requestDetails = requestPayload;
        this.integrationCode = integrationCode;
    }

    public String getRequestObjectJson(){
        if(this.requestDetails==null){
            return null;
        }
        system.debug(this.requestDetails);
        return (String)JSON.serialize(this.requestDetails);
    }

    public IntegrationContractedResponseInterface getResponseContractedDetails(){
        return this.contractedResponse;
    }

    public void setResponseContractedDetails(String responseJson,String contractedResponseClass){
        if(contractedResponseClass!=null){
            this.contractedResponseClass = contractedResponseClass;
        }
        system.debug('##############');
        system.debug(contractedResponseClass);
        System.debug( String.valueOf(this).split(':')[0]);
        String currentClassName=String.valueOf(this).split(':')[0];
        Type reponseType = Type.forName(currentClassName+'.'+contractedResponseClass);
        this.contractedResponse = (IntegrationContractedResponseInterface)JSON.deserialize(responseJson,reponseType);
    }

}