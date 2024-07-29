public with sharing class ProductController {
	@AuraEnabled(cacheable=true)
	public static List<Product2> getFilteredProducts(String family, String type) {
		String query = 'SELECT Id, Name, Family__c, Type__c FROM Product__c WHERE Family__c = :family AND Type__c = :type';

		if (family == null) {
			query = query.replace('Family__c = :family AND ', '');
		}
		if (type == null) {
			query = query.replace('Type__c = :type', '');
		}

		return Database.query(query);
	}
}
