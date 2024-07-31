trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete) {
	Set<Id> orderIds = new Set<Id>();

	if (Trigger.isInsert || Trigger.isUpdate) {
		for (OrderItem__c item : Trigger.new) {
			orderIds.add(item.OrderId__c);
		}
	}

	if (Trigger.isDelete) {
		for (OrderItem__c item : Trigger.old) {
			orderIds.add(item.OrderId__c);
		}
	}

	List<Order__c> ordersToUpdate = new List<Order__c>();

	for (Id orderId : orderIds) {
		AggregateResult[] groupedResults = [SELECT SUM(Quantity__c) totalProductCount, SUM(Price__c) totalPrice
		FROM OrderItem__c
		WHERE OrderId__c = :orderId
		GROUP BY OrderId__c];
		if (groupedResults.size() > 0) {
			Order__c orderToUpdate = new Order__c();
			orderToUpdate.Id = orderId;
			orderToUpdate.TotalProductCount__c = (Decimal)groupedResults[0].get('totalProductCount');
			orderToUpdate.TotalPrice__c = (Decimal)groupedResults[0].get('totalPrice');
			ordersToUpdate.add(orderToUpdate);
		}
	}

	if (!ordersToUpdate.isEmpty()) {
		update ordersToUpdate;
	}
}
