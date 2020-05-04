/**
@Author :  Prathyusha
@Name   :  LiveChatTranscriptTriggerHelperTest
@Created Date: 4/12/2018
@Description: To handle all LiveChatTranscriptTriggerHandler operations on Trigger
@Version:0.2
@Reference: 
**/
@isTest 
public class LiveChatTranscriptTriggerHelperTest {
    /**
    * Description:Covers the coverage for LiveChatTranscriptHandler class and for all the methods like fetchExistingContact,fetchExistingConOrCreateAccCon,contactManagement,fetchAccount,createCase,fetchCase
    * @MethodName:CreateLiveChatTranscript
    * @Created by:prathyusha
    * @parameters:Null 
    * @return:Void
    */
     public static LiveChatTranscript createLiveChatTranscriptRecord(Id liveChatVisitorId,String chatButton,String caseNum){
        LiveChatTranscript objLct=new LiveChatTranscript();
        LiveChatTranscript objLct1=new LiveChatTranscript();
        try{
            objLct.LiveChatVisitorid = liveChatVisitorId;
            if(chatButton==''){
                objLct.LiveChatButtonId = null;
            }else{
                objLct.LiveChatButtonId = chatButton;  
            }
            objLct.Account_Name__c='00015';
            objLct.Contact_Email__c='ab@gmail.com';
            objLct.Contact_First_Name__c='Test';
            objLct.Contact_Last_Name__c='Contact';
            objLct.Case_Number__c= caseNum;
            objLct.Contact_Phone__c='9989456002';
            objLct.Case_Description__c='Test data to create case';
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHelperTest','createLiveChatTranscriptRecord','LiveChat Management');
        }
        return objLct;
    }
    /** 
    * Description:This method is used to Create Live Chat Visitor Id
    * @MethodName:createLiveChatVisitorId
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Id
    */
    public static Id createLiveChatVisitorId(){
        LiveChatVisitor lcv = new LiveChatVisitor();
        try{
            Database.insert(lcv);
            system.assert(lcv.id!=Null);
        }
        catch(exception ex){
             ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHelperTest','createLiveChatVisitorId','LiveChat Management');
        }
        return lcv.id;
    }
    /** 
    * Description:This method is used to Create Live Chat Transcript
    * @MethodName:createLiveChatTranscriptTest
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Id
    */
    private static testMethod void createLiveChatTranscriptTest(){
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                List<LiveChatTranscript> lctList=new List<LiveChatTranscript>();
                Map<String, Id> lcbMap = new Map<String, Id>();
                for(LiveChatButton objLcb:[SELECT Id,DeveloperName FROM LiveChatButton LIMIT 11]){
                    lcbMap.put(objLcb.DeveloperName,objLcb.Id);
                }
                String chatbutton1=lcbMap.get('Installation_or_upgrade_of_my_property_technology_HTCS_L1_No_Sys_Chat');
                String chatbutton2=lcbMap.get('Get_status_of_an_existing_request_ticket_OSD_L1_General_Chat');
                String chatbutton3=lcbMap.get('Technology_issue_question_about_my_Opera_PM_System_HTCS_L1_Opera_Chat');
                String chatbutton4=lcbMap.get('Tech_issue_question_about_a_WHG_Managed_Property_HTCS_L1_Managed_Chat');
                String chatbutton5=lcbMap.get('Technology_issue_question_about_my_SynXis_PM_System_HTCS_L1_Synxis_Chat');
                String chatbutton6=lcbMap.get('Technology_issue_question_about_MyPortal_HTCS_OSD_L1_MyPortal_Chat');
                String chatbutton7=lcbMap.get('How_do_I_Formerly_Operations_Support_Desk_OSD_L1_General_Chat');
                String chatbutton8=lcbMap.get('Financial_billing_or_performance_OSD_L1_General_Chat');
                String chatbutton9=lcbMap.get('Rates_inventory_online_travel_agencies_OTAs_or_GDS_OSD_L1_General_Chat');
                String chatbutton10=lcbMap.get('Technology_issue_question_about_my_SynXis_CR_System_HTCS_L1_No_Sys_Chat');
                String chatbutton11=lcbMap.get('I_don_t_see_my_inquiry_listed_here_HTCS_L1_No_Sys_Chat');
                
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord2();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Contact objCon1 = ApexDataUtil.createContactRecord1();
                String csRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Request').getRecordTypeId() ;
                
                Id liveChatVisitorId = LiveChatTranscriptTriggerHelperTest.createLiveChatVisitorId();
                Case objCas=ApexDataUtil.createCaseRecord(objAcc,objCon1);
                Case objCas1=[SELECT Id,caseNumber FROM Case WHERE Id=:objCas.Id LIMIT 1];
                Case objClosedCas = ApexDataUtil.ClosedCaseInstance(objAcc,objCon1,csRecordTypeID);
                Case objClosedCas1 = [SELECT Id,caseNumber FROM Case WHERE Id=:objClosedCas.Id LIMIT 1];
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton2,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton7,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton9,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton8,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton1,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton3,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,chatbutton5,''));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,'',objCas1.CaseNumber));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,'',objClosedCas1.CaseNumber));
                lctList.add(LiveChatTranscriptTriggerHelperTest.createLiveChatTranscriptRecord(liveChatVisitorId,'',''));
                
                Test.startTest();
                Database.insert(lctList);
                Test.stopTest();
                system.assert(lctList!=NULL);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHandlerTest','CreateLiveChatTranscript','Live Chat Functionality'); 
            }
        }
    }
    /** 
    * Description:This method is used for fecthing exsiting case scenario.
    * @MethodName:liveAgentExistingCaseTest
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Id
    */
    private static testmethod void liveAgentExistingCaseTest(){
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                String RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
                Account acc=new Account(Name='Test', ext_site_id__C='45678', recordTypeId=RecordTypeID);
                Database.insert(acc);
                Contact objCon = New Contact(FirstName='test',LastName='hello',Phone='7878787878',Email='con@gmail.com');
                database.insert(objCon);
                case cs=new Case(status='New',Priority='Medium',Origin='Chat',AccountId=acc.Id,ContactId=objCon.Id);
                Database.insert(cs);
                Livechattranscript lct=new Livechattranscript();
                Id liveChatVisitorId = LiveChatTranscriptTriggerHelperTest.createLiveChatVisitorId();
                lct.LiveChatVisitorId=liveChatVisitorId;
                lct.Account_Name__c='45678';
                lct.Case_Number__c=cs.CaseNumber;
                lct.Case_Description__c='test issue';
                lct.Contact_First_Name__c='test';
                lct.Contact_Last_Name__c='hello';
                lct.Contact_Email__c='con@gmail.com';
                lct.Contact_Phone__c='7878787878';
                
                Database.insert(lct);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHandlerTest','CreateLiveChatTranscript','Live Chat Functionality'); 
            }
        }
    }
    /** 
    * Description:This method is used to update accounts based on direct and indirect accounts
    * @MethodName:liveAgentExistingCaseIndiretACRTest
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Id
    */  
    private static testmethod void liveAgentExistingCaseIndiretACRTest(){
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                String RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
                Account acc=new Account(Name='Test', ext_site_id__C='45678', recordTypeId=RecordTypeID);
                Database.insert(acc);
                Account acc2=new Account(Name='Test', ext_site_id__C='78965', recordTypeId=RecordTypeID);
                Database.insert(acc2);
                Contact objCon = New Contact(FirstName='test',LastName='hello',Phone='7878787878',Email='con@gmail.com',AccountId=acc2.Id);
                Database.insert(objCon);
                case cs=new Case(status='New',Priority='Medium',Origin='Chat',AccountId=acc.Id,ContactId=objCon.Id);
                Database.insert(cs);
                Livechattranscript lct=new Livechattranscript();
                Id liveChatVisitorId = LiveChatTranscriptTriggerHelperTest.createLiveChatVisitorId();
                lct.LiveChatVisitorId=liveChatVisitorId;
                lct.Account_Name__c='45678';
                lct.Case_Number__c=cs.CaseNumber;
                lct.Case_Description__c='test issue';
                lct.Contact_First_Name__c='test';
                lct.Contact_Last_Name__c='hello';
                lct.Contact_Email__c='con@gmail.com';
                lct.Contact_Phone__c='7878787878';
                
                Database.insert(lct);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LiveChatTranscriptTriggerHandlerTest','CreateLiveChatTranscript','Live Chat Functionality'); 
            }
        }
    }
}