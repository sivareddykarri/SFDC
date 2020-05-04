/**
 @Author :  Narsimha
 @Name   :  KnownPersonFlagBatch
 @Created Date: 12-June-2019
 @Description: Using this batch process we are Updating Requires Attention as False in Lead and Contact
 @Version:0.1
 @Reference: 
**/
global class KnownPersonFlagBatch implements Database.Batchable<sObject>{
    private static Integer knowncontactduration= Integer.valueOf(Batch_Class_Execution_Control__c.getInstance('KnownPersonFlagBatch').Known_Contact_Duration__c);
    private static Integer batchSize = Integer.valueOf(Batch_Class_Execution_Control__c.getInstance('KnownPersonFlagBatch').Batch_Size__c);
    List<sObject> sObjList = new List<sObject>();
    List<Id> idList = new List<Id>();
    Date knownConDate = System.today().addDays(-(knowncontactduration == null ? 0 : knowncontactduration));
    String query;
    String objectName = ConstantClass.LEAD;
   
    /*Constructor Name: KnownPersonFlagBatch
     Description : Constructor( Used for Constructor Overrloading below)
    */
    global KnownPersonFlagBatch(){
     
    }
    global KnownPersonFlagBatch(String chain){
        objectName = chain;
    }
    /** 
    *Description: This Start Method will queries all the 
    *@MethodName: start
    *@Created by: Narsimha
    *@parameters: database.BatchableContext bc
    *@return: Database.QueryLocator
    */
    global Database.QueryLocator start(database.BatchableContext bc){
        query = 'SELECT Id,Requires_Attention__c,Form_Submission_Date__c from '+objectName+' WHERE Requires_Attention__c = TRUE AND Form_Submission_Date__c <=: knownConDate';
        return Database.getQueryLocator(query);        
    }
     /** 
    *Description: 
    *@MethodName: execute
    *@Created by: Narsimha
    *@parameters: database.BatchableContext bc, List<sObject> scope
    *@return: void
    */
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        String sObjName = scope[0].Id.getSObjectType().getDescribe().getName();
        for(sObject objScope : scope){
            idList.add(objScope.Id);
        }
        if(sObjName==ConstantClass.LEAD){
            for(Lead objLead : [SELECT Id,Requires_Attention__c FROM Lead WHERE Id=:idList LIMIT 50000]){
                objLead.Requires_Attention__c=false;
                objLead.Form_Submission_Date__c = NULL;
                sObjList.add(objLead);
            } 
        }else if(sObjName==ConstantClass.CONTACT){
            for(Contact objCon : [SELECT Id,Requires_Attention__c FROM Contact WHERE Id=:idList LIMIT 50000]){
                objCon.Requires_Attention__c=false;
                objCon.Form_Submission_Date__c = NULL;
                sObjList.add(objCon);
            }
        }
        if(!sObjList.isEmpty()){
            Database.update(sObjList);
        }  
    }
    /** 
    *Description: This method is called after all the batches are processed
    *@MethodName: finish
    *@Created by: Narsimha
    *@parameters: Database.BatchableContext bc
    *@return: void
    */
    global void finish(Database.BatchableContext bc){
        if(objectName==ConstantClass.LEAD){
            Database.executebatch(new KnownPersonFlagBatch(ConstantClass.CONTACT), batchSize==null ? 100 :batchsize);
        }
    }
}