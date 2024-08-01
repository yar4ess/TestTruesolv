public with sharing class UserController {
	@AuraEnabled
	public static User getCurrentUser() {
		// Выполнение SOQL-запроса для получения текущего пользователя
		User currentUser = [SELECT Id, Name, IsManager__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

		// Отладочное сообщение для проверки данных
		System.debug('Current User Info: ' + currentUser);
		System.debug('User Id: ' + currentUser.Id);
		System.debug('User Name: ' + currentUser.Name);
		System.debug('IsManager: ' + currentUser.IsManager__c);

		return currentUser;
	}
}
