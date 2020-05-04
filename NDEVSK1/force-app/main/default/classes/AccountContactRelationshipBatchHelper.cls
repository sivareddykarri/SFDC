/** 
@Author :  Vazeer Mohammed
@Name   :  AccountContactRelationshipBatchHelper
@Created Date: 12/09/2018
@Description: Helper Class to handle all the operations on AccountContactRelationBatch
@Version:0.1
@Reference: 
**/
public class AccountContactRelationshipBatchHelper {
    /**
    * Description: Creates Direct ACR record by updating the Account Name in the Contact record.
    * @MethodName: insertDirectAccountContactRel
    * @Created by: Vazeer Mohammed
    * @parameters: Contract_Contact_Relationship__c,String
    * @return: Contact
    */
    Public Static Contact insertDirectAccountContactRel(Contract_Contact_Relationship__c ccrObj,String recordTypeName){
        Contact con=ccrObj.Contact__r;
        if(recordTypeName==ConstantClass.SITE){
            con.AccountId=ccrObj.Contract__r.AccountId;
        }else{
            con.AccountId=ccrObj.Contract__r.Entity__c;
        }
        con.Contract__c=ccrObj.Contract__c;
        return con;
    }
    
    /**
    * Description : Calculates and updates the Site ACR Values
    * @MethodName : siteACRValuesCalculation
    * @Created by : Vazeer Mohammed
    * @parameters : Contract_Contact_Relationship__c,Map<String,Set<String>>,Map<String,Set<String>>,AccountContactRelation,Map<String,String>,String
    * @return : AccountContactRelation
    */
    Public Static AccountContactRelation siteACRValuesCalculation(Contract_Contact_Relationship__c ccrObj,
                                                                 Map<String,Set<String>> activeRolesWithCCRMap,
                                                                 Map<String,Set<String>> allRolesWithCCRMap,
                                                                 AccountContactRelation newAccConRel,
                                                                 Map<String,String> ccrSiteStatusMap,
                                                                 String conContractKey){
        
        newAccConRel.Roles='';
        if(activeRolesWithCCRMap.containsKey(conContractKey) && activeRolesWithCCRMap.get(conContractKey)!=null){
            for(String strObj: activeRolesWithCCRMap.get(conContractKey)){
                newAccConRel.Roles+=strObj+ConstantClass.SEMICOLON;
            }
        }else if(allRolesWithCCRMap.containsKey(conContractKey) && allRolesWithCCRMap.get(conContractKey)!=null){
            for(String strObj: allRolesWithCCRMap.get(conContractKey)){
                newAccConRel.Roles+=strObj+ConstantClass.SEMICOLON;
            }
        }
        if(ccrObj.Contact__r.RecordType.DeveloperName == ConstantClass.SITE){
            newAccConRel.Contact_Type__c=ConstantClass.TOPLEVEL;
        }else{
            newAccConRel.Contact_Type__c=NULL;
        }
        if(ccrObj.Contract__r.Status__c==8 || ccrObj.Contract__r.Status__c==9 || ccrObj.Contract__r.Status__c==11){
               newAccConRel.IsActive=False;
           }else if(ccrSiteStatusMap.containsKey(conContractKey) && ccrSiteStatusMap.get(conContractKey)!=null){
               newAccConRel.IsActive=True;
           }else{
               newAccConRel.IsActive=False;
           }
        newAccConRel.Owner_Percentage__c=NULL;
        newAccConRel.Contract__c=ccrObj.Contract__c;
        if(newAccConRel.Contract_History__c==null){
            newAccConRel.Contract_History__c = ccrObj.Contract__r.ContractNumber+'_'+ccrObj.Contract__r.Sequence__c;
        }else{
            newAccConRel.Contract_History__c = ccrObj.Contract__r.ContractNumber+'_'+ccrObj.Contract__r.Sequence__c+'|'+newAccConRel.Contract_History__c;
            if(newAccConRel.Contract_History__c.length() >=255){
                newAccConRel.Contract_History__c = newAccConRel.Contract_History__c.substringBeforeLast('|');
            }
        }
       return newAccConRel;                      
    }
    
