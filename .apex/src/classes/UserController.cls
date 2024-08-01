public with sharing class UserController {
	@AuraEnabled
	public static User getCurrentUser() {
		User currentUser = [SELECT Id, Name, IsManager__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		return currentUser;
	}
}
