/***
@Author :     Prajwal
@Name   :     LiveChatTranscriptTriggerHelperBotTest
@Created Date: 9/12/2019
@Description: Test class to cover all Bot operations code on LiveChatTranscriptTriggerHelper
@Version:0.2
@Reference: 
**/
@isTest
public class LiveChatTranscriptTriggerHelperBotTest {
    /**
    * Description: Test Data Setup
    * @MethodName:setupChatTranscriptRecord
    * @Created by:Prajwal
    */
    @testSetup
    private static void setupChatTranscriptRecord(){
    
        Account acc=ApexDataUtil.createSiteRecTypeRecord();
        Contact objCon = ApexDataUtil.createContactRecUsingParams(acc,'test','hello', '7878787878', 'con@gmail.com');        
        Case objCase = ApexDataUtil.createCaseRecord(acc, objCon);
        objCase.Case_Subject__c=Null;
        Database.update(objCase);
        Case objCase1 = ApexDataUtil.createCaseRecord(acc, objCon);
        objCase1.Case_Subject__c='Other';
        objCase1.Subject='Test Subject';
        Database.update(objCase1);
        String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE id = : objcase1.id].caseNumber;
        
        Id liveChatVisitorId = LiveChatTranscriptTriggerHelperTest.createLiveChatVisitorId(); 
        Id chatbutton7 = [SELECT Id,DeveloperName FROM LiveChatButton WHere DeveloperName='How_do_I_Formerly_Operations_Support_Desk_OSD_L1_General_Chat' LIMIT 1].Id;
        Id chatbutton2 = [SELECT Id,DeveloperName FROM LiveChatButton WHere DeveloperName='Get_status_of_an_existing_request_ticket_OSD_L1_General_Chat' LIMIT 1].Id;
        
        Livechattranscript lct=ApexDataUtil.CreateChatTranscript(acc, objCon);
        lct.LiveChatVisitorId=liveChatVisitorId;
        lct.Updated_Account_Site_Number__c=acc.EXT_Site_Id__c;
        lct.ContactId=objCon.Id;
        lct.LiveChatButtonId=chatbutton7;
        lct.ChatKey='12345asdfg231af';
        lct.status='InProgress';
        Database.insert(lct); 
        
        Livechattranscript lct2=ApexDataUtil.CreateChatTranscript(acc, objCon);
        lct2.LiveChatVisitorId=liveChatVisitorId;
        lct2.ContactId=objCon.Id;
        lct2.LiveChatButtonId=chatbutton2;
        lct2.Case_Number__c=caseNumber;
        lct2.ChatKey='12345asdfg232bd';
        lct2.status='InProgress';
        Database.insert(lct2);
    }
    
    /** 
    * Description: Test Method to Get custom pre-chat data & CreateFAQ methods on LiveAgentTriggerHelpermethods.
    * @MethodName:botFunctionalityTest
    * @Created by:Prajwal
    * @parameters:Null
    * @return:Null
    */
    private static testmethod void botFunctionalityTest(){
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                LiveChatTranscriptTriggerHelper.PrechatInput pcinput = new LiveChatTranscriptTriggerHelper.PrechatInput();
                List<LiveChatTranscript> lctList=new List<LiveChatTranscript>();
                List<LiveChatTranscriptTriggerHelper.PrechatInput> keyList=new List<LiveChatTranscriptTriggerHelper.PrechatInput>();                
				LiveChatTranscript objlct = [SELECT Id,ChatKey,LiveChatButtonId,Status from liveChatTranscript WHERE Case_Number__c=''
                                             AND LiveChatButton.DeveloperName='How_do_I_Formerly_Operations_Support_Desk_OSD_L1_General_Chat'
                                             LIMIT 1];
                LiveChatTranscript objlct1 = [SELECT Id,ChatKey,LiveChatButtonId,Status from liveChatTranscript WHERE Case_Number__c!='' 
                                             LIMIT 1];
                String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Case_Subject__c=Null LIMIT 1].caseNumber;
                
                Test.startTest();
				pcinput.chatkey=objlct.ChatKey;
                pcinput.validaccount=true;
                pcinput.validcontact=true;
                lctlist.add(objlct);
                keyList.add(pcinput);
                LiveChattranscriptTriggerHelper.getSnapInsPrechatData(keyList);
                LiveChatTranscriptTriggerHelper.createCaseForFAQ(lctList);
                
                pcinput.chatkey=objlct1.ChatKey;
                pcinput.validaccount=true;
                pcinput.validcontact=true;
                lctlist.add(objlct1);
                keyList.add(pcinput);
                LiveChattranscriptTriggerHelper.getSnapInsPrechatData(keyList);
                LiveChatTranscriptTriggerHelper.createCaseForFAQ(lctList);
                
                objlct1.Case_Number__c='';
                Database.update(objlct1);
                pcinput.chatkey=objlct1.ChatKey;
                pcinput.eCaseNumber= caseNumber;
                lctlist.add(objlct1);
                keyList.add(pcinput);
                LiveChattranscriptTriggerHelper.getSnapInsPrechatData(keyList);
                LiveChatTranscriptTriggerHelper.createCaseForFAQ(lctList); 
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHandlerTest','botFunctionalityTest','Bot Functionality'); 
            }
        }
    }
}