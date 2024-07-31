public with sharing class ProductController {
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getFilteredProducts(String family, String type) {
		String query = 'SELECT Id, Name, Family__c, Type__c FROM Product__c WHERE Family__c = :family AND Type__c = :type';

		if (family == null) {
			query = query.replace('Family__c = :family AND ', '');
		}
		if (type == null) {
			query = query.replace('Type__c = :type', '');
		}
		return Database.query(query);
	}
	
	@AuraEnabled(cacheable=true)
	public static List<AggregateResult> getUniqueFamilies() {
		List<AggregateResult> families = [SELECT Family__c FROM Product__c WHERE Family__c != NULL GROUP BY Family__c];
		return families;
	}

	@AuraEnabled(cacheable=true)
	public static List<AggregateResult> getUniqueTypes() {
		List<AggregateResult> types = [SELECT Type__c FROM Product__c WHERE Type__c != NULL GROUP BY Type__c];
		return types;
	}
}
