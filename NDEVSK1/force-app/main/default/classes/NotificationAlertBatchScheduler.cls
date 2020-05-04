/**
 @Author :  Prajwal
 @Name   :  NotificationAlertBatchScheduler.
 @Created Date: 06-Apr-2018
 @Description: NotificationAlertBatchScheduler
 @Version:0.1
 @Reference: 
**/
global class NotificationAlertBatchScheduler implements Schedulable{
    private Static final String NOTIFICATIONBATCHSIZE = Wyndham_Constants_List__c.getInstance('NotificationAlertBatchSize').Value__c;
    /*
     Method Name: Execute Scheduler
     Description: This Method will create an Instance of the NotificationAlertBatch Class and will execute batch
    */
    global void execute(SchedulableContext sc){     
        NotificationAlertBatch alertBatchObj = new NotificationAlertBatch();
        database.executebatch(alertBatchObj, Integer.ValueOf(NOTIFICATIONBATCHSIZE));
    }
}