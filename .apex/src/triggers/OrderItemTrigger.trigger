//trigger OrderItemTrigger on OrderItem__c (before insert, before update, after insert, after update, after delete) {
//	Set<Id> orderIds = new Set<Id>();
//	Set<Id> productIds = new Set<Id>();
//
//	if (Trigger.isBefore || Trigger.isAfter) {
//		for (OrderItem__c item : Trigger.new) {
//			if (item.OrderId__c != null) {
//				orderIds.add(item.OrderId__c);
//			}
//			if (item.ProductId__c != null) {
//				productIds.add(item.ProductId__c);
//			}
//		}
//	}
//
//	if (Trigger.isDelete) {
//		for (OrderItem__c item : Trigger.old) {
//			if (item.OrderId__c != null) {
//				orderIds.add(item.OrderId__c);
//			}
//		}
//	}
//
//	Map<Id, Product__c> productMap = new Map<Id, Product__c>();
//	if (!productIds.isEmpty()) {
//		productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
//	}
//
//	if (Trigger.isBefore) {
//		for (OrderItem__c item : Trigger.new) {
//			if (item.ProductId__c != null && productMap.containsKey(item.ProductId__c)) {
//				Product__c product = productMap.get(item.ProductId__c);
//				item.Price__c = product.Price__c;
//			}
//		}
//	}
//
//	if (Trigger.isAfter) {
//		List<Order__c> ordersToUpdate = new List<Order__c>();
//
//		for (Id orderId : orderIds) {
//			Decimal totalProductCount = 0;
//			Decimal totalPrice = 0;
//
//			for (OrderItem__c item : [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId]) {
//				if (item.Quantity__c != null && item.Price__c != null) {
//					totalProductCount += item.Quantity__c;
//					totalPrice += item.Quantity__c * item.Price__c;
//				}
//			}
//
//			if (totalProductCount > 0 || totalPrice > 0) {
//				Order__c orderToUpdate = new Order__c();
//				orderToUpdate.Id = orderId;
//				orderToUpdate.TotalProductCount__c = totalProductCount;
//				orderToUpdate.TotalPrice__c = totalPrice;
//
//				ordersToUpdate.add(orderToUpdate);
//			}
//		}
//
//		if (!ordersToUpdate.isEmpty()) {
//			update ordersToUpdate;
//		}
//	}
//}
//trigger OrderItemTrigger on OrderItem__c (before insert, before update, after insert, after update, after delete) {
//	Set<Id> orderIds = new Set<Id>();
//	Set<Id> productIds = new Set<Id>();
//
//	if (Trigger.isBefore || Trigger.isAfter) {
//		for (OrderItem__c item : Trigger.new) {
//			if (item.OrderId__c != null) {
//				orderIds.add(item.OrderId__c);
//			}
//			if (item.ProductId__c != null) {
//				productIds.add(item.ProductId__c);
//			}
//		}
//	}
//
//	if (Trigger.isDelete) {
//		for (OrderItem__c item : Trigger.old) {
//			if (item.OrderId__c != null) {
//				orderIds.add(item.OrderId__c);
//			}
//		}
//	}
//
//	Map<Id, Product__c> productMap = new Map<Id, Product__c>();
//	if (!productIds.isEmpty()) {
//		productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
//	}
//
//	if (Trigger.isBefore) {
//		for (OrderItem__c item : Trigger.new) {
//			if (item.ProductId__c != null && productMap.containsKey(item.ProductId__c)) {
//				Product__c product = productMap.get(item.ProductId__c);
//				item.Price__c = product.Price__c;
//			}
//		}
//	}
//
//	if (Trigger.isAfter || Trigger.isDelete) {
//		List<Order__c> ordersToUpdate = new List<Order__c>();
//
//		for (Id orderId : orderIds) {
//			Decimal totalProductCount = 0;
//			Decimal totalPrice = 0;
//
//			for (OrderItem__c item : [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId]) {
//				if (item.Quantity__c != null && item.Price__c != null) {
//					totalProductCount += item.Quantity__c;
//					totalPrice += item.Quantity__c * item.Price__c;
//				}
//			}
//
//			if (totalProductCount > 0 || totalPrice > 0) {
//				Order__c orderToUpdate = new Order__c();
//				orderToUpdate.Id = orderId;
//				orderToUpdate.TotalProductCount__c = totalProductCount;
//				orderToUpdate.TotalPrice__c = totalPrice;
//
//				ordersToUpdate.add(orderToUpdate);
//			}
//		}
//
//		if (!ordersToUpdate.isEmpty()) {
//			update ordersToUpdate;
//		}
//	}
//}

trigger OrderItemTrigger on OrderItem__c (before insert, before update, after insert, after update, after delete) {
	Set<Id> orderIds = new Set<Id>();
	Set<Id> productIds = new Set<Id>();

	if (Trigger.isBefore || Trigger.isAfter) {
		for (OrderItem__c item : Trigger.new) {
			if (item.OrderId__c != null) {
				orderIds.add(item.OrderId__c);
			}
			if (item.ProductId__c != null) {
				productIds.add(item.ProductId__c);
			}
		}
	}

	if (Trigger.isDelete) {
		for (OrderItem__c item : Trigger.old) {
			if (item.OrderId__c != null) {
				orderIds.add(item.OrderId__c);
			}
		}
	}

	Map<Id, Product__c> productMap = new Map<Id, Product__c>();
	if (!productIds.isEmpty()) {
		productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
	}

	if (Trigger.isBefore) {
		for (OrderItem__c item : Trigger.new) {
			if (item.ProductId__c != null && productMap.containsKey(item.ProductId__c)) {
				Product__c product = productMap.get(item.ProductId__c);
				item.Price__c = product.Price__c;
			}
		}
	}

	if (Trigger.isAfter || Trigger.isDelete) {
		List<Order__c> ordersToUpdate = new List<Order__c>();

		for (Id orderId : orderIds) {
			Decimal totalProductCount = 0;
			Decimal totalPrice = 0;

			for (OrderItem__c item : [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId]) {
				if (item.Quantity__c != null && item.Price__c != null) {
					totalProductCount += item.Quantity__c;
					totalPrice += item.Quantity__c * item.Price__c;
				}
			}

			if (totalProductCount > 0 || totalPrice > 0) {
				Order__c orderToUpdate = new Order__c();
				orderToUpdate.Id = orderId;
				orderToUpdate.TotalProductCount__c = totalProductCount;
				orderToUpdate.TotalPrice__c = totalPrice;

				ordersToUpdate.add(orderToUpdate);
			} else {
				Order__c orderToUpdate = new Order__c();
				orderToUpdate.Id = orderId;
				orderToUpdate.TotalProductCount__c = 0;
				orderToUpdate.TotalPrice__c = 0;
				ordersToUpdate.add(orderToUpdate);
			}
		}

		if (!ordersToUpdate.isEmpty()) {
			update ordersToUpdate;
		}
	}
}

