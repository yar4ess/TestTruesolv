@isTest
private class ProductTriggerTest {

	@isTest
	static void testAfterInsert() {
		Test.setMock(HttpCalloutMock.class, new ProductImageServiceMock());

		Product__c testProduct = new Product__c(
				Name = 'Test Product Without Image',
				Family__c = 'New',
				Type__c = 'Food'
		);

		Test.startTest();
		insert testProduct;
		Test.stopTest();

		Product__c insertedProduct = [SELECT Id, Image__c FROM Product__c WHERE Id = :testProduct.Id LIMIT 1];
		System.assertNotEquals(null, insertedProduct.Image__c, 'Image__c should not be null');
	}

	@isTest
	static void testAfterUpdateWithImage() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product With Image',
				Family__c = 'New',
				Type__c = 'Electronics',
				Image__c = 'http://example.com/image.png'
		);
		insert testProduct;

		testProduct.Name = 'Updated Test Product';

		Test.startTest();
		update testProduct;
		Test.stopTest();

		Product__c updatedProduct = [SELECT Id, Image__c FROM Product__c WHERE Id = :testProduct.Id LIMIT 1];
		System.assertEquals('http://example.com/image.png', updatedProduct.Image__c, 'Image__c should remain unchanged');
	}

	@isTest
	static void testAfterUpdateWithoutImage() {
		Test.setMock(HttpCalloutMock.class, new ProductImageServiceMock());

		Product__c testProduct = new Product__c(
				Name = 'Test Product Without Image',
				Family__c = 'New',
				Type__c = 'Food'
		);
		insert testProduct;
		testProduct.Name = 'Updated Test Product Without Image';

		Test.startTest();
		update testProduct;
		Test.stopTest();

		Product__c updatedProduct = [SELECT Id, Image__c FROM Product__c WHERE Id = :testProduct.Id LIMIT 1];
		System.assertNotEquals(null, updatedProduct.Image__c, 'Image__c should not be null');
	}
}
