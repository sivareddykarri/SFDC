/**
@Author : Prathyusha
@Name   : CaseTrigger 
@Created Date: 11/01/2018 
@Description: To handle all Case operations on Trigger
@Version:0.1 
@Reference: 
**/
trigger CaseTrigger on Case (before insert,after insert,before update,after update) {
    if(!Trigger_Execution_Control__c.getInstance().Skip_Case_Trigger__c){
        new CaseTriggerHandler().run();
    }
}