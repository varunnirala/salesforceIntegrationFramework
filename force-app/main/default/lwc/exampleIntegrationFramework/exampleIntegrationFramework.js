import { LightningElement, wire, track } from 'lwc';
import getDealDetails from '@salesforce/apex/ExampleDealLWCController.getDealDetails';
export default class ExampleIntegrationFramework extends LightningElement {
    dealDetails;
    error;
    handleSearch() {
        getDealDetails().then((result) => {
                    console.log(result);
                    this.dealDetails=JSON.stringify(result);
                })
                .catch((error) => {
                    console.log(error);
                    this.dealDetails = error
                    alert("error");
                });
    }
}