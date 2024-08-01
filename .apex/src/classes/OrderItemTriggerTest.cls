@isTest
private class OrderItemTriggerTest {

	@isTest
	static void testBeforeInsert() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 100,
				Family__c = 'New',
				Type__c = 'Electronics'
		);
		insert testProduct;

		Order__c testOrder = new Order__c(
				Name = 'Test Order'
		);
		insert testOrder;

		OrderItem__c orderItem = new OrderItem__c(
				OrderId__c = testOrder.Id,
				ProductId__c = testProduct.Id,
				Quantity__c = 2
		);

		Test.startTest();
		insert orderItem;
		Test.stopTest();

		OrderItem__c insertedItem = [SELECT Price__c FROM OrderItem__c WHERE Id = :orderItem.Id];
		System.assertEquals(testProduct.Price__c, insertedItem.Price__c, 'Price should match the product price');
	}

	@isTest
	static void testBeforeUpdate() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 100,
				Family__c = 'New',
				Type__c = 'Electronics'
		);
		insert testProduct;

		Order__c testOrder = new Order__c(
				Name = 'Test Order'
		);
		insert testOrder;

		OrderItem__c orderItem = new OrderItem__c(
				OrderId__c = testOrder.Id,
				ProductId__c = testProduct.Id,
				Quantity__c = 2
		);
		insert orderItem;

		orderItem.Quantity__c = 3;
		Test.startTest();
		update orderItem;
		Test.stopTest();

		OrderItem__c updatedItem = [SELECT Price__c, Quantity__c FROM OrderItem__c WHERE Id = :orderItem.Id];
		System.assertEquals(testProduct.Price__c, updatedItem.Price__c, 'Price should remain unchanged');
		System.assertEquals(3, updatedItem.Quantity__c, 'Quantity should be updated');
	}

	@isTest
	static void testAfterInsert() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 100,
				Family__c = 'New',
				Type__c = 'Electronics'
		);
		insert testProduct;

		Order__c testOrder = new Order__c(
				Name = 'Test Order'
		);
		insert testOrder;

		OrderItem__c orderItem = new OrderItem__c(
				OrderId__c = testOrder.Id,
				ProductId__c = testProduct.Id,
				Quantity__c = 2
		);

		Test.startTest();
		insert orderItem;
		Test.stopTest();

		Order__c updatedOrder = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :testOrder.Id];
		System.assertEquals(2, updatedOrder.TotalProductCount__c, 'Total product count should be 2');
		System.assertEquals(200, updatedOrder.TotalPrice__c, 'Total price should be 200');
	}

	@isTest
	static void testAfterUpdate() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 100,
				Family__c = 'New',
				Type__c = 'Electronics'
		);
		insert testProduct;

		Order__c testOrder = new Order__c(
				Name = 'Test Order'
		);
		insert testOrder;

		OrderItem__c orderItem = new OrderItem__c(
				OrderId__c = testOrder.Id,
				ProductId__c = testProduct.Id,
				Quantity__c = 2
		);
		insert orderItem;

		orderItem.Quantity__c = 3;
		Test.startTest();
		update orderItem;
		Test.stopTest();

		Order__c updatedOrder = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :testOrder.Id];
		System.assertEquals(3, updatedOrder.TotalProductCount__c, 'Total product count should be 3');
		System.assertEquals(300, updatedOrder.TotalPrice__c, 'Total price should be 300');
	}

//	@isTest
//	static void testAfterDelete() {
//		Product__c testProduct = new Product__c(
//				Name = 'Test Product',
//				Price__c = 100,
//				Family__c = 'New',
//				Type__c = 'Electronics'
//		);
//		insert testProduct;
//
//		Order__c testOrder = new Order__c(
//				Name = 'Test Order'
//		);
//		insert testOrder;
//
//		OrderItem__c orderItem = new OrderItem__c(
//				OrderId__c = testOrder.Id,
//				ProductId__c = testProduct.Id,
//				Quantity__c = 2
//		);
//		insert orderItem;
//
//		Test.startTest();
//		delete orderItem;
//		Test.stopTest();
//
//		Order__c updatedOrder = [SELECT TotalProductCount__c, TotalPrice__c FROM Order__c WHERE Id = :testOrder.Id];
//		System.assertEquals(0, updatedOrder.TotalProductCount__c, 'Total product count should be 0');
//		System.assertEquals(0, updatedOrder.TotalPrice__c, 'Total price should be 0');
//	}
}
