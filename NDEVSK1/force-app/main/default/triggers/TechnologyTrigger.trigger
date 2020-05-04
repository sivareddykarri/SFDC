/**
@Author : Vazeer Mohammed
@Name   : TechnologyTrigger
@Created Date: 05/12/2018 
@Description: To handle all Technology operations on Trigger
@Version:0.1 
@Reference: 
**/
trigger TechnologyTrigger on Technology__c (before insert, after insert) {
    if(!Trigger_Execution_Control__c.getInstance().Skip_Technology_Trigger__c){
        new TechnologyTriggerHandler().run();
    }
}