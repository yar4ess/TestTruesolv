# **Order Management** 

### You need to implement a simple one-page application to allow the user to create an order.

**### User stories:**

* As a user, I can open an Order Management page from Account layout (You need to put a button to Account layout that will open an Order Management page in separate tab)
* As a user, I can see Account Name and Number on the page
* Data Binding in a Template
* As a user, I can filter the displayed product by Family and Type
* Call Apex Method from LWC
* Render Lists in LWC
* Run code on load (ConnectedCallback)
* As a user, I can search for the product by Name and Description
* As a user, I can see product details in modal window (Details button on Product Tile)
* Modal Window
* LWC Record Edit Form
* LWC Record View Form
* As a user, I can select a product and add it to Cart (Add button on Product Tile)
* Show Toast message
* As a user, I can see products in the Cart (Cart button will open a modal with selected products in table view)
* As a user, I can check out a Cart (Checkout button on Cart Modal) This action will create Order and Order Item records.
* TotalProductCount__c and TotalPrice__c on Order__c object should be calculated automatically in a Trigger based on Order Items records.
* Apex Trigger
* As a user, after checking out the cart I should be redirected to the standard Order layout to see created Order and Order Items
* As a manager, I should have the ability to create a new product in the modal window. (Create a Product button. The button should be available only for users with IsManager__c = true)
* Render DOM Elements Conditionally
* To fill out Image field on the Product object you need to send a request to http://www.glyffix.com/api/Image?word={PRODUCT_NAME}, where {PRODUCT_NAME} is the name of the created product and put the link to the Image field. More information about the API you can find here. Example of the request below:

### **Tools:**
1.     Salesforce Dev Org - Salesforce Developer Portal
2.     IDE - IntelliJ IDEA + JetForcer
3.     Backend - Apex - Apex Developer Guide
4.     Client-Side - LWC - LWC Docs
5.     Styles - Lightning Design System - SLDS



