trigger OrderItemTrigger on OrderItem__c (before insert, before update, after insert, after update, after delete) {
	Set<Id> orderIds = new Set<Id>();
	Set<Id> productIds = new Set<Id>();

	// Собираем идентификаторы заказов и продуктов
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

	// Получаем цены продуктов
	Map<Id, Product__c> productMap = new Map<Id, Product__c>();
	if (!productIds.isEmpty()) {
		productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
	}

	// Обновляем цены в OrderItem
	if (Trigger.isBefore) {
		for (OrderItem__c item : Trigger.new) {
			if (item.ProductId__c != null && productMap.containsKey(item.ProductId__c)) {
				Product__c product = productMap.get(item.ProductId__c);
				item.Price__c = product.Price__c; // Устанавливаем цену из продукта
			}
		}
	}

	// Список заказов для обновления
	if (Trigger.isAfter) {
		List<Order__c> ordersToUpdate = new List<Order__c>();

		for (Id orderId : orderIds) {
			Decimal totalProductCount = 0;
			Decimal totalPrice = 0;

			// Запрос всех элементов заказа
			for (OrderItem__c item : [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId]) {
				// Проверяем, что Quantity__c и Price__c не null
				if (item.Quantity__c != null && item.Price__c != null) {
					totalProductCount += item.Quantity__c;
					totalPrice += item.Quantity__c * item.Price__c;
				}
			}

			// Проверяем, есть ли что обновлять
			if (totalProductCount > 0 || totalPrice > 0) {
				Order__c orderToUpdate = new Order__c();
				orderToUpdate.Id = orderId;
				orderToUpdate.TotalProductCount__c = totalProductCount;
				orderToUpdate.TotalPrice__c = totalPrice;

				ordersToUpdate.add(orderToUpdate);
			}
		}

		if (!ordersToUpdate.isEmpty()) {
			update ordersToUpdate;
		}
	}
}



//trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete) {
//	Set<Id> orderIds = new Set<Id>();
//	Set<Id> productIds = new Set<Id>();
//
//	// Собираем идентификаторы заказов и продуктов, которые были затронуты
//	if (Trigger.isInsert || Trigger.isUpdate) {
//		for (OrderItem__c item : Trigger.new) {
//			orderIds.add(item.OrderId__c);
//			productIds.add(item.ProductId__c);
//		}
//	}
//
//	if (Trigger.isDelete) {
//		for (OrderItem__c item : Trigger.old) {
//			orderIds.add(item.OrderId__c);
//		}
//	}
//
//	// Получаем цены продуктов
//	Map<Id, Product__c> productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
//
//	// Обновляем цены в OrderItem
//	if (Trigger.isInsert || Trigger.isUpdate) {
//		List<OrderItem__c> itemsToUpdate = new List<OrderItem__c>();
//		for (OrderItem__c item : Trigger.new) {
//			if (productMap.containsKey(item.ProductId__c)) {
//				Product__c product = productMap.get(item.ProductId__c);
//				item.Price__c = product.Price__c; // Устанавливаем цену из продукта
//				itemsToUpdate.add(item);
//			}
//		}
//		// Обновляем записи OrderItem в базе данных
//		if (!itemsToUpdate.isEmpty()) {
//			update itemsToUpdate;
//		}
//	}
//
//	// Список заказов для обновления (после операций с OrderItem)
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

//trigger OrderItemTrigger on OrderItem__c (after insert, after update, after delete) {
//	Set<Id> orderIds = new Set<Id>();
//	Set<Id> productIds = new Set<Id>();
//	// Собираем идентификаторы заказов, которые были затронуты
//	if (Trigger.isInsert || Trigger.isUpdate) {
//		for (OrderItem__c item : Trigger.new) {
//			orderIds.add(item.OrderId__c);
////			productIds.add(item.ProductId__c);
//		}
//	}
//
//	if (Trigger.isDelete) {
//		for (OrderItem__c item : Trigger.old) {
//			orderIds.add(item.OrderId__c);
//		}
//	}
//	// Получаем цены продуктов
//	Map<Id, Product__c> productMap = new Map<Id, Product__c>([SELECT Id, Price__c FROM Product__c WHERE Id IN :productIds]);
//
//	// Обновляем цены в OrderItem
//	if (Trigger.isInsert || Trigger.isUpdate) {
//		List<OrderItem__c> itemsToUpdate = new List<OrderItem__c>();
//		for (OrderItem__c item : Trigger.new) {
//			if (productMap.containsKey(item.ProductId__c)) {
//				Product__c product = productMap.get(item.ProductId__c);
//				item.Price__c = product.Price__c; // Устанавливаем цену из продукта
//				itemsToUpdate.add(item);
//			}
//		}
//		// Обновляем записи OrderItem в базе данных
//		if (!itemsToUpdate.isEmpty()) {
//			update itemsToUpdate;
//		}
//	}
//	// Список заказов для обновления
//	List<Order__c> ordersToUpdate = new List<Order__c>();
//
//	// Проходим по каждому заказу
//	for (Id orderId : orderIds) {
//		Decimal totalProductCount = 0;
//		Decimal totalPrice = 0;
//
//		// Запрос всех элементов заказа
//		for (OrderItem__c item : [SELECT Quantity__c, Price__c FROM OrderItem__c WHERE OrderId__c = :orderId]) {
//			// Проверяем, что Quantity__c и Price__c не null
//			if (item.Quantity__c != null && item.Price__c != null) {
//				totalProductCount += item.Quantity__c;
//				totalPrice += item.Quantity__c * item.Price__c;
//			}
//		}
//
//		// Проверяем, есть ли что обновлять
//		if (totalProductCount >= 0 || totalPrice >= 0) {
//			Order__c orderToUpdate = new Order__c();
//			orderToUpdate.Id = orderId;
//			orderToUpdate.TotalProductCount__c = totalProductCount; // Преобразование Decimal в Integer
//			orderToUpdate.TotalPrice__c = totalPrice;
//
//			ordersToUpdate.add(orderToUpdate);
//		}
//	}
//
//	// Обновление заказов
//	if (!ordersToUpdate.isEmpty()) {
//		update ordersToUpdate;
//	}
//}




