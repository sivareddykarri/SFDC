/***
@Author :     Vazeer
@Name   :     Bot_REST_Utils_Test
@Created Date: 9/12/2019
@Description: Test class to cover Bot_REST_Utils Class
@Version:0.1
@Reference: 
**/
@isTest
global class Bot_REST_Utils_Test{
    // Implement this interface method
     static testMethod void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new CalloutClassTest());  
        Boolean strResp = Bot_REST_Utils.getButtonAvailablityForTransfer('00D6C0000009TZw','5736C000000002c','5721I000000hAQo');
    }
}