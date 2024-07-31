import { LightningElement, track, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';
import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';
import getUniqueFamilies from '@salesforce/apex/ProductController.getUniqueFamilies';
import getUniqueTypes from '@salesforce/apex/ProductController.getUniqueTypes';

export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [{ label: 'All Types', value: '' }];
    @track familyOptions = [{ label: 'All Families', value: '' }];
    @track filteredProducts = [];
    selectedFamily = '';
    selectedType = '';

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
        this.fetchFamiliesAndTypes();
        this.fetchProducts();
    }
    fetchFamiliesAndTypes() {
        getUniqueFamilies()
            .then(result => {
                this.familyOptions = [{ label: 'All Families', value: '' }];
                result.forEach(family => {
                    // Используем .get('Family__c') для получения значения поля из AggregateResult
                    this.familyOptions.push({ label: family.Family__c, value: family.Family__c });
                });
            })
            .catch(error => {
                console.error('Error fetching families:', error);
            });

        getUniqueTypes()
            .then(result => {
                this.typeOptions = [{ label: 'All Types', value: '' }];
                result.forEach(type => {
                    // Используем .get('Type__c') для получения значения поля из AggregateResult
                    this.typeOptions.push({ label: type.Type__c, value: type.Type__c });
                });
            })
            .catch(error => {
                console.error('Error fetching types:', error);
            });
    }
//    fetchFamiliesAndTypes() {
//        getUniqueFamilies()
//            .then(result => {
//                this.familyOptions = [{ label: 'All Families', value: '' }];
//                result.forEach(family => {
//                    this.familyOptions.push({ label: family, value: family });
//                });
//            })
//            .catch(error => {
//                console.error('Error fetching families:', error);
//            });
//
//        getUniqueTypes()
//            .then(result => {
//                this.typeOptions = [{ label: 'All Types', value: '' }];
//                result.forEach(type => {
//                    this.typeOptions.push({ label: type, value: type });
//                });
//            })
//            .catch(error => {
//                console.error('Error fetching types:', error);
//            });
//    }

    handleCreateProduct() {
        console.log('Create Product button clicked');
    }

    handleOpenCart() {
        console.log('Cart button clicked');
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

//import { LightningElement, track, wire } from 'lwc';
//import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';
//import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';
//
//export default class OrderManagement extends LightningElement {
//    @track accountName;
//    @track accountNumber;
//    @track typeOptions = [
//        { label: 'All Types', value: '' },
//        { label: 'Type1', value: 'Type1' },
//        { label: 'Type2', value: 'Type2' }
//    ];
//
//    @track familyOptions = [
//        { label: 'All Families', value: '' },
//        { label: 'Family1', value: 'Family1' },
//        { label: 'Family2', value: 'Family2' },
//    ];
//    @track filteredProducts = [];
//    selectedFamily = '';
//    selectedType = '';
//    // Получение данных об аккаунте
//    @wire(getAccountDetails, { accountId: '$recordId' })
//    wiredAccount({ error, data }) {
//        if (data) {
//            this.accountName = data.Name;
//            this.accountNumber = data.AccountNumber;
//        } else if (error) {
//            console.error(error);
//        }
//    }
//    handleCreateProduct() {
//        console.log('Create Product button clicked');
//    }
//
//    handleOpenCart() {
//        console.log('Cart button clicked');
//    }
//
//    connectedCallback() {
//        this.fetchProducts();
//    }
//
//    handleTypeChange(event) {
//        this.selectedType = event.detail.value;
//        this.fetchProducts();
//    }
//
//    handleFamilyChange(event) {
//        this.selectedFamily = event.detail.value;
//        this.fetchProducts();
//    }
//
//    fetchProducts() {
//        getFilteredProducts({ family: this.selectedFamily, type: this.selectedType })
//            .then(result => {
//                this.filteredProducts = result;
//            })
//            .catch(error => {
//                console.error('Error fetching products:', error);
//            });
//    }
//}
