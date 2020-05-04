/**
 @Author :  Vazeer Mohammed
 @Name   :  AccountContactRelationshipScheduler
 @Created Date: 23-Apr-2018
 @Description: This is the Scheduler class for AccountContactRelationshipBatch
 @Version:0.1
 @Reference: 
**/
global class AccountContactRelationshipScheduler implements Schedulable{
    private static final Integer INTEGER_DEFAULTBATCHSIZE = 1;
    /**
    * Description: This Method will create an Instance of the AccountContactRelationship Class and will execute batch.
    * @MethodName: execute
    * @Created by: Vazeer Mohammed
    * @parameters: SchedulableContext sc
    * @return: Void
    */
    global void execute(SchedulableContext sc){
        Integer batchSize;
        Batch_Class_Execution_Control__c batchClassExeCon = Batch_Class_Execution_Control__c.getInstance('AccountContactRelationBatch');
        if(batchClassExeCon.Batch_Size__c!=null && batchClassExeCon.Batch_Size__c!=0){
            batchSize=Integer.valueOf(batchClassExeCon.Batch_Size__c);
        }else{
            batchSize=INTEGER_DEFAULTBATCHSIZE;
        }
        AccountContactRelationshipBatch accConBatchObj = new AccountContactRelationshipBatch();
        Database.executebatch(accConBatchObj,batchSize);
    }
}