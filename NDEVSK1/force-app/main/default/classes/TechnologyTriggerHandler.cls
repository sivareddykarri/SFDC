/** 
@Author : Vazeer Mohammed
@Name   : TechnologyTriggerHandler
@Created Date: 06/06/2018
@Description: Handler Class for the Technology trigger.
@Version:0.1
@Reference: 
**/
public without sharing class TechnologyTriggerHandler extends TriggerHandler {
    
    private Map<Id,Technology__c> oldMap;
    private Map<Id,Technology__c> newMap;
    private List<Technology__c> newList;
    private List<Technology__c> oldList;
    
    /**
    * Description: Constructor of the class, which will intialize oldMap, newMap variables with Tigger.oldMap, Trigger.newMap respectively 
    * @MethodName: TechnologyTriggerHandler Constructor
    * @Created by: Vazeer
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public TechnologyTriggerHandler() {
        this.oldMap = (Map<Id,Technology__c>) Trigger.oldMap;
        this.newMap = (Map<Id,Technology__c>) Trigger.newMap;
        this.newList = (List<Technology__c>) Trigger.new;
        this.oldList = (List<Technology__c>) Trigger.old;
    }

    /**
    * Description: Override method of TriggerHandler class
    * @MethodName: beforeInsert
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */   
    public override void beforeInsert(){
        //TechnologyTriggerHelper.restrictPSDRecord(this.newList);
    }
    /**
    * Description: 
    * @MethodName: afterInsert
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterInsert(){
		TechnologyTriggerHelper.restrictPSDRecord(this.newList);
    }
}