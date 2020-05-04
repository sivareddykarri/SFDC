/***
@Author :     Vazeer
@Name   :     CalloutClassTest
@Created Date: 9/12/2019
@Description: Test class to cover all BotRestUtils and BotCheckAgentAvailability
@Version:0.1
@Reference: 
**/
@isTest
global class CalloutClassTest implements HttpCalloutMock {
    /**
    * Description:Implement this interface method
    * @MethodName:HTTPResponse
    * @Created by:Vazeer
    */
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint and method.
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('X-LIVEAGENT-API-VERSION', '42');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}