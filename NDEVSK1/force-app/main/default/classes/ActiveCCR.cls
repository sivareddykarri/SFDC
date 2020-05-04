/** 
@Author :     Siva Karri
@Name   :     Active CCR Contacts
@Created Date: 02/03/2020
@Description: To get all the active CCR on the Contract
@Version:0.1
@Reference: 
Due to the time constrain not modifying the existing TopLevelContacts class
**/

public without sharing class ActiveCCR {
    /**
    * Description: To get only the Active CCR records for the Contract (SFR-001797)
    * @MethodName:getActiveCCRs
    * @Created by:Siva Karri
    * @parameters:Record Id
    * @return:Void
    **/
    
    @AuraEnabled
    public static List<Contract_Contact_Relationship__c> getActiveCCRs(id recId)
    {
        String genericQuery;
            genericQuery= 'SELECT Id,Contract__c,Name,Contract__r.Name,Contract__r.ContractNumber,Contract__r.Current_Site_Indicator__c,Roles__c,Owner_Percentage__c from Contract_Contact_Relationship__c where Status__c = \'Active\' and Contact__c = \''+recId+'\' order by Contract__r.ContractNumber DESC'; 
        return Database.query(genericQuery);
    }
}