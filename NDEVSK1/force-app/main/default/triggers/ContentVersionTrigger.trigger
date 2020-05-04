/**
@Author : Narsimhulu
@Name   : ContentVersionTrigger
@Created Date: 27/06/2018
@Description: To handle content version files upload on Trigger
@Version:0.1 
@Reference: 
**/
trigger ContentVersionTrigger on ContentVersion (before insert) {
    if(!Trigger_Execution_Control__c.getInstance().Skip_ContentVersion_Trigger__c) {
        new ContentVersionTriggerHandler().run();
    }
}