/**
@Author : Vazeer Mohammed
@Name   : OpportunityTrigger 
@Created Date: 01/05/2019 
@Description: To handle all operations on Opportunity Object
@Version:0.1 
@Reference: 
**/
trigger OpportunityTrigger on Opportunity (before insert,before update) {
    if(!Trigger_Execution_Control__c.getInstance().Skip_Opportunity_Trigger__c){
        new OpportunityTriggerHandler().run();
    }
}