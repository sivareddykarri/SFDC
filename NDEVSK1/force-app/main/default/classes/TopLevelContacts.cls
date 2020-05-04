/** 
@Author :     Siva Karri
@Name   :     TopLevelContacts
@Created Date: 09/25/2019
@Description: To get all the active Top Level Contacts on the site
@Version:0.1
@Reference: 
**/

public without sharing class TopLevelContacts {
    /**
    * Description: To get the Top Level Contacts related to the Site ID (SFR-001389)
    * @MethodName:getTopLevelContacts
    * @Created by:Siva Karri
    * @parameters:Record Id
    * @return:Void
    **/
    
    @AuraEnabled
    public static List<AccountContactRelation> getTopLevelContacts(id recId)
    {
        String sObjName = recId.getSObjectType().getDescribe().getName();
        String sObjFieldName;
        String genericQuery;
		String ContactType = 'Top Level';
             if(sObjName==ConstantClass.ACCOUNTOBJECT){
                sObjFieldName='AccountId';
            }else{
                sObjFieldName=sObjName+'__c';
            }
			genericQuery='SELECT ContactId,Contact.Name,Roles,Contact.Phone,Contact.Email from AccountContactRelation where Contact_Type__c = \''+ContactType+'\'' + 'and IsActive= true and '+sObjFieldName+' = \''+recId+'\'';        

        return Database.query(genericQuery);
    }
}