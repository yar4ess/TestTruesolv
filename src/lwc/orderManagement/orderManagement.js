import { LightningElement, track, wire, api } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';
import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';
import getUniqueFamilies from '@salesforce/apex/ProductController.getUniqueFamilies';
import getUniqueTypes from '@salesforce/apex/ProductController.getUniqueTypes';
import createOrderAndItems from '@salesforce/apex/OrderController.createOrderAndItems';
import getCurrentUser from '@salesforce/apex/UserController.getCurrentUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderManagement extends LightningElement {
    @track accountName;
    @track accountNumber;
    @track typeOptions = [{ label: 'All Types', value: '' }];
    @track familyOptions = [{ label: 'All Families', value: '' }];
    @track filteredProducts = [];
    @track cartProducts = [];
    @track isModalOpen = false;
    @track isCartModalOpen = false;
    @track selectedProductId;
    selectedFamily = '';
    selectedType = '';
    @track searchKeyword = '';
    @track isManager = false;
    @track isCreateProductModalOpen = false;
    @api recordId;

    @wire(getAccountDetails, { accountId: '$recordId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.Name;
            this.accountNumber = data.AccountNumber;
        } else if (error) {
            console.error('Account error:', error);
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
                    if (family.Family__c) {
                        this.familyOptions.push({ label: family.Family__c, value: family.Family__c });
                    }
                });
            })
            .catch(error => {
                console.error('Error fetching families:', error);
            });

        getUniqueTypes()
            .then(result => {
                this.typeOptions = [{ label: 'All Types', value: '' }];
                result.forEach(type => {
                    if (type.Type__c) {
                        this.typeOptions.push({ label: type.Type__c, value: type.Type__c });
                    }
                });
            })
            .catch(error => {
                console.error('Error fetching types:', error);
            });
    }

    fetchProducts() {
        getFilteredProducts({ family: this.selectedFamily, type: this.selectedType, keyword: this.searchKeyword })
            .then(result => {
                this.filteredProducts = result;
                if (result.length === 0) {
                    const toastEvent = new ShowToastEvent({
                        title: 'No Products Found',
                        message: 'No products match the search criteria.',
                        variant: 'warning',
                    });
                    this.dispatchEvent(toastEvent);
                }
            })
            .catch(error => {
                console.error('Error fetching products:', error);
            });
    }

    handleTypeChange(event) {
        this.selectedType = event.detail.value;
        this.fetchProducts();
    }

    handleFamilyChange(event) {
        this.selectedFamily = event.detail.value;
        this.fetchProducts();
    }

    handleKeywordChange(event) {
        this.searchKeyword = event.target.value;
    }

    handleSearch() {
        this.fetchProducts();
    }

    handleDetailsClick(event) {
        this.selectedProductId = event.target.dataset.id;
        this.isModalOpen = true;
    }

    handleAddToCart(event) {
        const productId = event.target.dataset.id;
        const product = this.filteredProducts.find(prod => prod.Id === productId);
        if (product) {
            this.cartProducts.push(product);
            const toastEvent = new ShowToastEvent({
                title: 'Product Added',
                message: `${product.Name} has been added to the cart.`,
                variant: 'success',
            });
            this.dispatchEvent(toastEvent);
        }
    }

    handleOpenCart() {
        this.isCartModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }

    closeCartModal() {
        this.isCartModalOpen = false;
    }

    handleCheckout() {
        createOrderAndItems({ cartProducts: this.cartProducts })
            .then(result => {
                this.cartProducts = [];
                this.isCartModalOpen = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Order Created',
                        message: 'Your order has been successfully created.',
                        variant: 'success',
                    })
                );
            })
            .catch(error => {
                console.error('Error creating order:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'There was an issue creating your order.',
                        variant: 'error',
                    })
                );
            });
    }

    openCreateProductModal() {
        if (this.isManager) {
            this.isCreateProductModalOpen = true;
        }
    }

    closeCreateProductModal() {
        this.isCreateProductModalOpen = false;
    }

    handleProductCreationSuccess(event) {
        this.closeCreateProductModal();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Product created successfully',
                variant: 'success'
            })
        );
    }

    @wire(getCurrentUser)
    wiredUser({ error, data }) {
        if (data) {
            this.isManager = data.IsManager__c;
            console.log('User isManager:', this.isManager);
        } else if (error) {
            console.error('Error fetching user data:', error);
        }
    }
}
