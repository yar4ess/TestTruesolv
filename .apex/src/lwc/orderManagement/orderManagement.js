import { LightningElement, track, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';
import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';

export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [
        { label: 'All Types', value: '' },
        { label: 'Type1', value: 'Type1' },
        { label: 'Type2', value: 'Type2' }
    ];

    @track familyOptions = [
        { label: 'All Families', value: '' },
        { label: 'Family1', value: 'Family1' },
        { label: 'Family2', value: 'Family2' },
    ];
    @track filteredProducts = [];
    selectedFamily = '';
    selectedType = '';
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

    connectedCallback() {
        this.fetchProducts();
    }

    handleTypeChange(event) {
        this.selectedType = event.detail.value;
        this.fetchProducts();
    }

    handleFamilyChange(event) {
        this.selectedFamily = event.detail.value;
        this.fetchProducts();
    }

    fetchProducts() {
        getFilteredProducts({ family: this.selectedFamily, type: this.selectedType })
            .then(result => {
                this.filteredProducts = result;
            })
            .catch(error => {
                console.error('Error fetching products:', error);
            });
    }
}
