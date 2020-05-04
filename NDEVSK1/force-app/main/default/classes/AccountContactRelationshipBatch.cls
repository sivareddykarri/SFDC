/**
 @Author :  Alekhya/Vazeer
 @Name   :  AccountContactRelationship
 @Created Date: 09-Apr-2018
 @Description: Using this batch process we are creating direct and indirect Account-Contact Relationships 
 @Version:0.1
 @Reference: 
**/
global class AccountContactRelationshipBatch implements Database.Batchable<sObject>{
    private static final Integer batchSize = Integer.valueOf(Batch_Class_Execution_Control__c.getInstance('AccountContactRelationBatch').Batch_Size__c);
    Set<Integer> allSequencesSet=new Set<Integer>();
    private Integer sequence;
    String query;
    
    /*Constructor Name: AccountContactRelationshipBatch
     Description : Constructor( Used for Constructor Overrloading below)
    */
    global AccountContactRelationshipBatch(){
        for(Contract objCon: [SELECT Id,Sequence__c FROM Contract
                              WHERE ID IN (SELECT Contract__c FROM Contract_Contact_Relationship__c
                                           WHERE Processing_Status__c='New')
                              ORDER BY Sequence__c ASC]){
                                  if(objCon.Sequence__c!=null && !allSequencesSet.contains(Integer.valueOf(objCon.Sequence__c))){
                                      allSequencesSet.add(Integer.valueOf(objCon.Sequence__c));
                                  }
                              }
        if(!allSequencesSet.isEmpty()){
            for (Integer minSeq : allSequencesSet){
                sequence = minSeq;
                break;
            }
        }else{
            sequence = 1;
        }
        allSequencesSet.remove(sequence);
    }
    global AccountContactRelationshipBatch(Integer chain,Set<Integer> chainSequenceSet){
        sequence = chain;
        allSequencesSet = chainSequenceSet;
    }
    /** 
    *Description: This Start Method will queries all the Contract records where atleast one of related CCR should be New
    *@MethodName: start
    *@Created by: Vazeer Mohammed
    *@parameters: database.BatchableContext bc
    *@return: Database.QueryLocator
    */
    global Database.QueryLocator start(database.BatchableContext bc){
        query = 'SELECT Id,AccountId,Entity__c,Current_Site_Indicator__c,Status__c,Sequence__c '+
                'FROM Contract '+
                'WHERE Id IN(SELECT Contract__c from Contract_Contact_Relationship__c WHERE Processing_Status__c=\'New\') '+
                'AND Sequence__c = :sequence';
        return Database.getQueryLocator(query);
    }
     /** 
    *Description: This method will create the direct relationship, Indirect relationship, Status, Roles on Account Contact Relationship object from the related Contract Contact Relationships
    *@MethodName: execute
    *@Created by: Vazeer Mohammed
    *@parameters: database.BatchableContext bc, List<Contract_Contact_Relationship__c> scope
    *@return: void
    */
    global void execute(Database.BatchableContext BC, List<Contract> scope){
        //Variable Declaration
        Map<String,AccountContactRelation> accContUniqueKeyMap = new Map<String,AccountContactRelation>();
        Map<String,AccountContactRelation> accContDirectUniqueKeyMap = new Map<String,AccountContactRelation>();
        Map<String,Set<String>> activeRolesWithCCRMap = new Map<String,Set<String>>();
        Map<String,Set<String>> allRolesWithCCRMap = new Map<String,Set<String>>();
        Map<String,String> ccrSiteStatusMap = new Map<String,String>();
        Map<String,String> ccrEntityStatusMap = new Map<String,String>();
        Map<String,Decimal> entityOwnerPercentageMap = new Map<String,Decimal>();
        Map<Id,Contract_Contact_Relationship__c> errorCCRMap;
        List<AccountContactRelation> insertAccConRelList = new List<AccountContactRelation>();
        List<AccountContactRelation> updateAccConRelList = new List<AccountContactRelation>();
        List<Contract_Contact_Relationship__c> updateConContractRelList = new List<Contract_Contact_Relationship__c>();
        List<Contact> conList=new List<Contact>();
        Set<String> dupCheckAccConRelSet = new Set<String>();
        Set<String> dupDirectAccConRelSet = new Set<String>();
        Set<Id> failedContractRecSet = new Set<Id>();
        Set<Id> ccrConIdSet=new Set<Id>();
        AccountContactRelation newAccConRel;
        String conContractKey;
        String uniquecontractContact;
        String accSiteContUniqueKey;
        String accEntityContUniqueKey;
        
        //Query to fetch all the CCR's related to Contracts
        List<Contract_Contact_Relationship__c> ccrList = [SELECT Id,Contract__c,Contact__c,Roles__c,Status__c,Processing_Status__c,Contract__r.Status__c,Contract__r.Sequence__c,
                                                          Contract__r.Current_Site_Indicator__c,Owner_Percentage__c,Error_Message__c,Contract__r.Entity__c,Contract__r.Name,Contract__r.ContractNumber,
                                                          Contract__r.AccountId,Contact__r.RecordTypeId,Contact__r.RecordType.DeveloperName,Contact__r.AccountId 
                                                          FROM Contract_Contact_Relationship__c 
                                                          WHERE Contract__c IN: scope
                                                          LIMIT 50000];
        
        //Data Creation for insertion and updation of ACR field Values
        for(Contract_Contact_Relationship__c ccrObj:ccrList){
            ccrConIdSet.add(ccrObj.Contact__c);
            uniquecontractContact=ccrObj.Contract__c+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            if(ccrObj.Status__c==ConstantClass.ACTIVE){
                if(ccrObj.Roles__c!=null){
                    if(activeRolesWithCCRMap.containsKey(uniquecontractContact)){
                        activeRolesWithCCRMap.get(uniquecontractContact).add(ccrObj.Roles__c);
                    }else{
                        activeRolesWithCCRMap.put(uniquecontractContact, new Set<String>{ccrObj.Roles__c});
                    }
                    if(!ccrEntityStatusMap.containsKey(uniquecontractContact) && ccrObj.Roles__c.contains(ConstantClass.ENTITY)){
                        ccrEntityStatusMap.put(uniquecontractContact,ccrObj.Status__c);
                    }
                }
                if(!ccrSiteStatusMap.containsKey(uniquecontractContact)){
                    ccrSiteStatusMap.put(uniquecontractContact,ccrObj.Status__c);
                }
            }
            if(ccrObj.Roles__c!=null){
                if(allRolesWithCCRMap.containsKey(uniquecontractContact)){
                    allRolesWithCCRMap.get(uniquecontractContact).add(ccrObj.Roles__c);
                }else{
                    allRolesWithCCRMap.put(uniquecontractContact, new Set<String>{ccrObj.Roles__c});
                }
            }
            if(!entityOwnerPercentageMap.containsKey(uniquecontractContact) && ccrObj.Roles__c!=null 
               && ccrObj.Roles__c.contains(ConstantClass.ENTITYOWNER) && ccrObj.Owner_Percentage__c!=null){
                   entityOwnerPercentageMap.put(uniquecontractContact,ccrObj.Owner_Percentage__c);
               }
        }
        
        //Query to fetch all the ACR which are in salesforce database
        for(AccountContactRelation acrsObj:[SELECT Id,AccountId,ContactId,IsActive,Roles
                                            FROM AccountContactRelation
                                            WHERE ContactId IN: ccrConIdSet
                                            LIMIT 50000]){
                                                accContUniqueKeyMap.put(acrsObj.AccountId+ConstantClass.UNDERSCORE+acrsObj.ContactId,acrsObj);
                                            }
        
        //Creation of Direct and indirect ACR values
        for(Contract_Contact_Relationship__c ccrObj:ccrList){
            accSiteContUniqueKey='';
            accEntityContUniqueKey='';
            conContractKey='';
            conContractKey = ccrObj.Contract__c+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            if(ccrObj.Contact__r.RecordType.DeveloperName!=ConstantClass.ORGANIZATION){    
                accSiteContUniqueKey = ccrObj.Contract__r.AccountId+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            }
            if(ccrObj.Contract__r.Entity__c!=null && ccrObj.Roles__c!=null && ccrObj.Roles__c.contains(ConstantClass.ENTITY)){
                accEntityContUniqueKey = ccrObj.Contract__r.Entity__c+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            }
            if((!dupCheckAccConRelSet.contains(accSiteContUniqueKey) && accSiteContUniqueKey!='') || (!dupCheckAccConRelSet.contains(accEntityContUniqueKey) && accEntityContUniqueKey!='')){
                if((!accContUniqueKeyMap.containsKey(accSiteContUniqueKey) && accSiteContUniqueKey!='') || (!accContUniqueKeyMap.containsKey(accEntityContUniqueKey) && accEntityContUniqueKey!='')){
                    if(!accContUniqueKeyMap.containsKey(accSiteContUniqueKey) && accSiteContUniqueKey!='' && !dupCheckAccConRelSet.contains(accSiteContUniqueKey)){
                        if(ccrObj.Contact__r.AccountId!=NULL){
                            //Creation of Indirect ACR for Account of record Type Site
                            newAccConRel = new AccountContactRelation();
                            newAccConRel.AccountId = ccrObj.Contract__r.AccountId;
                            newAccConRel.ContactId=ccrObj.Contact__c;
                            newAccConRel = AccountContactRelationshipBatchHelper.siteACRValuesCalculation(ccrObj, activeRolesWithCCRMap, allRolesWithCCRMap, newAccConRel, ccrSiteStatusMap, conContractKey);
                            dupDirectAccConRelSet.add(accSiteContUniqueKey);
                            insertAccConRelList.add(newAccConRel);
                        }
                        else{
                            //Creation of Direct ACR by updating AccountId field in Contact record
                            conList.add(AccountContactRelationshipBatchHelper.insertDirectAccountContactRel(ccrObj, ConstantClass.SITE));
                        }
                        dupCheckAccConRelSet.add(accSiteContUniqueKey);
                    }
                    if(!accContUniqueKeyMap.containsKey(accEntityContUniqueKey) && ccrObj.Roles__c!=null && ccrObj.Roles__c.contains(ConstantClass.ENTITY) && accEntityContUniqueKey!='' && !dupCheckAccConRelSet.contains(accEntityContUniqueKey)){
                        if(ccrObj.Contact__r.AccountId!=NULL){
                            //Creation of Indirect ACR for Account of record Type Entity
                            newAccConRel = new AccountContactRelation();
                            newAccConRel.AccountId = ccrObj.Contract__r.Entity__c;
                            newAccConRel.ContactId=ccrObj.Contact__c;
                            newAccConRel = AccountContactRelationshipBatchHelper.entityACRValuesCalculation(ccrObj, activeRolesWithCCRMap, allRolesWithCCRMap, newAccConRel, entityOwnerPercentageMap, ccrEntityStatusMap, conContractKey);
                            dupDirectAccConRelSet.add(accEntityContUniqueKey);
                            insertAccConRelList.add(newAccConRel);
                        }else{
                            //Creation of Direct ACR by updating AccountId field in Contact record
                            conList.add(AccountContactRelationshipBatchHelper.insertDirectAccountContactRel(ccrObj, ConstantClass.ENTITY));
                        }
                        dupCheckAccConRelSet.add(accEntityContUniqueKey);
                    }
                }
            }
        }
        
        //Insertion of Direct ACR
        if(!conList.isEmpty() && conList.size()>0){
            Database.SaveResult[] updateConResultList= Database.update(conList,False);
            ExceptionHandler.logHandledExceptions(updateConResultList,ConstantClass.ACCOUNTCONTACTRELATIONBATCH,ConstantClass.UPDATECONRESULTLIST,ConstantClass.ACCOUNTCONTACTMANAGEMENT);
            for(Integer i = 0; i < updateConResultList.size(); i++) {  
                Database.SaveResult objConDBSR = updateConResultList[i];
                Contact conObj= conList[i];
                if(!objConDBSR.isSuccess()){
                    failedContractRecSet.add(conObj.Contract__c);
                }
            }
        }
        
        //Insertion of indirect ACR's
        if(!insertAccConRelList.isEmpty() && insertAccConRelList.size()>0){
            Database.saveResult[] insertAccConReltListResult= Database.insert(insertAccConRelList,False);
            ExceptionHandler.logHandledExceptions(insertAccConReltListResult,ConstantClass.ACCOUNTCONTACTRELATIONBATCH,ConstantClass.INSERTACCCONRELTLISTRESULT,ConstantClass.ACCOUNTCONTACTMANAGEMENT);
            for(Integer i = 0; i < insertAccConReltListResult.size(); i++) {  
                Database.saveResult objAccConRelDBSR = insertAccConReltListResult[i];
                AccountContactRelation accConObj= insertAccConRelList[i];
                if(!objAccConRelDBSR.isSuccess()){
                    failedContractRecSet.add(accConObj.Contract__c);
                }
            }
        }
        for(AccountContactRelation acrsObj:[SELECT Id,AccountId,ContactId,Contract_History__c
                                            FROM AccountContactRelation
                                            WHERE ContactId IN: ccrConIdSet
                                            LIMIT 50000]){
                                                accContDirectUniqueKeyMap.put(acrsObj.AccountId+ConstantClass.UNDERSCORE+acrsObj.ContactId,acrsObj);//Map which is having all the direct and indirect ACR's
                                            }
        dupCheckAccConRelSet.clear();
        
        //Updation of Direct and Indirect ACR's
        for(Contract_Contact_Relationship__c ccrObj:ccrList){
            accSiteContUniqueKey='';
            accEntityContUniqueKey='';
            conContractKey='';
            conContractKey = ccrObj.Contract__c+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            if(ccrObj.Contact__r.RecordType.DeveloperName!=ConstantClass.ORGANIZATION ){    
                accSiteContUniqueKey = ccrObj.Contract__r.AccountId+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            }
            if(ccrObj.Contract__r.Entity__c!=null && ccrObj.Roles__c!=null && ccrObj.Roles__c.contains(ConstantClass.ENTITY)){
                accEntityContUniqueKey = ccrObj.Contract__r.Entity__c+ConstantClass.UNDERSCORE+ccrObj.Contact__c;
            }
            if((!dupCheckAccConRelSet.contains(accSiteContUniqueKey) && accSiteContUniqueKey!='') || (!dupCheckAccConRelSet.contains(accEntityContUniqueKey) && accEntityContUniqueKey!='')){
                if(!dupDirectAccConRelSet.contains(accSiteContUniqueKey) || !dupDirectAccConRelSet.contains(accEntityContUniqueKey)){
                    if(!dupCheckAccConRelSet.contains(accSiteContUniqueKey)
                       && accContDirectUniqueKeyMap.containsKey(accSiteContUniqueKey)
                       && !dupDirectAccConRelSet.contains(accSiteContUniqueKey)){
                           //Calling Method to update the Site ACR Values
                           updateAccConRelList.add(AccountContactRelationshipBatchHelper.siteACRValuesCalculation(ccrObj, activeRolesWithCCRMap, allRolesWithCCRMap, accContDirectUniqueKeyMap.get(accSiteContUniqueKey), ccrSiteStatusMap, conContractKey));
                           dupCheckAccConRelSet.add(accSiteContUniqueKey);
                       }
                    if(accContDirectUniqueKeyMap.containsKey(accEntityContUniqueKey)
                       && !dupCheckAccConRelSet.contains(accEntityContUniqueKey)
                       && !dupDirectAccConRelSet.contains(accEntityContUniqueKey)){
                           //Calling Method to update the entity ACR Values
                           updateAccConRelList.add(AccountContactRelationshipBatchHelper.entityACRValuesCalculation(ccrObj, activeRolesWithCCRMap, allRolesWithCCRMap, accContDirectUniqueKeyMap.get(accEntityContUniqueKey), entityOwnerPercentageMap, ccrEntityStatusMap, conContractKey));
                           dupCheckAccConRelSet.add(accEntityContUniqueKey);
                       }
                }
            }
        }
        
        //Updating both Direct and indirect ACR's in Salesforce Database.
        if(!updateAccConRelList.isEmpty() && updateAccConRelList.size()>0){
            Database.saveResult[] updateAccConReltListResult= Database.update(updateAccConRelList,False);
            ExceptionHandler.logHandledExceptions(updateAccConReltListResult,ConstantClass.ACCOUNTCONTACTRELATIONBATCH,ConstantClass.UPDATEACCCONRELTLISTRESULT,ConstantClass.ACCOUNTCONTACTMANAGEMENT);
            for(Integer i = 0; i < updateAccConReltListResult.size(); i++) {  
                Database.saveResult objAccConRelDBSR = updateAccConReltListResult[i];
                AccountContactRelation accConObj = updateAccConRelList[i];
                if(!objAccConRelDBSR.isSuccess()){
                    failedContractRecSet.add(accConObj.Contract__c);
                }
            }
        }
        
        //Fetching all the CCR's related which are failed to insert/update.
        errorCCRMap = new Map<Id,Contract_Contact_Relationship__c>([SELECT Id,Processing_Status__c,Contract__c
                                                                    FROM Contract_Contact_Relationship__c
                                                                    WHERE Contract__c IN: failedContractRecSet
                                                                    LIMIT 50000]);
        
        //Updating the Processing Status of the CCR to either Processed or Error.
        for(Contract_Contact_Relationship__c ccrObj:ccrList){
            if(errorCCRMap.containsKey(ccrObj.Id) && ccrObj.Contract__c==errorCCRMap.get(ccrObj.Id).Contract__c){
                ccrObj.Processing_Status__c=ConstantClass.ERROR;
            }else{
                ccrObj.Processing_Status__c=ConstantClass.PROCESSED;
            }
            updateConContractRelList.add(ccrObj);
        }
        
        //Updating the result of the CCR in Salesforce Database
        if(!updateConContractRelList.isEmpty() && updateConContractRelList.size()>0){
            Database.saveResult[] updateContrctConReltListResult= Database.update(updateConContractRelList,False);
            ExceptionHandler.logHandledExceptions(updateContrctConReltListResult,ConstantClass.ACCOUNTCONTACTRELATIONBATCH,ConstantClass.UPDATECONTRCTCONRELTLISTRESULT,ConstantClass.ACCOUNTCONTACTMANAGEMENT);
        }
    }
     /** 
    *Description: This method is called after all the batches are processed
    *@MethodName: finish
    *@Created by: Vazeer Mohammed
    *@parameters: Database.BatchableContext bc
    *@return: void
    */
    global void finish(Database.BatchableContext bc){
        sequence = null;
        for (Integer minSeq : allSequencesSet){
            sequence = minSeq;
            break;
        }
        allSequencesSet.remove(sequence);
        if(sequence!=null){
            Database.executebatch(new AccountContactRelationshipBatch(sequence,allSequencesSet), batchSize);
        }
    }
}