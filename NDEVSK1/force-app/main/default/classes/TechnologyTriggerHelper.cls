/** 
@Author :     Vazeer Mohammed
@Name   :     TechnologyTriggerHelper
@Created Date: 05/12/2018
@Description: To handle all Technology Object operations on TechnologyTrigger
@Version:0.1
@Reference: 
**/
public without sharing class TechnologyTriggerHelper {
    /**
    * Description:
    * @MethodName: restrictPSDRecord
    * @Created by: Vazeer Mohammed
    * @parameters: List<Technology__c>
    * @return:Void
    * @throws Exception-when ever the list is not found.
    */
    public static void restrictPSDRecord(List<Technology__c> technologyList){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,List<Technology__c>> accIdchildTechMap = new Map<Id,List<Technology__c>>();
        Map<ID,Schema.RecordTypeInfo> recordtypeMap = Technology__c.sObjectType.getDescribe().getRecordTypeInfosById();
        for(Technology__c objTech:technologyList){
            if(objTech.Account_Name__c!=null){
                accIdSet.add(objTech.Account_Name__c);
            }
        }
        for(Technology__c objChildTech : [SELECT Id,Account_Name__c,RecordType.Name
                                          FROM Technology__c
                                          WHERE Account_Name__c=:accIdSet 
                                          AND RecordType.Name=:ConstantClass.PROPERTYSUPPORTDATA
                                          LIMIT 50000]){
                                              if(accIdchildTechMap.containsKey(objChildTech.Account_Name__c)){
                                                  accIdchildTechMap.get(objChildTech.Account_Name__c).add(objChildTech);
                                              }else{
                                                  accIdchildTechMap.put(objChildTech.Account_Name__c, new List<Technology__c> {objChildTech});
                                              }
                                          }
        for(Technology__c objChildTech : technologyList){
            if(recordtypeMap.get(objChildTech.RecordTypeId).getName() == ConstantClass.PROPERTYSUPPORTDATA &&
               accIdchildTechMap.containsKey(objChildTech.Account_Name__c) &&
               accIdchildTechMap.get(objChildTech.Account_Name__c).size()>1){
                   objChildTech.addError(ConstantClass.TECHERRORMESSAGE);
               }
        }
    }
}