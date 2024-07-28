import { LightningElement, track, wire } from 'lwc';
export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [];
    @track familyOptions = [];
    @track filteredProducts = [];
}
