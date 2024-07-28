import { LightningElement, track, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';

export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [];
    @track familyOptions = [];
    @track filteredProducts = [];
    // Получение данных об аккаунте
    @wire(getAccountDetails, { accountId: '$recordId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.Name;
            this.accountNumber = data.AccountNumber;
        } else if (error) {
            console.error(error);
        }
    }
}
