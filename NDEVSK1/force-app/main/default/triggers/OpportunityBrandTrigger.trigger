/**
@Author : Vazeer Mohammed
@Name   : OpportunityBrandTrigger 
@Created Date: 10/05/2019 
@Description: To handle all operations on OpportunityBrand Object
@Version:0.1 
@Reference: 
**/
trigger OpportunityBrandTrigger on Opportunity_Brand__c (before insert,before update,before delete,after update) {
	if(!Trigger_Execution_Control__c.getInstance().Skip_OpportunityBrand_Trigger__c){
        new OpportunityBrandTriggerHandler().run();
    }
}