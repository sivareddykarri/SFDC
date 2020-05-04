/** 
@Author :     Prathyusha
@Name   :     CaseTriggerHelper
@Created Date: 12/1/2018
@Description: To handle all case operations on Trigger
@Version:0.3
@Reference: 
**/
public without sharing class CaseTriggerHelper {
    /**
    * Description:Displays Error on Parent case when trying to close the case with out the closing the related child case used for request 034
    * @MethodName:displayErrorOnParentCase
    * @Created by:Prathyusha
    * @parameters:List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    public static void displayErrorOnParentCase(List<Case> caseList){
        Set<Id> caseSet = new Set<Id>();
        try{
            for(Case caseObj:[SELECT Id, ParentId,Status,Subject 
                              FROM Case 
                              WHERE ParentId=:caseList                              
                              AND Status!=:ConstantClass.CLOSED
                              AND Status!=:ConstantClass.ABORTED
                              AND Status!=:ConstantClass.CLOSED_ACTION_REQ
                              LIMIT 50000]){
                                  if(caseObj.ParentId!=NULL){
                                      caseSet.add(caseObj.ParentId);
                                  }
                              }
            for(case cObj:caseList){
                if((cObj.Status== ConstantClass.CLOSED ||cObj.Status== ConstantClass.ABORTED ||cObj.Status== ConstantClass.CLOSED_ACTION_REQ) && caseSet.contains(cObj.Id)){
                    cObj.Status.addError(ConstantClass.APEX_CASE_ERRMSG_001);
                }
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.DISPLAYERRORONPARENTCASE,ConstantClass.CASE_MANAGEMENT); 
        }
    }
    
    /**
    * Description:Checks the checkbox RelatedChildcase to true whenever all the cases under the parent are closed, used for request 080.
    * @MethodName:SendPushNotificationtoCaseOwner
    * @Created by:Prathyusha
    * @parameters:List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    public static void sendPushNotificationtoCaseOwnerWhenClosed(List<Case> caseList,Map<Id,Case> casOldMap){
        List<Case> caseListUpdate= new List<Case>();
        Set<Id> caseSet= new Set<Id>();
        boolean check;
        try{
            for(Case objCas : caseList){
                if(objCas.ParentId!=null && objCas.IsClosed && !casOldMap.get(objCas.Id).isClosed){
                    caseSet.add(objCas.ParentId);
                }
            }
            for(Case ObjCase : [SELECT Id,Related_Child_Cases_Closed__c,Status,(SELECT Id,Status,IsClosed FROM Cases)
                                FROM Case
                                WHERE Id=:caseSet 
                                LIMIT 50000]){
                check = true;
                for(Case child: ObjCase.Cases){
                    if(!child.isClosed){
                        check=false;
                        break;
                    }
                }
                if(check){
                    ObjCase.Related_Child_Cases_Closed__c=true;
                    caseListUpdate.add(ObjCase);
                }
            }
            if(!caseListUpdate.isEmpty()){
                Database.SaveResult[] srList= Database.update(caseListUpdate,False);
                ExceptionHandler.logHandledExceptions(srList,ConstantClass.CASEHANDLER,ConstantClass.SENDPUSHNOTIFICATIONTOCASEOWNER,ConstantClass.CASE_MANAGEMENT);
            }
        } 
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.SENDPUSHNOTIFICATIONTOCASEOWNER,ConstantClass.CASE_MANAGEMENT);
        }        
    }
    /**
    * Description: Populates the SLA Value based on Custom Settings
    * @MethodName: updateSLAFieldOnCase
    * @Created by: Vazeer Mohammed
    * @Updated by: Vazeer Mohammed
    * @parameters:List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    Public Static void updateSLAFieldOnCase(List<Case> caseList){
        Map<String,String> mapKeySLA=new Map<String,String>();
        List<Wyndham_SLA_Custom_Settings__c> slaValuesList = Wyndham_SLA_Custom_Settings__c.getAll().Values();
        List<String> requestList = new List<String>();
        String recName='';
        String keyString='';
        String keyStringRequest='';
        Datetime startDate;
        DateTime endDate;
        DateTime completionDate;
        Integer count;
        Integer maxCountIncrement;
        try{
            for(Wyndham_SLA_Custom_Settings__c  objSLA: slaValuesList){
                if(objSLA.MyRequest_Team__c){
                    mapKeySLA.put(objSLA.Case_Record_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Sub_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Subject__c+ConstantClass.UNDERSCORE+objSLA.MyRequest_Team__c,objSLA.Total_SLA__c);
                }else{
                    mapKeySLA.put(objSLA.Case_Record_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Sub_Type__c+ConstantClass.UNDERSCORE+objSLA.Case_Subject__c,objSLA.Total_SLA__c);
                }
            }
            for(Case currentCase: caseList) {
                if(!currentCase.Isclosed && currentCase.RecordTypeId!=null){                
                    recName = Schema.SObjectType.Case.getRecordTypeInfosById().get(currentCase.RecordTypeId).getName();
                    keyString = recName+ConstantClass.UNDERSCORE+currentCase.Case_Type__c+ConstantClass.UNDERSCORE+currentCase.Case_Sub_Type__c+ConstantClass.UNDERSCORE+currentCase.Case_Subject__c;
                    keyStringRequest = recName+ConstantClass.UNDERSCORE+currentCase.Case_Type__c+ConstantClass.UNDERSCORE+currentCase.Case_Sub_Type__c+ConstantClass.UNDERSCORE+currentCase.Case_Subject__c+ConstantClass.UNDERSCORE+'true';
                    if(mapKeySLA.containsKey(keyStringRequest) && mapKeySLA.get(keyStringRequest)!=null){
                        startDate = System.now();
                        endDate = startDate.addHours(Integer.valueOf(mapKeySLA.get(keyStringRequest)));
                        maxCountIncrement = Integer.valueOf(mapKeySLA.get(keyStringRequest))/24;
                        completionDate=null;
                        count=0;
                        for(Datetime d=startDate; d<=EndDate+6; d=d.addDays(1)){
                            Datetime myDateTime = (DateTime) d;
                            String dayOfWeek = myDateTime.format('E');
                            if(count<=maxCountIncrement && dayOfWeek!='Sat' && dayOfWeek!='Sun'){
                                count++;
                                completionDate=myDateTime;
                            }
                        }
                        currentCase.SLA__c = (completionDate.getTime() - startDate.getTime())/3600000;
                    }else if(mapKeySLA.containsKey(keyString)){
                        currentCase.SLA__c = Decimal.valueOf(mapKeySLA.get(keyString));
                    }
                }
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.UPDATESLAFIELDONCASE,ConstantClass.CASE_MANAGEMENT);
        }
    } 
    /*
    * @Description: This method is used to Update PM System field (Had to workaround as Workflows were resulting in Assignment rules to fail, so as a Workaround written this method)
    * @MethodName:updatePMSystemField
    * @Created by:Vazeer
    * @parameters:List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    Public Static void updatePMSystemField(List<Case> caseList){
        List<Case> caseListToUpdate = new List<Case>();
        try{
            for(Case currentCase: [SELECT Id,PM_System__c,AccountId,Account.PM_System__c,Account.Brand__c,Account.Current_Contract__c,IsClosed
                                   FROM Case
                                   WHERE Id =:caseList 
                                   AND IsClosed=False
                                   LIMIT 50000]){
                                       if(currentCase.AccountId!=NULL){
                                           currentCase.PM_System__c=currentCase.Account.PM_System__c;
                                           currentCase.Contract_Number__c=currentCase.Account.Current_Contract__c;
                                           caseListToUpdate.add(currentCase);
                                       }
                                   }
            if(!caseListToUpdate.isEmpty()){
                Database.SaveResult[] srList=Database.update(caseListToUpdate,False);
                ExceptionHandler.logHandledExceptions(srList,ConstantClass.CASEHANDLER,ConstantClass.UPDATEPMSYSTEMFIELD,ConstantClass.CASE_MANAGEMENT);
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.UPDATEPMSYSTEMFIELD,ConstantClass.CASE_MANAGEMENT);
        }
    }
   /**
    * Description:To get the cases related to the account Id
    * @MethodName:getCasesLimit3
    * @Created by:Prathyusha
    * @parameters:Record Id
    * @return:Void
    */
    @AuraEnabled
    public static List<Case> getCasesWithLimit(Id recId,String limitValue){
        String sObjName = recId.getSObjectType().getDescribe().getName();
        String sObjFieldName;
        String genericQuery;
        try{
            if(sObjName==ConstantClass.ACCOUNTOBJECT){
                sObjFieldName='AccountId';
            }else{
                sObjFieldName=sObjName;
            }
            genericQuery='SELECT Id,CaseNumber,AccountId,RecordType.Name,owner.Name,Parent.CaseNumber,CreatedDate,Status,Priority,OwnerId,Case_Type__c,Case_Sub_Type__c,Case_Subject__c,Photo_Shoot__c,Technology__c,Subject FROM Case WHERE '+sObjFieldName+' = \''+recId+'\''+' LIMIT '+limitValue;
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.GETCASESWITHLIMIT, ConstantClass.CASE_MANAGEMENT);
        }
        return Database.query(genericQuery);
    }
    
    /**
    * Description:To get all the Record types of cases available for current user
    * @MethodName:fetchRecordTypeValues
    * @Created by:Prathyusha
    * @parameters:No
    * @return:List<String>
    */
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        try{
            List<Schema.RecordTypeInfo> recordTypeList = Case.SObjectType.getDescribe().getRecordTypeInfos();
            for(RecordTypeInfo recType : recordTypeList){
                if(recType.isAvailable() && recType.getName()!=ConstantClass.MASTER){
                    recordTypeMap.put(recType.getRecordTypeId(), recType.getName());
                }
            }
        }    
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.FETCHRECORDTYPEVALUES,ConstantClass.CASE_MANAGEMENT);
        } 
        return recordTypeMap.values();
    }
    
    /**
    * Description: This method will return the recTypeId based on recordTypeLabel
    * @MethodName:getRecTypeId
    * @Created by:Prathyusha
    * @parameters:string
    * @return:Void
    */
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recTypeId;
        recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        return recTypeId;
    } 
    
    /**
    * Description: Used in the NewCaseQuickActionAccount controller to check whether the current user having access on cases.
    * @MethodName:setFlagTrue
    * @Created by:Prathyusha
    * @parameters:No
    * @return:Void
    */
    @AuraEnabled
    public static boolean setFlagTrue(){
        boolean flag=False;
            if (Schema.sObjectType.Case.fields.Status.isCreateable()) {
                flag=True;
            }
        return flag;
    }
    /**
    * Description: Used in the NewCaseQuickActionAccount to get the sobject Name.
    * @MethodName:setFlagTrue
    * @Created by:Prathyusha
    * @parameters:Id
    * @return:Void
    * @throws exception:throws exception if the AID value null
    */
    @AuraEnabled
    public static string getSobjectName(Id recId){
        String sobjectName;
        sobjectName = recId.getSObjectType().getDescribe().getName();
        return sobjectName;
    }
    
    /**
    * Description: To update Account based on Subject
    * @MethodName:UpdateAccount
    * @Created by:Alekhya
    * @parameters:Id
    * @return:Void
    * @throws exception:throws exception
    **/
    public static void updateAccount(List<Case> updateCaseList){
        Set<String> accIdSet = new Set<String>();
        Map<String,Id> accNameIdMap = new Map<String,Id>();
        list<String> nums = new List<String>();
        String numsplit;
        for(Case objCas: updateCaseList){
            numsplit='';
            if(objCas.Origin == 'Email' && objCas.SuppliedEmail != NULL && objCas.Subject!= NULL ){
                numsplit = objCas.Subject.replaceAll('[^0-9]+', ';');
                nums = numsplit.split(';');
                for(String str: nums){
                    if(str.length()==5){
                        objCas.Account_Name__c=str;
                        break;
                    }
                }
                accIdSet.add(objCas.Account_Name__c);
            }
        }
        for(Account objAcc:[SELECT Id, EXT_Site_Id__c 
                            FROM Account
                            WHERE EXT_Site_Id__c=:accIdSet
                            LIMIT 50000]){
            accNameIdMap.put(objAcc.EXT_Site_Id__c, objAcc.Id);
        }
        for(Case objCase: updateCaseList){
            if(objCase.Origin == 'Email' && objCase.SuppliedEmail != NULL && objCase.Subject!= NULL && objCase.Account_Name__c!=NULL){
                if(accNameIdMap.size()>0 && accNameIdMap.get(objCase.Account_Name__c)!=NULL){
                    objCase.AccountId = accNameIdMap.get(objCase.Account_Name__c);
                }
            }
        }
    }
    
    /**
    * Description: Used to set the picklist list of child cases to aborted when the parent case is aborted
    * @MethodName:updateChildRecordsToAbortedWhenParentAborted
    * @Created by:Prathyusha
    * @parameters:Id
    * @return:Void
    * @throws exception:throws exception
    */
    public static void updateChildRecordsToAbortedWhenParentAborted(List<Case> parentCaseList){
      List<Case> childCaseAbortedList = new List<case>();
      try{       
       for(case objCas:[SELECT Id,CaseNumber,status,ParentId 
                         FROM Case
                         WHERE parentId=:parentCaseList
                         AND parent.Status=:ConstantClass.ABORTED
                         LIMIT 50000]){
           objCas.Status=ConstantClass.ABORTED;
           childCaseAbortedList.add(objCas);
        }
        Database.update(childCaseAbortedList,False);   
    }
    catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.UPDATECHILDRECORDSTOABORTEDWHENPARENTABORTED,ConstantClass.CASE_MANAGEMENT);
        }
    }
    
    /**
    * Description: Populates the Contact for the Restriction and Unrestriction Cases
    * @MethodName: updateContactOnCase
    * @Created by: Vazeer Mohammed
    * @parameters: List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    Public Static void updateContactOnCase(List<Case> caseList){
        List<Contact> conList = new List<Contact>();
        List<Profile> profileNameList = new List<Profile>();
        try{
            conList = [SELECT Id FROM Contact WHERE Name='FIS User' LIMIT 1];
            profileNameList = [Select Id,Name from Profile where Id=: userinfo.getProfileId() LIMIT 1];
            for(Case currentCase: caseList) {
                if(!profileNameList.isEmpty() && !conList.isEmpty() && profileNameList[0].Name == ConstantClass.INTEGRATIONINFORMATICA && currentCase.Case_Type__c == ConstantClass.INTERNALREQUESTS
                   && currentCase.Status!= ConstantClass.CLOSED && (currentCase.Case_Sub_Type__c == ConstantClass.RESCTRICTUNRESCTRICT  || currentCase.Case_Sub_Type__c==ConstantClass.STATUSCHANGE )){
                       currentCase.ContactId=conList[0].Id;
                   }
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.UPDATECONTACTONCASE,ConstantClass.CASE_MANAGEMENT);
        }
    }
    /**
    * Description: This method will update the Request_Id field,Legacy salesforce ID and Legacy Case number null while cloning(D-1164)
    * @MethodName: updateLegacyFieldsNull
    * @Created by: Vazeer Mohammed
    * @parameters: List<case>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    Public Static void updateLegacyFieldsNull(List<Case> caseList){
        List<Profile> profileList = new List<Profile>();
        try{
            profileList = [Select Id,Name from Profile where Id=: userinfo.getProfileId() LIMIT 1];
            for(Case currentCase: caseList) {
                if((currentCase.MyRequest_ID__c!=null ||currentCase.Legacy_Salesforce_Id__c!=null || currentCase.Legacy_Case_Number__c!=null)&&(profileList[0].Name != ConstantClass.INTEGRATIONINFORMATICA)){
                    currentCase.MyRequest_ID__c=null;
                    currentCase.Legacy_Salesforce_Id__c=null;
                    currentCase.Legacy_Case_Number__c=null;
                }
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.CASEHANDLER,ConstantClass.UPDATELEGACYFIELDSNULL,ConstantClass.CASE_MANAGEMENT);
        }
    }
    /**
    * Description: returns the corresponding AccountId for the Given Technology Id
    * @MethodName: getAccountId
    * @Created by: Vazeer Mohammed
    * @parameters: Id
    * @return: Id
    */
    @AuraEnabled
    public static Id getAccountId(Id recId){
        List<Technology__c> techList = new List<Technology__c>([SELECT Account_Name__c FROM Technology__c WHERE Id =:recId LIMIT 1]);
        if(techList.size()>0 && techList[0].Account_Name__c!=null)
        return techList[0].Account_Name__c;
        else
        return null;
    } 
}