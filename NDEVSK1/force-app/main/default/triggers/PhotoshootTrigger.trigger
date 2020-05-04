/**
@Author : Prathyusha 
@Name   : PhotoshootTrigger
@Created Date: 26/2/2018
@Description: To handle all Photoshoot operations on Trigger
@Version:0.1
@Reference: 
**/
trigger PhotoshootTrigger on Photo_Shoot__c(before insert, after insert,after Update) {
    if(!Trigger_Execution_Control__c.getInstance().Skip_PhotoShoot_Trigger__c) {
        new PhotoshootTriggerHandler().run();
    }
}