/** 
@Author : Vazeer Mohammed
@Name   : LiveChatTranscriptTriggerHandler
@Created Date: 06/06/2018.
@Description: Handler Class for the LiveChatTranscript trigger.
@Version:0.1
@Reference: 
**/
public without sharing class LiveChatTranscriptTriggerHandler extends TriggerHandler{
     private List<LiveChatTranscript> newList;
    
    /**
    * Description: Constructor of the class
    * @MethodName: LiveChatTranscriptTriggerMainHandler
    * @Created by: Vazeer
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */      
    public LiveChatTranscriptTriggerHandler() {
        this.newList = (List<LiveChatTranscript>)Trigger.new;
    }

    /**
    * Description: Override method of TriggerHandler  class, which will call liveChatUtilMethod from LiveChatTranscriptTriggerHandler
    * @MethodName: beforeInsert
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA 
    */
    public override void beforeInsert() {
        LiveChatTranscriptTriggerHelper.liveChatUtilMethod(this.newList);
    }
    
    /**
    * @Description: Override method of TriggerHandler class
    * @MethodName: beforeUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterUpdate(){
        if(ConstantClass.isAfterUpdateFirstTime){
            ConstantClass.isAfterUpdateFirstTime=false;
            LiveChatTranscriptTriggerHelper.createCaseForFAQ(this.newList);
        }
    }
}