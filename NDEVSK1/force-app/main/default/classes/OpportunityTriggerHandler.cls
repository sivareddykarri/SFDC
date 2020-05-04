/** 
@Author :     Prajwal
@Name   :     OpportunityTriggerHandler
@Created Date: 5/08/2019
@Description: Handler Class for the Opportunity trigger.
@Version:0.1

@Update Date: 9/13/2019 by JZ
@Description: add probabilitySystem (Property - %) and probabilityOpen (Openings Probability )


@Update Date: 9/30/2019 by JZ
@Description: SFR-001366 - Opportunity Stages Update - Automate: Update to closed won from contract signed & ACD with execution date
@ Add updateStagetoClosedWon

@Update Date: 12/5/2019 by JZ
@Description: SFR-001469 - Management Probability doesnot change to 100% when Opportunity is closed won
@ switch updateManagementProbability and updateStagetoClosedWon order in OpportunityTriggerHandler.cls

//SFR-001469
//
@Reference: 
**/
public without sharing class OpportunityTriggerHandler extends TriggerHandler{
    private List<Opportunity> newList;
    private List<Opportunity> oldList;
    private Map<Id,Opportunity> oldMap;
    private Map<Id,Opportunity> newMap;
    Id recId;
    List<Opportunity> OpportunityList = new List<Opportunity>();
    
     /**
    * Description: Constructor of the class which will intialize newList variables respectively 
    * @MethodName: OpportunityTriggerHandler
    * @Created by: Prajwal
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public OpportunityTriggerHandler() {
        this.oldMap = (Map<Id,Opportunity>) Trigger.oldMap;
        this.newMap = (Map<Id,Opportunity>) Trigger.newMap;
        this.newList = (List<Opportunity>) Trigger.new;
        this.oldList = (List<Opportunity>) Trigger.old;
    }
    
    /*
    * Description: Override method of TriggerHandler class
    * @MethodName: beforeUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void beforeUpdate(){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Opportunity objOpp: this.newList){
            if(objOpp.StageName != (this.oldMap).get(objOpp.Id).StageName){
                oppList.add(objOpp);
            }
        }
        if(!oppList.isEmpty()){
            OpportunityTriggerHelper.atleastOnePrimaryOpportunityBrand(oppList);
             OpportunityTriggerHelper.updateStagetoClosedWon(oppList); //SFR-001469
            OpportunityTriggerHelper.updateManagementProbability(oppList);
           
            if(OpportunityTriggerHelper.getOppBrandSize(oppList[0].Id) > 0){
                for(Opportunity obj: this.newList){
                    if(obj.Id == oppList[0].Id){
                        obj.Is_Processing__c = true;
                        recId= obj.Id;
                        break;
                    }
                }
                if(recId!=null){
                    OpportunityTriggerHelper.calloutToLegacySalesforce(recId);
                }
            }
        }
    }
}