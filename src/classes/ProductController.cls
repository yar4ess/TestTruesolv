public with sharing class ProductController {

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
	@AuraEnabled(cacheable=true)
	public static List<Product__c> getFilteredProducts(String family, String type, String keyword) {
		String query = 'SELECT Id, Name, Description__c FROM Product__c WHERE ';
		List<String> filters = new List<String>();

		if (family != null && family != '') {
			filters.add('Family__c = :family');
		}
		if (type != null && type != '') {
			filters.add('Type__c = :type');
		}
		if (keyword != null && keyword != '') {
			keyword = '%' + keyword + '%';
			filters.add('(Name LIKE :keyword OR Description__c LIKE :keyword)');
		}

		query += String.join(filters, ' AND ');

		return Database.query(query);
	}
}
