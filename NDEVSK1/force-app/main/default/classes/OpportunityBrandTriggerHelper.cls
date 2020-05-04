/** 
@Author :  Vazeer Mohammed
@Name   :  OpportunityBrandTriggerHelper
@Created Date: 10/05/2019
@Description: Helper class to handle all Opportunity Brand operations on Trigger
@Version:0.3
@Reference: 
**/
public class OpportunityBrandTriggerHelper {
    
    /**
    * @Description: Displays Error if the User tries to Create a duplicate Brand
    * @MethodName: displyErrorIfBrandDuplicate
    * @Created by: Vazeer Mohammed
    * @parameters: List<Opportunity_Brand__c>
    * @return: Void
    * @throws Exception-when ever the list is not found.
    */
    public static void displayErrorIfBrandDuplicate(List<Opportunity_Brand__c> oppBrandList){
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Set<Id>> oppBrandIdMap = new Map<Id,Set<Id>>();
        try{
            for(Opportunity_Brand__c objBrand: oppBrandList){
                oppIdSet.add(objBrand.Opportunity__c);
            }
            for(Opportunity_Brand__c objBrand: [SELECT Id,Product__c,Opportunity__c
                                                FROM Opportunity_Brand__c 
                                                WHERE Opportunity__c=:oppIdSet]){
                if(oppBrandIdMap.containsKey(objBrand.Opportunity__c)){
                    oppBrandIdMap.get(objBrand.Opportunity__c).add(objBrand.Product__c);
                }else{
                    oppBrandIdMap.put(objBrand.Opportunity__c, new Set<Id>{objBrand.Product__c});
                }
            }
            for(Opportunity_Brand__c objBrand: oppBrandList){
                if(oppBrandIdMap.containsKey(objBrand.Opportunity__c) && oppBrandIdMap.get(objBrand.Opportunity__c) != null){
                    for(Id objId: oppBrandIdMap.get(objBrand.Opportunity__c)){
                        if(objBrand.Product__c == objId){
                            objBrand.addError(ConstantClass.DUPLICATEBRANDERROR);
                        }
                    }
                }
            }
        }catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.OPPORTUNITYBRANDTRIGGERHELPER,ConstantClass.DISPLAYERRORIFBRANDDUPLICATE,ConstantClass.OPPORTUNITY_BRAND_MANAGEMENT);
        }
    }

    /**
    * @Description: Updates the Other Primary Opportunity Brands to non-primary if the User tries to Create/update New Primary OpportunityBrands
    * @MethodName: removePrimaryOnOtherOppBrands
    * @Created by: Vazeer Mohammed
    * @parameters: List<Opportunity_Brand__c>
    * @return: Void
    * @throws Exception-when ever the list is not found.
    */
    public static void removePrimaryOnOtherOppBrands(List<Opportunity_Brand__c> oppBrandFilteredList){
        Set<Id> oppIdSet = new Set<Id>();
        List<Opportunity_Brand__c> oppBrandList = new List<Opportunity_Brand__c>();
        try{
            for(Opportunity_Brand__c objOppBrand : oppBrandFilteredList){
                if(objOppBrand.Opportunity__c!=null && objOppBrand.Primary__c){
                    oppIdSet.add(objOppBrand.Opportunity__c);
                }
            }
            if(!oppIdSet.isEmpty()){
                for(Opportunity_Brand__c objOppBrand : [SELECT Id, Primary__c FROM Opportunity_Brand__c 
                                                        WHERE Id !=:oppBrandFilteredList AND Opportunity__c=:oppIdSet
                                                        AND Primary__c=true
                                                        LIMIT 50000]){
                                                            objOppBrand.Primary__c=false;
                                                            oppBrandList.add(objOppBrand);
                                                        }
                if(!oppBrandList.isEmpty()){
                    ConstantClass.setBlnOppBrandTriggerBeforeUpdate(true);
                    Database.update(oppBrandList);
                }
            }
        }catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.OPPORTUNITYBRANDTRIGGERHELPER,ConstantClass.REMOVEPRIMARYONOTHEROPPBRANDS,ConstantClass.OPPORTUNITY_BRAND_MANAGEMENT);
        }
    }
    
    /**
    * @Description: Displays Error When Opportunity Stage is in Application, Negotation,
                   Contracting, Contract Signed, or Closed Won without Primary Opportunity Brand
    * @MethodName: atleastOnePrimaryOpportunityBrand
    * @Created by: Vazeer Mohammed
    * @parameters: List<Opportunity_Brand__c>, boolean
    * @return: Void
    * @throws Exception-when ever the list is not found.
    */
    public static void atleastOnePrimaryOpportunityBrand(List<Opportunity_Brand__c> oppBrandFilteredList,boolean updateAction){
        Set<Id> oppIdSet = new Set<Id>();
        try{
            for(Opportunity_Brand__c objOppBrand : oppBrandFilteredList){
                oppIdSet.add(objOppBrand.Opportunity__c);
            }
            if(!oppIdSet.isEmpty()){
                List<Opportunity_Brand__c> primaryOppBrandList = [SELECT Id, Primary__c,Opportunity__c,Opportunity__r.StageName
                                                                  FROM Opportunity_Brand__c
                                                                  WHERE Opportunity__c=:oppIdSet 
                                                                  AND Primary__c=true 
                                                                  AND Opportunity__r.StageName!=:ConstantClass.NEWSTATUS
                                                                  AND Opportunity__r.StageName!=:ConstantClass.CLOSEDLOST
                                                                  LIMIT 50000];
                if(primaryOppBrandList.size()==1){
                    for(Opportunity_Brand__c objOpp : oppBrandFilteredList){
                        if(updateAction){
                            objOpp.addError(ConstantClass.PRIMARYBRANDERROR);
                        }else if(!updateAction && objOpp.Primary__c){
                            objOpp.addError(ConstantClass.PRIMARYBRANDERROR);
                        }
                    }
                }
            }
        }catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.OPPORTUNITYBRANDTRIGGERHELPER,ConstantClass.ATLEASTONEPRIMARYOPPORTUNITYBRAND,ConstantClass.OPPORTUNITY_BRAND_MANAGEMENT);
        }
    } 
}