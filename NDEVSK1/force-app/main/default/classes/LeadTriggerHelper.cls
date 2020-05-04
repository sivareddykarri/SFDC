/** 
@Author :     Narsimhulu
@Name   :     LeadTriggerHelper
@Created Date: 4/26/2019
@Description: To handle all lead operations on Trigger
@Version:0.3
@Reference: 
**/
public without sharing class LeadTriggerHelper {
    
    /**
    * Description:Displays Error on Lead when trying to convert Lead as Account and Contact if Lead Influencer checkbox checked and Account/Contact Record Type not Influencer.
    * @MethodName:displayErrorOnLead
    * @Created by:Nasrimhulu
    * @parameters:List<Lead>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    public static void displayErrorOnLead(List<Lead> leadList){
        Set<Id> accIdSet = new Set<Id>(); 
        Set<Id> conIdSet = new Set<Id>();
        Map<Id,String> accIdRecTypeNameMap = new Map<Id,String>();
        Map<Id,String> conIdRecTypeNameMap = new Map<Id,String>();
        try{
            for(Lead leadobj : leadList){
                if (leadobj.ConvertedAccountId != null) {
                    accIDSet.add(leadobj.ConvertedAccountId);
                } 
                if(leadobj.ConvertedContactId != null){ 
                    conIDSet.add(leadobj.ConvertedContactId);
                }
            }
            if(!accIDSet.isEmpty()){
                for(Account objAcc: [SELECT Id, RecordType.Name FROM Account 
                                     WHERE Id = :accIDSet AND CreatedDate<=:System.now().addminutes(-1)
                                     LIMIT 50000]){
                                         accIdRecTypeNameMap.put(objAcc.Id,objAcc.RecordType.Name);
                                     }
            }
            if(!conIDSet.isEmpty()){
                for(Contact objCon: [SELECT Id, RecordType.Name FROM Contact 
                                     WHERE Id = :conIDSet AND CreatedDate<=:System.now().addminutes(-1)
                                     LIMIT 50000]){
                                         conIdRecTypeNameMap.put(objCon.Id,objCon.RecordType.Name);
                                     }
            }
            for(Lead leadrec : leadList){                
                if(leadrec.ConvertedAccountId!=null && accIdRecTypeNameMap.get(leadrec.ConvertedAccountId)!=null && accIdRecTypeNameMap.get(leadrec.ConvertedAccountId)!= ConstantClass.TEMPORARY){
                    leadrec.addError(ConstantClass.ACCOUNTRECORDTYPEINTERMEDIARYERROR);
                }else if(leadrec.ConvertedContactId!=null && conIdRecTypeNameMap.get(leadrec.ConvertedContactId)!=null && conIdRecTypeNameMap.get(leadrec.ConvertedContactId) != ConstantClass.TEMPORARY){
                    leadrec.addError(ConstantClass.CONTACTRECORDTYPEINTERMEDIARYERROR);   
                }  
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.LEADTRIGGERHELPER,ConstantClass.DISPLAYERRORONLEAD,ConstantClass.LEAD_MANAGEMENT); 
        }
    }
    /**
    * Description:
    * @MethodName:createOpportunityProducts
    * @Created by: Vazeer Mohammed
    * @parameters:List<Lead>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    public static void createOpportunityProducts(List<Lead> leadList){
        
        Map<Id,List<String>> brandsAvailableMap = new Map<Id,List<String>>();
        Map<String,Id> brandProductIdMap = new Map<String,Id>();
        Opportunity_Brand__c objOppBrand;
        List<Opportunity_Brand__c> oppBrandList = new List<Opportunity_Brand__c>();
        
        try{
            for(Lead objLead : leadList){
                if(objLead.Brand_Fit_MQ__c!=null && objLead.ConvertedOpportunityId !=null){
                    brandsAvailableMap.put(objLead.Id,objLead.Brand_Fit_MQ__c.split(';'));
                }
            }
            for(Product2 objProd : [SELECT ProductCode FROM product2                         
                                    LIMIT 50000]){
                                        brandProductIdMap.put(objProd.ProductCode, objProd.Id);
                                    }
            for(Lead objLead : leadList){
                if(objLead.ConvertedOpportunityId != null && brandsAvailableMap.get(objLead.Id)!=null){
                    for(String str: brandsAvailableMap.get(objLead.Id)){
                        if(brandProductIdMap.get(str)!=null){
                            objOppBrand = new Opportunity_Brand__c();
                            objOppBrand.Opportunity__c = objLead.ConvertedOpportunityId;
                            objOppBrand.Product__c = brandProductIdMap.get(str);
                            oppBrandList.add(objOppBrand);
                        }
                    }
                }
            }
            if(!oppBrandList.isEmpty()){
                Database.insert(oppBrandList);
            }
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.LEADTRIGGERHELPER,ConstantClass.CREATEOPPORTUNITYPRODUCTS,ConstantClass.LEAD_MANAGEMENT); 
        }
    }
}