@isTest
private class ProductImageServiceTest {

	@isTest
	static void testFetchAndSetProductImage() {
		Product__c testProduct = new Product__c(
				Name = 'Test Product',
				Price__c = 1000,
				Family__c = 'New',
				Type__c = 'Food'
		);
		insert testProduct;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		Test.startTest();
		ProductImageService.fetchAndSetProductImage(testProduct.Id);
		Test.stopTest();
		Product__c updatedProduct = [SELECT Id, Name, Image__c FROM Product__c WHERE Id = :testProduct.Id LIMIT 1];
		System.assertNotEquals(null, updatedProduct.Image__c, 'Image URL should be set');
		System.assertEquals('http://www.glyffix.com/Image/ShowUploadedImage/5797', updatedProduct.Image__c, 'Image URL should match the mock response');
	}

	private class MockHttpResponseGenerator implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"success":true,"word":"Test Product","rowcount":1,"data":[{"id":5797,"imageurl":"http://www.glyffix.com/Image/ShowUploadedImage/5797"}],"errormessage":""}');
			res.setStatusCode(200);
			return res;
		}
	}
}

//@isTest
//private class ProductImageServiceTest {
//
//	@isTest
//	static void testFetchAndSetProductImage() {
//		Product__c testProduct = new Product__c(
//				Name = 'Coffee',
//				Price__c = 1000,
//				Family__c = 'New',
//				Type__c = 'Food'
//		);
//		insert testProduct;
//
//		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
//		Test.startTest();
//		ProductImageService.fetchAndSetProductImage(testProduct.Id);
//		Test.stopTest();
//		Product__c updatedProduct = [SELECT Id, Name, Image__c FROM Product__c WHERE Id = :testProduct.Id LIMIT 1];
////		System.assertNotEquals(null, updatedProduct.Image__c, 'Image URL should be set');
//		System.assertEquals('http://www.glyffix.com/Image/ShowUploadedImage/2131', updatedProduct.Image__c, 'Image URL should match the mock response');
//	}
//
//	private class MockHttpResponseGenerator implements HttpCalloutMock {
//		public HTTPResponse respond(HTTPRequest req) {
//			HttpResponse res = new HttpResponse();
//			res.setHeader('Content-Type', 'application/json');
//			res.setBody('{"success":true,"word":"Test Product","rowcount":1,"data":[{"id":2131,"http://www.glyffix.com/Image/ShowUploadedImage/2131"}],"errormessage":""}');
//			res.setStatusCode(200);
//			return res;
//		}
//	}
//}
