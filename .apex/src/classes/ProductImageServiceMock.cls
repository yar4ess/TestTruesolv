@isTest
public class ProductImageServiceMock implements HttpCalloutMock {
	public HttpResponse respond(HttpRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"success": true, "data": [{"id": "12345", "imageurl": "http://example.com/image.png"}]}');
		res.setStatusCode(200);
		return res;
	}
}
