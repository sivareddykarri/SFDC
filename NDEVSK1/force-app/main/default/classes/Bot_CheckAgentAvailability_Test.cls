/***
@Author :     Vazeer
@Name   :     Bot_CheckAgentAvailability_Test
@Created Date: 9/12/2019
@Description: Test class to cover Bot_CheckAgentAvailability Class
@Version:0.1
@Reference: 
**/
@isTest
public class Bot_CheckAgentAvailability_Test {
    
    @testSetup static void dataSetup(){
		Wyndham_Constants_List__c objConstant = new Wyndham_Constants_List__c(Name='BotTransferChatButtonId',Value__c='5736C000000002b');
        Database.insert(objConstant);
    }
    /** 
    * Description: Test Method to cover checkAgentAvailability
    * @MethodName:checkAgentAvailabilityTest
    * @Created by:Vazeer
    * @parameters:Null
    * @return:Null
    */
    @isTest
    static void checkAgentAvailabilityTest(){
        Test.startTest();
        
        List<Bot_CheckAgentAvailability.AgentAvailabilityInput> inForm = new List<Bot_CheckAgentAvailability.AgentAvailabilityInput>();
        Bot_CheckAgentAvailability.AgentAvailabilityInput input= new Bot_CheckAgentAvailability.AgentAvailabilityInput();
        input.sOrgId = '00D6C0000009TZw';
        input.sLiveChatDeploymentId = '5721I000000hAQo';
        input.sLiveChatButtonForTransferId = '5736C000000002c';
        inForm.add(input);
        
        Test.setMock(HttpCalloutMock.class, new CalloutClassTest());  
        Boolean strResp = Bot_REST_Utils.getButtonAvailablityForTransfer('00D6C0000009TZw','5736C000000002c','5721I000000hAQo');
        Bot_CheckAgentAvailability.checkAgentAvailability(inForm);
        Test.stopTest();
        System.assertEquals(inForm[0].sLiveChatDeploymentId,'5721I000000hAQo');        
    }
}