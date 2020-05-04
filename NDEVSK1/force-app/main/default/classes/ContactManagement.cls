/**
@Author :  Vazeer Mohammed
@Name   :  ContactManagement
@Created Date: 09/05/2018
@Description: This Class is used to Handle Contact related Operations
@Version:0.3
@Reference: 
**/
public without sharing class ContactManagement {
    /**
    * Description: This method is used across all the channels to fetch existing Contacts and to Create Account Contact relationships
    * @MethodName: genericMethodToFetchContact
    * @Created by: Vazeer Mohammed
    * @parameters: List<sObject> 
    * @return: List<Contact>
    */
    public static List<Contact> genericMethodToFetchContact(List<sObject> sObjList){
        Map<String,String> accNameMap = new Map<String,String>();
        List<AccountContactRelation> accConRelList = new List<AccountContactRelation>();
        List<Contact> existingConList = new List<Contact>();
        List<Contact> exactContactList = new List<Contact>();
        List<Contact> conUpdateList = new List<Contact>();
        Set<String> fNameSet = new Set<String>();
        Set<String> lNameSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> accNameSet = new Set<String>();        
        Accountcontactrelation objAccCon;
        sObject fldName;
        String siteNumber;
        for(Integer i = 0; i < sObjList.size(); i++){
            fldName = sObjList.get(i);
            fNameSet.add(String.valueof(fldName.get(ConstantClass.CONTACTFIRSTNAMEFIELD)));
            lNameSet.add(String.valueof(fldName.get(ConstantClass.CONTACTLASTNAMEFIELD)));
            emailSet.add(String.valueof(fldName.get(ConstantClass.CONTACTEMAILFIELD)));
            phoneSet.add(String.valueof(fldName.get(ConstantClass.CONTACTPHONEFIELD)));
            accNameSet.add(String.valueof(fldName.get(ConstantClass.ACCOUNTNAMEFIELD)));
        }
        try{
            for(Account objAcc:[SELECT Id,Name,EXT_Site_Id__c FROM Account
                                WHERE EXT_Site_Id__c=:accNameSet
                                LIMIT 50000]){
                                    accNameMap.put(objAcc.EXT_Site_Id__c,objAcc.Id);
                                }
            existingConList = [SELECT Id,AccountId,FirstName,LastName,Email,MobilePhone,OtherPhone,Phone 
                                  FROM Contact
                                  WHERE FirstName=:fNameSet
                                  AND LastName=:lNameSet
                                  AND (Email=:emailSet OR MobilePhone=:phoneSet OR OtherPhone=:phoneSet OR Phone=:phoneSet)
                                  LIMIT 50000];
            for(Integer i = 0; i < sObjList.size(); i++){
                fldName = sObjList.get(i);
                for(Contact objCon:existingConList){
                    siteNumber = string.valueof(fldName.get(ConstantClass.ACCOUNTNAMEFIELD));
                    if(objCon.FirstName==fldName.get(ConstantClass.CONTACTFIRSTNAMEFIELD) 
                       && objCon.LastName==fldName.get(ConstantClass.CONTACTLASTNAMEFIELD)
                       && (objCon.Email==fldName.get(ConstantClass.CONTACTEMAILFIELD) || objCon.MobilePhone==fldName.get(ConstantClass.CONTACTPHONEFIELD) || objCon.OtherPhone==fldName.get(ConstantClass.CONTACTPHONEFIELD) || objCon.Phone==fldName.get(ConstantClass.CONTACTPHONEFIELD))
                       && accNameMap.get(siteNumber)!=NULL && siteNumber!=NULL){
                           exactContactList.add(objCon);
                           if(objCon.AccountId==NULL){
                               objCon.AccountId= accNameMap.get(siteNumber);
                               conUpdateList.add(objCon);
                           }else if(objCon.AccountId!=accNameMap.get(siteNumber)){
                               objAccCon=new Accountcontactrelation();
                               objAccCon.AccountId=accNameMap.get(siteNumber);
                               objAccCon.ContactId=objCon.Id;
                               accConRelList.add(objAccCon);
                           }
                       }
                }
            }
            if(!conUpdateList.isEmpty()){
                Database.Update(conUpdateList,False);
            }
            if(!accConRelList.isEmpty()){
                Database.insert(accConRelList,false);
            }
        }
        catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.CONTACTMANAGEMENT,ConstantClass.GENERICMETHODTOFETCHCONTACT,ConstantClass.CONTACTMANAGEMENT);
        }
        return exactContactList;
    }
}