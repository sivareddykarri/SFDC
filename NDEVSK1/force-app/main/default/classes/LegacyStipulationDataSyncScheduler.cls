/**
 @Author :  Siva Karri
 @Name   :  LegacyStipulationDataSyncScheduler.
 @Created Date: 10-May-2019
 @Description: Use to schedule the Legacy Stipulation Data Sync job
 @Version:0.1
 @Reference: 
**/
/** 
Developer console :
LegacyStipulationDataSyncScheduler abc = new LegacyStipulationDataSyncScheduler(); 
abc.execute(null);
//select id,name,Effective_Date__c,Legacy_Stipulation_Key__c,Shape1__c,Radius__c,Oracle_Key__c from Stipulation__c
 **/

global class LegacyStipulationDataSyncScheduler implements Schedulable{
    global void execute(SchedulableContext sc){     
        ID jobID = System.enqueueJob(new LegacyGeoPointeShapeDataSync());
    }
}