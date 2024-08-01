@isTest
private class OrderControllerTest {
	@isTest
	static void testCreateOrderAndItems() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 1000,
				Family__c = 'New',
				Type__c = 'Electronics'
		);
		insert testProduct;
		List<Product__c> cartProducts = new List<Product__c>{testProduct};
		Test.startTest();
		OrderController.createOrderAndItems(cartProducts);
		Test.stopTest();
		List<Order__c> orders = [SELECT Id, Name FROM Order__c];
		System.assertEquals(1, orders.size(), 'Order should be created');
		Order__c createdOrder = orders[0];
		List<OrderItem__c> orderItems = [SELECT Id, OrderId__c, ProductId__c, Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :createdOrder.Id];
		System.assertEquals(1, orderItems.size(), 'OrderItem should be created');
		System.assertEquals(testProduct.Id, orderItems[0].ProductId__c, 'Product ID should match');
		System.assertEquals(1, orderItems[0].Quantity__c, 'Quantity should be 1');
		System.assertEquals(testProduct.Price__c, orderItems[0].Price__c, 'Price should match product price');
	}
}
