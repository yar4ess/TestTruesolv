import { LightningElement, track, wire } from 'lwc';
//import getAccountDetails from '@salesforce/apex/OrderManagementController.getAccountDetails';
//import getProductList from '@salesforce/apex/OrderManagementController.getProductList';

export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [];
    @track familyOptions = [];
    @track filteredProducts = [];
//
//    @wire(getAccountDetails) wiredAccount({ error, data }) {
//        if (data) {
//            this.accountName = data.Name;
//            this.accountNumber = data.AccountNumber;
//        } else if (error) {
//            // Обработка ошибок
//        }
//    }
//
//    @wire(getProductList) wiredProducts({ error, data }) {
//        if (data) {
//            this.filteredProducts = data;
//        } else if (error) {
//            // Обработка ошибок
//        }
//    }

    handleTypeChange(event) {
        // Логика фильтрации по Type
    }

    handleFamilyChange(event) {
        // Логика фильтрации по Family
    }

    handleSearch(event) {
        // Логика поиска
    }

    handleCreateProduct() {
        // Логика для создания продукта
    }

    handleOpenCart() {
        // Логика для открытия корзины
    }
}
