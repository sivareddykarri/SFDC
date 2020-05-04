/**
@Author: Vazeer Mohammed
@Name: KnownPersonFlagBatchTest
@Created Date: 04/13/2018
@Description: Test class for KnownPersonFlagBatch Class, KnownPersonFlagBatchScheduler Class
@Version:0.1
@Reference: 
**/
@isTest
private class KnownPersonFlagBatchTest {
   /**
   *  Description: This test method covers scenarios of KnownPersonFlagBatch
   *  @name: KnownPersonFlagBatchMethod
   *  @param: Null
   *  @return: Void
   *  @throws exception:
   */
    static testMethod void KnownPersonFlagBatchMethod() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            
            SchedulableContext sContext = null;  
            Account objAcc1 = ApexDataUtil.createSiteRecTypeRecord2();
            Contact objCon = ApexDataUtil.createContactRecord(objAcc1);
            
            Lead objLead = ApexDataUtil.createFranchiseSalesLeadRecord('New','Lead','lead company','lemail@gmail.com','United States','BU');
            Database.insert (new Batch_Class_Execution_Control__c(Name='KnownPersonFlagBatch',Batch_Size__c=50,Known_Contact_Duration__c=0));
            
            Test.startTest();
            KnownPersonFlagScheduler knownpersonflag  = new KnownPersonFlagScheduler();
            knownpersonflag.execute(sContext);
            Test.stopTest();
        }
    }
}