/**
@Author : Prathyusha
@Name   : LiveChatTranscriptTrigger
@Created Date: 04/12/2018 
@Description: To handle all LiveChatTranscript  operations on Trigger
@Version:0.1
@Reference: 
**/
trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert,before update,after insert,after update){
    if(!Trigger_Execution_Control__c.getInstance().Skip_LiveChatTranscript_Trigger__c ){
        new LiveChatTranscriptTriggerHandler().run();
    }
}