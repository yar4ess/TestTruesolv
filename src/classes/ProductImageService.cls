public class ProductImageService {
	@future(callout=true)
	public static void fetchAndSetProductImage(String productId) {
		Product__c product = [SELECT Id, Name, Image__c FROM Product__c WHERE Id = :productId LIMIT 1];
		if (product != null) {
			String apiUrl = 'http://www.glyffix.com/api/Image?word=' + EncodingUtil.urlEncode(product.Name, 'UTF-8');
			System.debug('API URL: ' + apiUrl);
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(apiUrl);
			request.setMethod('GET');
			try {
				HttpResponse response = http.send(request);
				if (response.getStatusCode() == 200) {
					Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
					System.debug('API Response: ' + result);
					if (result != null && result.get('success') == true) {
						List<Object> dataList = (List<Object>) result.get('data');
						System.debug('Data list: ' + dataList);
						if (dataList != null && !dataList.isEmpty()) {
							Map<String, Object> data = (Map<String, Object>) dataList[0];
							String imageUrl = (String) data.get('imageurl');
							if (imageUrl != null) {
								product.Image__c = imageUrl;
								try {
									update product;
									System.debug('Product Image URL set to: ' + imageUrl);
								} catch (DmlException dmlEx) {
									System.debug('DML Exception: ' + dmlEx.getMessage());
								}
							} else {
								System.debug('Image URL is null or empty.');
							}
						} else {
							System.debug('Data list is empty or null.');
						}
					} else {
						System.debug('API response was not successful or data key is missing.');
					}
				} else {
					System.debug('HTTP Response Code: ' + response.getStatusCode());
					System.debug('HTTP Response Body: ' + response.getBody());
				}
			} catch (Exception e) {
				System.debug('Error: ' + e.getMessage());
			}
		} else {
			System.debug('Product not found.');
		}
	}
}
