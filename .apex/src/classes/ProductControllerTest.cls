@isTest
private class ProductControllerTest {

	@isTest
	static void testGetUniqueFamilies() {
		Product__c product1 = new Product__c(Name='Product1', Family__c='New', Type__c='Books');
		Product__c product2 = new Product__c(Name='Product2', Family__c='Boo', Type__c='Food');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<AggregateResult> families = ProductController.getUniqueFamilies();
		Test.stopTest();

		System.assertEquals(2, families.size(), 'Should return 2 unique families');
	}

	@isTest
	static void testGetUniqueTypes() {
		Product__c product1 = new Product__c(Name='Product1', Family__c='Decommissioned', Type__c='Clothes');
		Product__c product2 = new Product__c(Name='Product2', Family__c='Decommissioned', Type__c='Electronics');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<AggregateResult> types = ProductController.getUniqueTypes();
		Test.stopTest();

		System.assertEquals(2, types.size(), 'Should return 2 unique types');
	}

	@isTest
	static void testFilteredProductsByFamily() {
		Product__c product1 = new Product__c(Name='Laptop', Family__c='New', Type__c='Electronics', Description__c='High performance laptop');
		Product__c product2 = new Product__c(Name='Book', Family__c='Boo', Type__c='Books', Description__c='Educational book');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<Product__c> filteredByFamily = ProductController.getFilteredProducts('New', null, null);
		Test.stopTest();

		System.assertEquals(1, filteredByFamily.size(), 'Should return 1 product for family New');
	}

	@isTest
	static void testFilteredProductsByType() {
		Product__c product1 = new Product__c(Name='Laptop', Family__c='New', Type__c='Electronics', Description__c='High performance laptop');
		Product__c product2 = new Product__c(Name='Book', Family__c='Boo', Type__c='Books', Description__c='Educational book');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<Product__c> filteredByType = ProductController.getFilteredProducts(null, 'Books', null);
		Test.stopTest();

		System.assertEquals(1, filteredByType.size(), 'Should return 1 product for type Books');
	}

	@isTest
	static void testFilteredProductsByKeyword() {
		Product__c product1 = new Product__c(Name='Laptop', Family__c='New', Type__c='Electronics', Description__c='High performance laptop');
		Product__c product2 = new Product__c(Name='Book', Family__c='Boo', Type__c='Books', Description__c='Educational book');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<Product__c> filteredByKeyword = ProductController.getFilteredProducts(null, null, 'laptop');
		Test.stopTest();

		System.assertEquals(1, filteredByKeyword.size(), 'Should return 1 product for keyword laptop');
	}

	@isTest
	static void testFilteredProductsByFamilyAndType() {
		Product__c product1 = new Product__c(Name='Laptop', Family__c='New', Type__c='Electronics', Description__c='High performance laptop');
		Product__c product2 = new Product__c(Name='Book', Family__c='Boo', Type__c='Books', Description__c='Educational book');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<Product__c> filteredByFamilyAndType = ProductController.getFilteredProducts('Boo', 'Books', null);
		Test.stopTest();

		System.assertEquals(1, filteredByFamilyAndType.size(), 'Should return 1 product for family Boo and type Books');
	}

	@isTest
	static void testFilteredProductsByAllFilters() {
		Product__c product1 = new Product__c(Name='Laptop', Family__c='New', Type__c='Electronics', Description__c='High performance laptop');
		Product__c product2 = new Product__c(Name='Book', Family__c='Boo', Type__c='Books', Description__c='Educational book');
		insert new List<Product__c>{product1, product2};

		Test.startTest();
		List<Product__c> filteredByAll = ProductController.getFilteredProducts('New', 'Electronics', 'performance');
		Test.stopTest();

		System.assertEquals(1, filteredByAll.size(), 'Should return 1 product for all filters applied');
	}
}
