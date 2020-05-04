/**
@Author: Vazeer Mohammed
@Name: AccountContactRelationshipBatchTest
@Created Date: 04/13/2018
@Description: Test class for AccountContactRelationshipBatch Class, AccountContactRelationshipScheduler Class
              and AccountContactRelationshipBatch Helper Class
@Version:0.1
@Reference: 
**/
@isTest
private class AccountContactRelationshipBatchTest {
   /**
   *  Description: This test method covers scenarios of AccountContactRelationshipBatch
   *  @name: accountContactRelationBatchMethod
   *  @param: Null
   *  @return: Void
   *  @throws exception:
   */
    static testMethod void accountContactRelationBatchMethod() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{      
                SchedulableContext sContext = null;
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Account objAcc1 = ApexDataUtil.createSiteRecTypeRecord2();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Contact objCon1 = ApexDataUtil.createContactRecUsingParams(objAcc1, 'test', 'User', '23456789', 'xyz@gmail.com');
                Contract objCrt = ApexDataUtil.createContractRecord(objAcc,1);
                Contract objCrt1 = ApexDataUtil.createContractRecord(objAcc1,2);
                Contact objCon2 = ApexDataUtil.createContactRecord1();
                Contact objCon3 = ApexDataUtil.createContactRecUsingParams(objAcc1, 'test1', 'User1', '234567890', 'xyzw@gmail.com');
                
                AccountContactRelation objAccConRel = new AccountContactRelation();
                objAccConRel.AccountId=objAcc1.Id;
                objAccConRel.ContactId=objCon.Id;
                objAccConRel.Contract_History__c = 'test';
                Database.insert(objAccConRel);
                
                AccountContactRelation objAccConRel1 = new AccountContactRelation();
                objAccConRel1.AccountId=objCrt.Entity__c;
                objAccConRel1.ContactId=objCon1.Id;
                objAccConRel1.Contract_History__c = 'test';
                Database.insert(objAccConRel1);
                
               AccountContactRelation objAccConRel2 = new AccountContactRelation();
                objAccConRel2.AccountId=objAcc.Id;
                objAccConRel2.ContactId=objCon1.Id;
                objAccConRel2.Contract_History__c = 'test';
                Database.insert(objAccConRel2);
                
                Contract_Contact_Relationship__c objCrtConRel1 = ApexDataUtil.createContractContactRelationshipRecord(objCrt,objCon1,'DataPack Manager','Active'); 
                Contract_Contact_Relationship__c objCrtConRel2 = ApexDataUtil.createContractContactRelationshipRecord(objCrt,objCon2,'Entity Owner','Active');
                Contract_Contact_Relationship__c objCrtConRel3 = ApexDataUtil.createContractContactRelationshipRecord(objCrt,objCon1,'Entity Principle','Active');
                Contract_Contact_Relationship__c objCrtConRel4 = ApexDataUtil.createContractContactRelationshipRecord(objCrt,objCon2,'Legal Notice','Active');
                Contract_Contact_Relationship__c objCrtConRel5 = ApexDataUtil.createContractContactRelationshipRecord(objCrt,objCon3,'Entity Owner','InActive');
                Contract_Contact_Relationship__c objCrtConRel6 = ApexDataUtil.createContractContactRelationshipRecord(objCrt1,objCon2,'Legal Notice','InActive');
                
                Batch_Class_Execution_Control__c bcec = new Batch_Class_Execution_Control__c();
                bcec.Name = 'AccountContactRelationBatch';
                bcec.Batch_Size__c = 50;
                Database.insert(bcec);
                
                Test.startTest();
                AccountContactRelationshipScheduler accConRelObj  = new AccountContactRelationshipScheduler();
                accConRelObj.execute(sContext);
                Test.stopTest();
                
                System.assertEquals(sContext, null);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'AccountContactRelationshipBatchTest','accountContactRelationBatchMethod','Account-Contact Relationship Management'); 
            }
        }
    }
    
   /**
   * @Description: This test method covers estimated completion date scenario of AccountContactRelationshipBatchTest
   * @name: accountContactRelationBatchTestMethod
   * @param: Null
   * @return: Void
   * @throws exception:
   */
    static testMethod void accountContactRelationBatchTestMethod() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{      
                SchedulableContext sContext = null;
                
                Batch_Class_Execution_Control__c bcec = new Batch_Class_Execution_Control__c();
                bcec.Name = 'AccountContactRelationBatch';
                Database.insert(bcec);
                
                Test.startTest();
                AccountContactRelationshipScheduler accConRelObj  = new AccountContactRelationshipScheduler();
                accConRelObj.execute(sContext);
                Test.stopTest();
                
                System.assertEquals(sContext, null);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'AccountContactRelationshipBatchTest','accountContactRelationBatchTestMethod','Account-Contact Relationship Management'); 
            }
        }
    }
}