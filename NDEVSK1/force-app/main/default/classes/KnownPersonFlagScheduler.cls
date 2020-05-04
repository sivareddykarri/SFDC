/**
 @Author :  Narsimha
 @Name   :  KnownPersonFlagScheduler
 @Created Date: 12-June-2019
 @Description: This is the Scheduler class for LeadContactReqAttFalseBatch
 @Version:0.1
 @Reference: 
**/
global class KnownPersonFlagScheduler implements Schedulable{
    private static final Integer INTEGER_DEFAULTBATCHSIZE = 100;
    /**
    * Description: This Method will create an Instance of the LeadContactReqAttBatch Class and will execute batch.
    * @MethodName: execute
    * @Created by: Narsimha
    * @parameters: SchedulableContext sc
    * @return: Void
    */
    global void execute(SchedulableContext sc){
        Integer batchSize;
        Batch_Class_Execution_Control__c batchClassExeCon = Batch_Class_Execution_Control__c.getInstance('KnownPersonFlagBatch');
        if(batchClassExeCon.Batch_Size__c!=null && batchClassExeCon.Batch_Size__c!=0){
            batchSize=Integer.valueOf(batchClassExeCon.Batch_Size__c);
        }else{
            batchSize=INTEGER_DEFAULTBATCHSIZE;
        }
        KnownPersonFlagBatch knownPersonBatchObj = new KnownPersonFlagBatch();
        Database.executebatch(knownPersonBatchObj,batchSize);
    }
}