public class IntegrationFrameworkCalloutLayer {
/**
 * This Apex class was developed by Varun Nirala on 12/23/2022.
 *
 * This class implements following
 * Actual callout with retry
 * Provide calling interface to the caller
 * Transform HTTP response into the contract
 * 
 */
  
    public static IntegrationContractLayerInterface invoke(String integrationCode,Object requestObj){
        Integration_Framework_Metadata__mdt integrationMeta 
                = Integration_Framework_Metadata__mdt.getInstance(integrationCode);
        System.debug(integrationMeta.Content_Type__c);
        String contractedResponseClass = getContractedResponseClass(integrationMeta);
        if(contractedResponseClass==null){
          System.debug('No contract found for the loggged in user, exiting program.');
          return null;
        }
        IntegrationContractLayerInterface integrationLayer = (IntegrationContractLayerInterface)Type.forName(integrationMeta.Integration_Contract__c).newInstance();
        integrationLayer.setRequestObjectJson(integrationCode,requestObj);
        Map<String,String> integrationHeader = new Map<String,String>();
        integrationHeader.put('Content-Type' , integrationMeta.Content_Type__c);
        Map<String, String> headers = (Map<String, String>)JSON.deserialize(integrationMeta.Addition_Headers__c, Map<String, String>.class);
  		
        for(String header : headers.keySet()){
              integrationHeader.put(header , headers.get(header));
        }  
          
        String responseContent = makePostCallout(
                integrationMeta.Resource_URL__c,
                integrationHeader, 
                integrationMeta.Named_Credential__c, 
                integrationLayer.getRequestObjectJson(),
                integrationMeta.Method__c, 
                Integer.valueOf(integrationMeta.Number_of_Retry__c)
            );
        integrationLayer.setResponseContractedDetails(responseContent,contractedResponseClass);
          
        return integrationLayer;
    }

    public static String makePostCallout(String endpoint,Map<String, String> header, String namedCredential, String requestBody,String method, Integer retryCount) {
      HttpRequest req = new HttpRequest();
      req.setEndpoint('callout:'+namedCredential+endpoint);
      req.setMethod(method);
      req.setHeader('Content-Type', 'application/json');
      for (String key : header.keySet()) {
        req.setHeader(key, header.get(key));
      }
      req.setBody(requestBody);
      req.setCompressed(true);
      Http http = new Http();
      HTTPResponse res;
      try {
        if (namedCredential != null) {
          res = http.send(req);
        } else {
          res = http.send(req);
        }
        if (res.getStatusCode() == 200) {
          return res.getBody();
        } else {
          return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
      } catch (Exception e) {
        if (retryCount > 0) {
          return makePostCallout(endpoint,header,'callout:'+namedCredential, requestBody,method, retryCount - 1);
        } else {
          return 'Error: ' + e.getMessage();
        }
      }
    }

    private static String getContractedResponseClass(Integration_Framework_Metadata__mdt integrationMeta){
      String contractName = null;
      try{
          List<Integration_Framework_Response_Access__mdt> integrationPermissionSet = 
                [select Id,Permission_Set_Name__c,Response_Contract_Name__c from Integration_Framework_Response_Access__mdt 
                where Integration_Framework__c = :integrationMeta.Id ];
          
            Map<String,String> permissionSetNamesMap = new Map<String,String>();
            for(Integration_Framework_Response_Access__mdt resConfig:integrationPermissionSet){
                permissionSetNamesMap.put(resConfig.Permission_Set_Name__c,resConfig.Response_Contract_Name__c);
            }
          
          Id userId = UserInfo.getUserId();
          PermissionSetAssignment ps = [select Id,PermissionSet.Name from PermissionSetAssignment 
          where AssigneeId=:userId and IsActive=true and PermissionSet.Name in :permissionSetNamesMap.keySet() limit 1];
            
          if(ps!=null){
              contractName = permissionSetNamesMap.get(ps.PermissionSet.Name);//.Response_Contract_Name__c;
          } 
      }catch(Exception e){
        System.debug(e.getMessage());
      }
      return contractName;
    }

  }