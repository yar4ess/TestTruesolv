public with sharing class OrderController {
	@AuraEnabled
	public static void createOrderAndItems(List<Product__c> cartProducts) {
		Order__c newOrder = new Order__c();
		newOrder.Name = 'Order - ' + Datetime.now();
		insert newOrder;

		List<OrderItem__c> orderItems = new List<OrderItem__c>();
		for (Product__c product : cartProducts) {
			OrderItem__c orderItem = new OrderItem__c();
			orderItem.OrderId__c = newOrder.Id;
			orderItem.ProductId__c = product.Id;
			orderItem.Quantity__c = 1; // Пример значения
			orderItem.Price__c = product.Price__c; // Предполагается, что в продукте есть поле Price__c
			orderItems.add(orderItem);
		}
		insert orderItems;
	}
}