    /**
    * Description: Calculates and updates the entity ACR Values
    * @MethodName: entityACRValuesCalculation
    * @Created by: Vazeer Mohammed
    * @parameters: Contract_Contact_Relationship__c,Map<String,Set<String>>,Map<String,Set<String>>,AccountContactRelation,Map<String,Decimal>,Map<String,String>,String
    * @return: AccountContactRelation
    */
    Public Static AccountContactRelation entityACRValuesCalculation(Contract_Contact_Relationship__c ccrObj,
                                                                    Map<String,Set<String>> activeRolesWithCCRMap,
                                                                    Map<String,Set<String>> allRolesWithCCRMap,
                                                                    AccountContactRelation newAccConRel,
                                                                    Map<String,Decimal> entityOwnerPercentageMap,
                                                                    Map<String,String> ccrEntityStatusMap,
                                                                    String conContractKey){
        Set<String> entityRolesSet = new Set<String>();
        newAccConRel.Roles='';
        if(activeRolesWithCCRMap.containsKey(conContractKey) && activeRolesWithCCRMap.get(conContractKey)!=null){
                for(String removeStr:activeRolesWithCCRMap.get(conContractKey)){
                    if(removeStr==ConstantClass.ENTITYOWNER || removeStr==ConstantClass.ENTITYPRINCIPLE){
                        entityRolesSet.add(removeStr);
                    }
                }
                for(String objStr: entityRolesSet){
                    newAccConRel.Roles+=objStr+ConstantClass.SEMICOLON;
                }
            }
            if(newAccConRel.Roles=='' && allRolesWithCCRMap.containsKey(conContractKey) && allRolesWithCCRMap.get(conContractKey)!=null){
                for(String removeStr:allRolesWithCCRMap.get(conContractKey)){
                    if(removeStr==ConstantClass.ENTITYOWNER || removeStr==ConstantClass.ENTITYPRINCIPLE){
                        entityRolesSet.add(removeStr);
                    }
                }
                for(String objStr: entityRolesSet){
                    newAccConRel.Roles+=objStr+ConstantClass.SEMICOLON;
                }
            }
            if(ccrObj.Contact__r.RecordType.DeveloperName == ConstantClass.SITE){
                newAccConRel.Contact_Type__c=ConstantClass.TOPLEVEL;
            }else{
                newAccConRel.Contact_Type__c=NULL;
            }   
            if(entityOwnerPercentageMap.containsKey(conContractKey) && entityOwnerPercentageMap.get(conContractKey)!=null){
                newAccConRel.Owner_Percentage__c=entityOwnerPercentageMap.get(conContractKey);
            }else{
                newAccConRel.Owner_Percentage__c=NULL;
            }
            if(ccrEntityStatusMap.containsKey(conContractKey) && ccrEntityStatusMap.get(conContractKey)!=null){
                newAccConRel.IsActive=True;
            }else{
                newAccConRel.IsActive=False;
            }                                                                        
            newAccConRel.Contract__c=ccrObj.Contract__c;
            if(newAccConRel.Contract_History__c==null){
                newAccConRel.Contract_History__c = ccrObj.Contract__r.ContractNumber+'_'+ccrObj.Contract__r.Sequence__c;
            }else{
                newAccConRel.Contract_History__c = ccrObj.Contract__r.ContractNumber+'_'+ccrObj.Contract__r.Sequence__c+'|'+newAccConRel.Contract_History__c;
                if(newAccConRel.Contract_History__c.length() >=255){
                  newAccConRel.Contract_History__c = newAccConRel.Contract_History__c.substringBeforeLast('|');
              }
            }
        return newAccConRel;                                         
    }
}