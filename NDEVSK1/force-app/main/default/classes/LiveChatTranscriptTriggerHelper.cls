/***
@Author :     Prathyusha
@Name   :     LiveChatTranscriptTriggerHelper
@Created Date: 4/12/2018
@Description: To handle all LiveChatTranscriptHandler operations on Trigger
@Version:0.4
@Reference: 
**/
public without sharing class LiveChatTranscriptTriggerHelper {
    /**
    * Description: to avoid calling all methods in a trigger.
    * @MethodName:liveChatUtilMethod
    * @Created by:prathyusha
    * @parameters:List<LiveChatTranscript> 
    * @return:Void
    * @throws exception:
    */
    public static void liveChatUtilMethod(List<LiveChatTranscript> lvtList){
        List<LiveChatTranscript> liveChatList = new List<LiveChatTranscript>();
        List<LiveChatTranscript> liveChatCaseNumberList = new List<LiveChatTranscript>();
        try{
            for(LiveChatTranscript objLct:lvtList){
                if(objLct.Contact_Email__c!=NULL && objLct.Contact_First_Name__c!=NULL 
                   && objLct.Contact_Last_Name__c!=NULL && objLct.Contact_Phone__c!=NULL 
                   && objLct.Account_Name__c!=NULL && objLct.Case_Description__c!=NULL){
                       if(objLct.Case_Number__c==NULL){
                           liveChatList.add(objLct);
                       }
                       else{
                           liveChatCaseNumberList.add(objLct);  
                       }
                   }   
            }
            if(liveChatList.size()>0 && !liveChatList.isEmpty()){
                LiveChatTranscriptTriggerHelper.createCase(liveChatList); //CaseNumber Null
            }
            if(liveChatCaseNumberList.size()>0 && !liveChatCaseNumberList.isEmpty()){
                LiveChatTranscriptTriggerHelper.fetchCase(liveChatCaseNumberList); //CaseNumber Not Null
            }
        }
        catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.LIVECHATUTILMETHOD,ConstantClass.LIVEAGENTFUNCTIONALITY);
        }
    }
    
    /**
    * Description: fetch Account from the values given in the pre chat form.
    * @MethodName:fetchAccount
    * @Created by:Prathyusha
    * @Updated by:Vazeer
    * @parameters:List<LiveChatTranscript>
    * @return:Map<String,String>
    * @throws exception:
    */
    public static Map<String,String> fetchAccount(List<LiveChatTranscript> lvtList){
        Map<String,String> accNameIdMap = new Map<String,String>();
        List<String> accNameList = new List<String>();
        try{
            for(LiveChatTranscript objLct : lvtList){
                if(objLct.Account_Name__c !=NULL){
                    accNameList.add(objLct.Account_Name__c);
                }
            }
            for(Account objAcc:[SELECT Id,Name,EXT_Site_Id__c  FROM Account
                                WHERE RecordTypeId=:ConstantClass.ACCSITERECTYPEID
                                AND EXT_Site_Id__c =:accNameList
                                LIMIT 50000]){
                                    accNameIdMap.put(objAcc.EXT_Site_Id__c,objAcc.Id);
                                }
        }
        catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.FETCHACCOUNT,ConstantClass.LIVEAGENTFUNCTIONALITY);
        }
        return accNameIdMap;
    }
    /**
    * Description: createCase from the values given in the pre chat form.
    * @MethodName:createCase
    * @Created by:Prathyusha
    * @Updated by:Vazeer
    * @parameters:List<LiveChatTranscript>
    * @return:List<Case>
    * @throws exception:throws exception if LiveChatTranscript list is empty
    */
    public static List<Case> createCase(List<LiveChatTranscript> lvtList){
        List<Case> caseList=new List<Case>();
        List<Contact> conList = ContactManagement.genericMethodToFetchContact(lvtList);
        Map<String,String> accNameAccIdMap = LiveChatTranscriptTriggerHelper.fetchAccount(lvtList);
        Map<String,String> lcbNameIdMap = new Map<String,String>();
        Map<String,String> caseDescIdMap = New Map<String,String>();
        Case casToInsert;
        for(LiveChatButton objLcb:[SELECT Id,DeveloperName 
                                   FROM LiveChatButton LIMIT 20]){
                                       lcbNameIdMap.put(objLcb.DeveloperName,objLcb.Id);
                                   }
        try{
            for(LiveChatTranscript objLct:lvtList){
                casToInsert=new Case();
                casToInsert.Description=objLct.Case_Description__c;
                casToInsert.Origin=ConstantClass.ORIGINCHAT;
                casToInsert.Priority=ConstantClass.MEDIUMPRIORITY;
                casToInsert.MyPortal_Id__c=objLct.MyPortal_Id__c;
                if(conList.size()>0){
                    
                    casToInsert.ContactId=conList[0].Id;
                    objLct.ContactId=conList[0].Id;
                }
                casToInsert.Contact_First_Name__c=objLct.Contact_First_Name__c;
                casToInsert.Contact_Last_Name__c=objLct.Contact_Last_Name__c;
                casToInsert.Contact_Phone__c=objLct.Contact_Phone__c;
                casToInsert.Contact_Email__c=objLct.Contact_Email__c;
                casToInsert.Account_Name__c=objLct.Account_Name__c;
                if(accNameAccIdMap.containsKey(objLct.Account_Name__c)
                   && accNameAccIdMap.get(objLct.Account_Name__c)!=NULL){
                       casToInsert.AccountId=accNameAccIdMap.get(objLct.Account_Name__c);
                       objLct.AccountId=accNameAccIdMap.get(objLct.Account_Name__c);
                   }
                if(objLct.LiveChatButtonId==(lcbNameIdMap.get(ConstantClass.CHATBUTTON1)) || objLct.LiveChatButtonId==(lcbNameIdMap.get(ConstantClass.CHATBUTTON12))  ){
                    casToInsert.RecordTypeId=ConstantClass.CASESYSREQRECTYPEID;
                    casToInsert.Case_Type__c=constantClass.SYSTEMINSTALLUPGRADETYPE;
                }else if(objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON2) || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON13)){
                    casToInsert.RecordTypeId=ConstantClass.CASEGENREQRECTYPEID;
                    casToInsert.Case_Type__c=constantClass.CHECKSERVICETYPE;
                }else if(objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON7 ) 
                         || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON11)|| objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON18) || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON22)){
                             casToInsert.RecordTypeId=ConstantClass.CASEGENREQRECTYPEID;
                             casToInsert.Case_Type__c=constantClass.HOWTOSTYPE;
                         }else if(objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON8) || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON19)){
                             casToInsert.RecordTypeId=ConstantClass.CASEGENREQRECTYPEID;
                             casToInsert.Case_Type__c=constantClass.FINANCE;
                         }else if(objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON9) || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON20)){
                             casToInsert.RecordTypeId=ConstantClass.CASEDISTRECTYPEID;
                             casToInsert.Case_Type__c=constantClass.RATESOTAINVENTORYTYPE;
                         }else if(objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON3)
                                  ||objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON6)
                                  ||objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON4)
                                  ||objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON10) 
                                 || objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON14)
                                 ||objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON17)
                                 ||objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON15)
                                 ||objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON21)){
                                      casToInsert.RecordTypeId=ConstantClass.CASESYSREQRECTYPEID;
                                      casToInsert.Case_Type__c=constantClass.SYSTEMINQUIRESSUPPORT;
                                  }else if(objLct.LiveChatButtonId==lcbNameIdMap.get(ConstantClass.CHATBUTTON5)||objLct.LiveChatButtonId == lcbNameIdMap.get(ConstantClass.CHATBUTTON16)){
                                      casToInsert.RecordTypeId=ConstantClass.CASESYSREQRECTYPEID;
                                      casToInsert.Case_Type__c=constantClass.SYSTEMINQUIRESSUPPORT;
                                  }
                else{
                    casToInsert.RecordTypeId=ConstantClass.CASESYSREQRECTYPEID;
                    casToInsert.Case_Type__c=constantClass.SYSTEMINQUIRESSUPPORT;
                }
                caseList.add(casToInsert);
            }
            if(!caseList.isEmpty()){
                Database.insert(caseList);
            }
            for(Case objCas:caseList){
                if(objCas.Description!=NULL){
                    caseDescIdMap.put(objCas.Description,objCas.Id);
                }
            }
            for(LiveChatTranscript objLct:lvtList){
                if(caseDescIdMap.containsKey(objLct.Case_Description__c)
                   && caseDescIdMap.get(objLct.Case_Description__c)!=NULL){
                       objLct.CaseId=caseDescIdMap.get(objLct.Case_Description__c);
                   }
            }
        }
        catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.CREATECASE,ConstantClass.LIVEAGENTFUNCTIONALITY);
        }
        return caseList;
    }
    /**
    * Description: fetchCase from the values given in the pre chat form on the field case number.
    * @MethodName:fetchCase
    * @Created by:Prathyusha
    * @Updated by:Vazeer
    * @parameters:List<LiveChatTranscript>
    * @return:Void
    * @throws exception:
    */
    public static void fetchCase(List<LiveChatTranscript> lvtList){
        Map<String,String> caseCloseMap = new Map<String,String>();
        Map<String,String> invalidCaseMap = new Map<String,String>();
        Map<String,String> caseNewMap = new Map<String,String>();
        Map<String,String> caseNumIdMap = new Map<String,String>();
        Map<String,String> caseDesIdMap=new Map<String,String>();        
        Map<String,String> accNameAccIdMap = LiveChatTranscriptTriggerHelper.fetchAccount(lvtList);
        List<Case> casList=new List<Case>();
        List<Case> casNewList=new List<Case>();
        case caseToInsert;
        Boolean Check = False;
        Set<String> casNumSet =new Set<String>();
        List<Contact> conList = ContactManagement.genericMethodToFetchContact(lvtList);
        try{
            for(LiveChatTranscript objLct:lvtList){
                casNumSet.add(objLct.Case_Number__c);
                if(conList.size()>0){
                    objLct.ContactId=conList[0].Id;
                }
                if(accNameAccIdMap.containsKey(objLct.Account_Name__c) 
                   && accNameAccIdMap.get(objLct.Account_Name__c)!=NULL){
                       objLct.AccountId=accNameAccIdMap.get(objLct.Account_Name__c);
                   }
            }
            List<Case> caseList=new List<Case>([SELECT Id,Status,caseNumber,Description,AccountId 
                                                FROM Case
                                                WHERE CaseNumber=:casNumSet 
                                                LIMIT 50000]);
            for(Case objCas:caseList){
                if(objCas.CaseNumber!=NULL && (objcas.Status!=ConstantClass.CLOSED && objcas.Status!=ConstantClass.ABORTED && objcas.Status!=ConstantClass.CLOSED_ACTION_REQ)){
                    caseNumIdMap.put(objCas.CaseNumber,objCas.Id);
                }
                else if(objCas.CaseNumber!=NULL && (objcas.Status==ConstantClass.CLOSED||objcas.Status==ConstantClass.ABORTED||objcas.Status==ConstantClass.CLOSED_ACTION_REQ)){
                    caseCloseMap.put(objcas.CaseNumber,objcas.Id );
                }
                else if(objCas == Null){
                    Check = True;
                }
            }
            for(LiveChatTranscript objLct:lvtList){
                if(caseNumIdMap.containsKey(objLct.Case_Number__c)
                   && caseNumIdMap.get(objLct.Case_Number__c) !=NULL){
                       objLct.CaseId=caseNumIdMap.get(objLct.Case_Number__c);
                       caseDesIdMap.put(objLct.CaseId,objLct.Case_Description__c);
                   }
                else if(Check == TRUE || caseCloseMap.containsKey(objLct.Case_Number__c)){
                    caseToInsert = new Case();
                    caseToInsert.Status='New';
                    caseToInsert.Origin='Chat';
                    caseToInsert.Priority='Medium';
                    caseToInsert.Description=objLct.Case_Number__c;
                    caseToInsert.AccountId=objLct.AccountId;
                    caseToInsert.ContactId=objLct.ContactId;
                    caseToInsert.Contact_First_Name__c=objLct.Contact_First_Name__c;
                    caseToInsert.Contact_Last_Name__c=objLct.Contact_Last_Name__c;
                    caseToInsert.Contact_Email__c=objLct.Contact_Email__c;
                    caseToInsert.Contact_Phone__c=objLct.Contact_Phone__c;
                    caseToInsert.Account_Name__c=objLct.Account_Name__c;
                    caseToInsert.RecordTypeId=ConstantClass.CASESYSREQRECTYPEID;
                    casNewList.add(caseToInsert);
                }
            }
            Database.insert(casNewList);
            for(LiveChatTranscript objLct:lvtList){
                for(case obcas: [select Id, CaseNumber,Description,status from Case where Id=:casNewList]){
                    if(objLct.Case_Number__c==obcas.Description){
                        objLct.CaseId=obcas.Id;
                    }
                }
            }
            for(Case objcas:caseList){
                if(caseDesIdMap.containsKey(objcas.Id)){
                    objcas.Description=objcas.Description+constantClass.COMMA+constantClass.NEWLINE+ caseDesIdMap.get(objcas.Id);
                    objcas.Contact_First_Name__c=lvtList[0].Contact_First_Name__c ;
                    objcas.Contact_Last_Name__c=lvtList[0].Contact_Last_Name__c;
                    objcas.Contact_Email__c=lvtList[0].Contact_Email__c;
                    objcas.Contact_Phone__c=lvtList[0].Contact_Phone__c;
                    objcas.Account_Name__c=lvtList[0].Account_Name__c;
                    casList.add(objcas);
                }
            }
            if(!casList.isEmpty()){
                Database.update(casList);
            }
        }
        catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.FETCHCASE,ConstantClass.LIVEAGENTFUNCTIONALITY);
        }
    }
    /***
    @Author : Vazeer
    @Name   : PrechatOutput
    @Created Date: 8/19/2019
    @Description: Wrapper Class that Stores all the Output Parameters
    @Version:0.1
    @Reference: @InvocableVariable
    **/     
    public without sharing class PrechatOutput{      
        @InvocableVariable
        public String sCaseNumber;
        @InvocableVariable
        public String chatButtonName;        
        @InvocableVariable
        public String caseResolution;
        @InvocableVariable
        public String caseType;
        @InvocableVariable
        public String requestType;
        @InvocableVariable
        public String requestTypeDetail;
    }
    /***
    @Author : Vazeer
    @Name   : PrechatInput
    @Created Date: 8/19/2019
    @Description: Wrapper Class that Stores all the Input Parameters
    @Version:0.1
    @Reference: @InvocableVariable
    **/     
    public without sharing class PrechatInput{
        @InvocableVariable
        public String chatkey;
        @InvocableVariable
        public String eCaseNumber;
        @InvocableVariable
        public boolean validAccount;
        @InvocableVariable
        public boolean validContact;
    }
    /**
    * Description: gets input param from bot and fetches and assigns case and chatbuton details as output param
    * @MethodName:Get custom Prechat Data(InvocableMethod)
    * @Created by:Vazeer
    * @parameters:List<PrechatOutput>, List<PrechatInput>
    * @return:outputParameters
    * @throws exception:
    */
    @InvocableMethod(label='Get custom Prechat Data')
    public static List<PrechatOutput> getSnapInsPrechatData(List<PrechatInput> key){
        try{            
            List<PrechatOutput> outputParameters = new List<PrechatOutput>();
            PrechatOutput outputParameter = new PrechatOutput();
            LiveChatTranscript objChat;
            List<Case> caseList = new List<Case>();
            List<Contact> conList = new List<Contact>();
            List<LiveChatTranscript> transcripts = new List<LiveChatTranscript>();
            
            transcripts = [SELECT Id,Contact_First_Name__c,Contact_Last_Name__c,LiveChatButtonId, LiveChatDeploymentId,Contact_Email__c,Contact_Phone__c,Case_Number__c,Account_Name__c,LiveChatButton.MasterLabel
                           FROM LiveChatTranscript 
                           WHERE chatKey =: key[0].chatkey
                           LIMIT 1];
            objChat = new LiveChatTranscript(Id=transcripts[0].Id);
            if (transcripts.size() > 0 && key[0].eCaseNumber==null){
                conList = [SELECT Id FROM Contact WHERE FirstName=:transcripts[0].Contact_First_Name__c AND LastName=:transcripts[0].Contact_Last_Name__c AND (Email=:transcripts[0].Contact_Email__c OR MobilePhone=:transcripts[0].Contact_Phone__c OR OtherPhone=:transcripts[0].Contact_Phone__c OR Phone=:transcripts[0].Contact_Phone__c) LIMIT 1];
                if(!conList.isEmpty() && key[0].validAccount && key[0].validContact){
                    objChat.ContactId = conList[0].Id;
                }
                outputParameter.sCaseNumber = (transcripts[0].Case_Number__c == null) ? '' : transcripts[0].Case_Number__c;
                if(transcripts[0].LiveChatButton.MasterLabel.contains(ConstantClass.GETSTATUS)){
                    outputParameter.chatButtonName =ConstantClass.GETS;
                }else if(transcripts[0].LiveChatButton.MasterLabel.contains(ConstantClass.HOW)){
                    outputParameter.chatButtonName =ConstantClass.HOW;
                }
                if(transcripts[0].Case_Number__c!=null){
                    caseList = [SELECT Id,status,Account.Ext_Site_Id__c,Case_Type__c, Case_Sub_Type__c, Case_Subject__c, Subject, Resolution__c
                                FROM Case 
                                WHERE caseNumber = : transcripts[0].Case_Number__c
                                LIMIT 1];
                }
            }
            if(key[0].eCaseNumber!=null){
                objChat.Case_Number__c = key[0].eCaseNumber;
                caseList = [SELECT Id,Case_Type__c, Case_Sub_Type__c, Case_Subject__c, Subject, Resolution__c
                            FROM Case 
                            WHERE caseNumber =: key[0].eCaseNumber
                            LIMIT 1];
            }
            if(!caseList.isEmpty() && caseList.size()>0){
                objChat.caseId = caseList[0].Id;
                outputParameter.caseType = (caseList[0].Case_Type__c == null) ? ' ' : caseList[0].Case_Type__c;
                outputParameter.requestType = (caseList[0].Case_Sub_Type__c == null) ? ' ' : caseList[0].Case_Sub_Type__c;
                outputParameter.caseResolution = (caseList[0].Resolution__c == null) ? ' ' : caseList[0].Resolution__c;
                if(caseList[0].Case_Subject__c == ConstantClass.OTHER){
                    outputParameter.requestTypeDetail = (caseList[0].Subject == null) ? ConstantClass.OTHER : caseList[0].Subject;
                }else if(caseList[0].Case_Subject__c == null){
                    outputParameter.requestTypeDetail = ' ';
                }else{
                    outputParameter.requestTypeDetail = caseList[0].Case_Subject__c;
                }
            }
            if(objChat!=null){
                Database.update(objChat);
            }
            outputParameters.add(outputParameter);
            return outputParameters;
        }catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.GETCUSTOMPRECHATDATA,ConstantClass.CHATBOTFUNCTION);
            return null;
        }
    }
    /**
    * Description: Creates Case for FAQ Scenarios when chat transferred to agent, Links accounts to chat, updates agent accepted.
    * @MethodName:createCaseForFAQ
    * @Created by:Vazeer
    * @parameters:List<LiveChatTranscript> 
    * @return:void
    * @throws exception:
    */    
    public static void createCaseForFAQ(List<LiveChatTranscript> lvtList){
        Map<Id,String> chatButIdNameMap = new Map<Id,String>();
        List<Case> caseList = new List<Case>();
        List<LiveChatTranscript> updateLctList = new List<LiveChatTranscript>();
        Map<String,String> accNameIdMap = new Map<String,String>();
        List<Account> accList = new List<Account>();
        LiveChatTranscript aux;
        Set<String> siteStringSet = new Set<String>();
        try{
            for(LiveChatButton objChat : [SELECT Id, MasterLabel FROM LiveChatButton LIMIT 50]){
                chatButIdNameMap.put(objChat.Id,objChat.MasterLabel);
            }
            for(LiveChatTranscript objChat: lvtList){
                if(objChat.Updated_Account_Site_Number__c!=null){
                    siteStringSet.add(objChat.Updated_Account_Site_Number__c);
                }
            }
            for(Account objAcc:[SELECT Id,Name,EXT_Site_Id__c  FROM Account
                                WHERE EXT_Site_Id__c =:siteStringSet
                                LIMIT 50000]){
                                    accNameIdMap.put(objAcc.EXT_Site_Id__c,objAcc.Id);
                                }
            for(LiveChatTranscript objChat: lvtList){
                if(objChat.Status==ConstantClass.INPROGRESS && chatButIdNameMap.get(objChat.LiveChatButtonId).contains(ConstantClass.HOW) && objChat.CaseId==null){
                    Case objCase = new Case();
                    objCase.Description = objChat.Case_Description__c;
                    objCase.RecordTypeId= ConstantClass.CASEGENREQRECTYPEID;
                    objCase.Origin=ConstantClass.ORIGINCHAT;
                    objCase.Case_Type__c = ConstantClass.HOWTOSTYPE;
                    if(accNameIdMap.containsKey(objChat.Updated_Account_Site_Number__c)){
                        objCase.AccountId= accNameIdMap.get(objChat.Updated_Account_Site_Number__c);
                    }
                    if(objChat.ContactId!=null){
                        objCase.ContactId= objChat.ContactId;
                    }
                    caseList.add(objCase);
                }
            }
            if(!caseList.isEmpty()){
                Database.insert(caseList);
            }
            for(LiveChatTranscript objChat: lvtList){
                if(objChat.Status!=ConstantClass.WAIT && chatButIdNameMap.containsKey(objChat.LiveChatButtonId) && (chatButIdNameMap.get(objChat.LiveChatButtonId).contains(ConstantClass.HOW) || chatButIdNameMap.get(objChat.LiveChatButtonId).contains(ConstantClass.GETSTATUS))){
                    aux  = new LiveChatTranscript(Id = objChat.Id);
                    if(objChat.Status==ConstantClass.INPROGRESS){
                        aux.Agent_Accepted__c=true;
                        aux.Bot_Unable_to_Contact_Agent__c = false;
                    }
                    if(chatButIdNameMap.containsKey(objChat.LiveChatButtonId) && chatButIdNameMap.get(objChat.LiveChatButtonId).contains(ConstantClass.HOW)){
                        if(!caseList.isEmpty() && objChat.Status==ConstantClass.INPROGRESS){
                            aux.CaseId=caseList[0].Id;
                        }
                    }
                    if(accNameIdMap.containsKey(objChat.Updated_Account_Site_Number__c)){
                        aux.AccountId= accNameIdMap.get(objChat.Updated_Account_Site_Number__c);
                    }
                    updateLctList.add(aux);
                }
            }
            if(!updateLctList.isEmpty()){
                Database.update(updateLctList);
            }
        }   catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.LIVECHATTRANSCRIPTHELPER,ConstantClass.CREATECASEFORFAQ,ConstantClass.CHATBOTFUNCTION);
        }
    }
}