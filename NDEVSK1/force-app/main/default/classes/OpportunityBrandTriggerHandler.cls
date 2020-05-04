/** 
@Author : Vazeer Mohammed
@Name   : OpportunityBrandTriggerHandler
@Created Date: 10/05/2019
@Description: Handler Class for the OpportunityBrand trigger.
@Version:0.1
@Reference: 
**/
public without sharing class OpportunityBrandTriggerHandler extends TriggerHandler {
    
    private Map<Id,Opportunity_Brand__c> oldMap;
    private Map<Id,Opportunity_Brand__c> newMap;
    private List<Opportunity_Brand__c> newList;
    private List<Opportunity_Brand__c> oldList;
    
    /**
    * Description: Constructor of the class, which will intialize oldMap, newMap variables with Tigger.oldMap, Trigger.newMap respectively 
    * @MethodName: OpportunityBrandTriggerHandler
    * @Created by: Vazeer
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public OpportunityBrandTriggerHandler() {
        this.oldMap = (Map<Id,Opportunity_Brand__c>) Trigger.oldMap;
        this.newMap = (Map<Id,Opportunity_Brand__c>) Trigger.newMap;
        this.newList = (List<Opportunity_Brand__c>) Trigger.new;
        this.oldList = (List<Opportunity_Brand__c>) Trigger.old;
    }
    
    /**
    * Description: Override method of TriggerHandler class
    * @MethodName: beforeInsert
    * @Created by: Vazeer Mohammed
    * @parameters: NA
    * @return: void
    * @throws: NA
    */   
    public override void beforeInsert(){
        OpportunityBrandTriggerHelper.removePrimaryOnOtherOppBrands(this.newList);
        OpportunityBrandTriggerHelper.displayErrorIfBrandDuplicate(this.newList);
    }
    
    /**
    * Description: Override method of TriggerHandler class
    * @MethodName: beforeUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void 
    * @throws: NA
    */
    public override void beforeUpdate(){
        
        List<Opportunity_Brand__c> oppBrandList = new List<Opportunity_Brand__c>();
        List<Opportunity_Brand__c> oppBrandPrimaryUpdateList = new List<Opportunity_Brand__c>();
        
        if(ConstantClass.isBeforeUpdateFirstTime && !ConstantClass.getBlnOppBrandTriggerBeforeUpdate()){
            ConstantClass.isBeforeUpdateFirstTime=false;
            
            for(Opportunity_Brand__c objOppBrand: this.newList){
                if(objOppBrand.Product__c != (this.oldMap).get(objOppBrand.Id).Product__c){
                    oppBrandList.add(objOppBrand);
                }
                if(!objOppBrand.Primary__c && objOppBrand.Primary__c != (this.oldMap).get(objOppBrand.Id).Primary__c){
                    oppBrandPrimaryUpdateList.add(objOppBrand);
                }
            }
            if(!oppBrandList.isEmpty()){
                OpportunityBrandTriggerHelper.displayErrorIfBrandDuplicate(oppBrandList); // Duplicate Brand checks
            }
            
            OpportunityBrandTriggerHelper.removePrimaryOnOtherOppBrands(this.newList);
            
            if(!oppBrandPrimaryUpdateList.isEmpty()){
                OpportunityBrandTriggerHelper.atleastOnePrimaryOpportunityBrand(oppBrandPrimaryUpdateList,true);
            }
        }
    }
    /**
    * Description: Override method of TriggerHandler class
    * @MethodName: beforeDelete
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void beforeDelete(){
        OpportunityBrandTriggerHelper.atleastOnePrimaryOpportunityBrand(this.oldList,false);
    }
}