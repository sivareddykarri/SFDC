/**
 @Author :  Jim Zheng
 @Name   :  batchARDUpdateScheduler.
 @Created Date: March 3, 2020
 @Description: batchApplicationReceivedDateUpdate  Scheduler
 @Version: 1.0
 @Reference: 
**/
global class batchARDUpdateScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){     
        batchApplicationReceivedDateUpdate ardBatchObj = new batchApplicationReceivedDateUpdate();
        database.executebatch(ardBatchObj, 200);
    }
}