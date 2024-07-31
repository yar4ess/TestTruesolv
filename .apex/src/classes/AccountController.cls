public with sharing class AccountController {
	@AuraEnabled(cacheable=true)
	public static Account getAccountDetails(Id accountId) {
		System.debug('Account Id: ' + accountId);
		return [SELECT Name, AccountNumber FROM Account WHERE Id = :accountId LIMIT 1];
	}
}
