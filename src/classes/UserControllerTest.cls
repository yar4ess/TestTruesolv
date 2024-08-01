@isTest
private class UserControllerTest {

	@isTest
	static void testGetCurrentUser() {
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

		String uniqueUsername = 'testuser' + String.valueOf(Math.random()).replace('.', '') + '@example.com';

		User testUser = new User(
				Username = uniqueUsername,
				Email = 'testuser@example.com',
				LastName = 'User',
				Alias = 'tuser',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				ProfileId = profile.Id,
				LanguageLocaleKey = 'en_US',
				IsManager__c = true
		);

		System.runAs(testUser) {
			Test.startTest();
			User currentUser = UserController.getCurrentUser();
			Test.stopTest();

			System.assertNotEquals(null, currentUser, 'User should not be null');
			System.assertEquals(testUser.Id, currentUser.Id, 'User Id should match the test user Id');
			System.assertEquals(testUser.IsManager__c, currentUser.IsManager__c, 'IsManager field should match');
		}
	}
}
