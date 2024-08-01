@isTest
public class AccountControllerTest {

	@isTest
	static void testGetAccountDetails() {
		// Создание тестового аккаунта
		Account testAccount = new Account(
				Name = 'Test Account',
				AccountNumber = '123456'
		);
		insert testAccount;

		// Вызов тестируемого метода
		Account result = AccountController.getAccountDetails(testAccount.Id);

		// Проверка результатов
		System.assert(result != null, 'Account should not be null');
		System.assertEquals('Test Account', result.Name, 'Account Name should match');
		System.assertEquals('123456', result.AccountNumber, 'Account Number should match');
	}
}
