trigger ProductTrigger on Product__c (after insert, after update) {
	for (Product__c product : Trigger.new) {
		if (product.Image__c == null) {
			ProductImageService.fetchAndSetProductImage(product.Id);
		}
	}
}
