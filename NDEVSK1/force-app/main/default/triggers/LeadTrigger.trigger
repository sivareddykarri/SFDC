/**
@Author : Narsimhulu
@Name   : LeadTrigger 
@Created Date: 04/24/2019 
@Description: To handle all Lead operations on Trigger
@Version:0.1 
@Reference: 
**/
trigger LeadTrigger on Lead (after update) {
     if(!Trigger_Execution_Control__c.getInstance().Skip_Lead_Trigger__c){
        new LeadTriggerHandler().run();
    }
}