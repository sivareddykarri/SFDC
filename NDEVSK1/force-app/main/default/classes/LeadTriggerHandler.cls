/** 
@Author :     Narsimhulu
@Name   :     LeadTriggerHandler
@Created Date: 4/26/2019
@Description: Handler Class for the Lead trigger.
@Version:0.3
@Reference: 
**/
public without sharing class LeadTriggerHandler extends TriggerHandler {

    private List<Lead> newList;
    private List<Lead> oldList;
    private Map<Id,Lead> oldMap;
    private Map<Id,Lead> newMap;
    List<Lead> leadList = new List<Lead>();
    
     /**
    * Description: Constructor of the class which will intialize newList variables respectively 
    * @MethodName: LeadTriggerHandler
    * @Created by: Narsimhulu
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public LeadTriggerHandler() {
        this.oldMap = (Map<Id,Lead>) Trigger.oldMap;
        this.newMap = (Map<Id,Lead>) Trigger.newMap;
        this.newList = (List<Lead>) Trigger.new;
        this.oldList = (List<Lead>) Trigger.old;
    }
    /**
    * Description: Override method of TriggerHandler class, which will call displayErrorOnLead
    * @MethodName: afterUpdate
    * @Created by: Narsimhulu
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterUpdate(){
        for(Lead objLead : this.newList){
            if(objLead.isConverted){
                leadList.add(objLead);
            }
        }
        if(!leadList.isEmpty()){
            LeadTriggerHelper.createOpportunityProducts(leadList);
            LeadTriggerHelper.displayErrorOnLead(leadList);
        }
    }
}