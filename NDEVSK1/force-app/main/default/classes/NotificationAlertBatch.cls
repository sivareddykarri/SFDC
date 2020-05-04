/**
 @Author :  Vazeer Mohammed
 @Name   :  NotificationAlertBatch
 @Created Date: 27-Jan-2018
 @Description: 
 @Version:0.1
 @Reference: 
**/
global class NotificationAlertBatch implements database.Batchable<sObject>,Database.Stateful {
    private static Integer NUMBEROFDAYSDUE = Integer.Valueof(Wyndham_Constants_List__c.getInstance('NumberOfDaysDue').Value__c);
    private static Integer NUMBEROFDAYSINACTIVE = Integer.Valueof(Wyndham_Constants_List__c.getInstance('NumberOfDaysInactive').Value__c);
    /* 
    Method Name: start
    Description: This method will get case records  
    */
    global Database.QueryLocator start(database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,CaseNumber,OwnerId,Estimated_Completion_Date__c,LastModifiedDate,Adjusted_ETC__c FROM Case WHERE Status!=:ConstantClass.CLOSED AND Owner.ProfileId!=NULL]); 
    }
    
    /*
    Method Name: execute
    Description: This method posts to chatter on case records when the required criteria are met
    */
    global void execute(Database.BatchableContext bc, List<Case> scope){
        String sText=null;
        ConnectApi.FeedItem objFeedItem;       
        for(case objCase: scope){
            if(string.valueOf(objCase.OwnerId).startsWith(ConstantClass.NUMERIC_005)){
                if(objCase.LastModifiedDate.Date()==System.today().addDays(NUMBEROFDAYSINACTIVE)){
                    sText = ConstantClass.LEFT_BRACE+objCase.OwnerId+ConstantClass.RIGHT_BRACE+ConstantClass.INACTIVITYALERTPRE+ConstantClass.LEFT_PARENTHESIS+objCase.CaseNumber+ConstantClass.RIGHT_PARENTHESIS+ConstantClass.INACTIVITYALERTPOST;
                    objFeedItem = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(),objCase.Id,sText);
                }
                if(objCase.Estimated_Completion_Date__c!=null && objCase.Estimated_Completion_Date__c.Date()==System.today().addDays(NUMBEROFDAYSDUE) && objCase.Adjusted_ETC__c==NULL){
                    sText = ConstantClass.LEFT_BRACE+objCase.OwnerId+ConstantClass.RIGHT_BRACE+ConstantClass.ESTIMATEDDATEALERTPRE+ConstantClass.LEFT_PARENTHESIS+objCase.CaseNumber+ConstantClass.RIGHT_PARENTHESIS+ConstantClass.ESTIMATEDDATEALERTPOST;
                    objFeedItem = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(),objCase.Id,sText);
                }
                else if(objCase.Adjusted_ETC__c!=null && objCase.Adjusted_ETC__c.Date()==System.today().addDays(NUMBEROFDAYSDUE)){
                    sText = ConstantClass.LEFT_BRACE+objCase.OwnerId+ConstantClass.RIGHT_BRACE+ConstantClass.ADJUSTEDESTIMATEDDATEALERTPRE+ConstantClass.LEFT_PARENTHESIS+objCase.CaseNumber+ConstantClass.RIGHT_PARENTHESIS+ConstantClass.ADJUSTEDESTIMATEDDATEALERTPOST;
                    objFeedItem = (ConnectApi.FeedItem)ConnectApiHelper.postFeedItemWithMentions(Network.getNetworkId(),objCase.Id,sText);
                }
            }
        } 
    }
    
    /*
    Method Name: finish
    Description: This method will excute at the end of process
    */ 
    global void finish(Database.BatchableContext bc){
    }
}