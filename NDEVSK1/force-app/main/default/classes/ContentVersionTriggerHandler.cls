/** 
@Author : Narsimhulu
@Name   : ContentVersionTriggerHandler
@Created Date: 25/06/2018
@Description: Handler Class for the ContentVersion trigger.
@Version:0.1
@Reference: 
**/
public without sharing class ContentVersionTriggerHandler extends TriggerHandler{
    
    private List<ContentVersion> newList;
    
    /**
    * Description: Constructor of the class, which will intialize oldMap, newMap variables with Tigger.oldMap, Trigger.newMap respectively 
    * @MethodName: ContentVersionTriggerHandler
    * @Created by: Narsimhulu
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public ContentVersionTriggerHandler(){
        this.newList = (List<ContentVersion>) Trigger.new;
    }
    
    /**
    * Description: Override method of TriggerHandler class, which will call restrictExeFiles from ContentVersionTriggerHelper
    * @MethodName: beforeInsert
    * @Created by: Narsimhulu
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void beforeInsert(){
      ContentVersionTriggerHelper.restrictExeFiles(this.newList);
    }
}