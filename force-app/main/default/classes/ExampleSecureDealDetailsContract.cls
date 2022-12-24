public with sharing class ExampleSecureDealDetailsContract extends IntegrationLayerVirtualClass {
	// Class implementing three different types of contracts, 
	// each contract will supply return different data to the caller based on user's persona  
    
    // Contract for full deal details
    public class DealContractedResponse implements IntegrationContractedResponseInterface{
        public String dealCode {get;set;}
        public String details {get;set;}
        public Date closeDate {get;set;}
        public Decimal amount {get;set;}
        public String owner {get;set;}
        public String customer {get;set;}
    }
    
    // Contract for limited deal details
    public class DealContractedResponse_Limited implements IntegrationContractedResponseInterface{
        public String dealCode {get;set;}
        public String details {get;set;}
    }   
	
    // Contract for partails deal details
    public class DealContractedResponse_Partial implements IntegrationContractedResponseInterface{
        public String dealCode {get;set;}
        public String details {get;set;}
        public Date closeDate {get;set;}
        public String customer {get;set;}

    }   
}