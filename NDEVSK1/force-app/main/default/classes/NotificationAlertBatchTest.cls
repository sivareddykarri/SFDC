/**
@Author :  Prajwal Prakash
@Name   :  NotificationAlertBatchTest
@Created Date: 04/13/2018
@Description: Test class for NotificationAlertBatchTest Class
@Version:0.1
@Reference: 
**/
@isTest
private class NotificationAlertBatchTest{
    @TestSetup static void initData(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='POSC Manager']; 
        User curUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = pro.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser12345t@testorg.com');
        Database.insert(curUser,False);
        
        Wyndham_Constants_List__c wcl = new Wyndham_Constants_List__c();
        wcl.Name = 'NotificationAlertBatchSize';
        wcl.Value__c = '150';
        Database.insert(wcl);
        
        Wyndham_Constants_List__c wcl1 = new Wyndham_Constants_List__c();
        wcl1.Name = 'NumberOfDaysDue';
        wcl1.Value__c = '1';
        Database.insert(wcl1);
        
        Wyndham_Constants_List__c wcl2 = new Wyndham_Constants_List__c();
        wcl2.Name = 'NumberOfDaysInactive';
        wcl2.Value__c = '-2';
        Database.insert(wcl2);
    }
    /**
    * Description: This test method covers estimated completion date scenario of NotificationAlertBatchTest
    * @MethodName: NotificationAlertMethod1
    * @Created by: Prajwal Prakash
    * @parameters: Null
    * @return:Void
    */
    static testMethod void notificationAlertMethod1() {
        User curUser =[Select id,UserName from User Where UserName='standarduser12345t@testorg.com' LIMIT 1];
        System.runAs(curUser){
            try{      
                SchedulableContext sContext = null;
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Case objCase = new Case();
                objCase.AccountId = objAcc.Id;
                objCase.ContactId = objCon.Id;
                objCase.Priority = 'High';
                objCase.Origin = 'Web';
                objCase.status = 'Open';
                objCase.Case_Type__c = 'Finance';
                objCase.Case_Sub_Type__c= 'Financial Performace PPR';
                objCase.Case_Subject__c= 'PPR Report';
                objCase.SLA__c= 24;
                objCase.ownerId= curUser.Id;
                database.insert(objCase);

                Wyndham_Constants_List__c objwcl = [SELECT Id,Name FROM Wyndham_Constants_List__c WHERE Name='NotificationAlertBatchSize' LIMIT 1];
                
                Test.startTest();
                NotificationAlertBatchScheduler notiAlertSch  = new NotificationAlertBatchScheduler();
                notiAlertSch.execute(sContext);
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'NotificationAlertBatchTest','notificationAlertMethod1','Notifications Management'); 
            }
        }
    }
    /**
    * Description: This test method covers Adjusted estimated completion date scenario of NotificationAlertBatchTest
    * @MethodName: NotificationAlertMethod1
    * @Created by: Prajwal Prakash
    * @parameters: Null
    * @return:Void
    */
    static testMethod void notificationAlertMethod2() {
        User curUser =[Select id,UserName from User Where UserName='standarduser12345t@testorg.com' LIMIT 1];
        System.runAs(curUser){
            try{      
                SchedulableContext sContext = null;
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Case objCas2 = ApexDataUtil.createCaseRecord2(objAcc, objCon, curUser.Id);
                
                Wyndham_Constants_List__c objwcl = [SELECT Id,Name FROM Wyndham_Constants_List__c WHERE Name='NotificationAlertBatchSize' LIMIT 1];
                
                Test.startTest();
                NotificationAlertBatchScheduler notiAlertSch  = new NotificationAlertBatchScheduler();
                notiAlertSch.execute(sContext);
                Test.stopTest();
                System.assertEquals(sContext, null);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'NotificationAlertBatchTest','notificationAlertMethod2','Notifications Management'); 
            }
        }
    }
    /**
    * Description: This test method covers Adjusted estimated completion date scenario of NotificationAlertBatchTest
    * @MethodName: NotificationAlertMethod1
    * @Created by: Prajwal Prakash
    * @parameters: Null
    * @return:Void
    */
    static testMethod void notificationAlertMethod3() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{      
                SchedulableContext sContext = null;
                
                Wyndham_Constants_List__c objwcl = [SELECT Id,Name FROM Wyndham_Constants_List__c WHERE Name='NotificationAlertBatchSize' LIMIT 1];
                
                /*Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Case objCas2 = ApexDataUtil.createCaseRecord2(objAcc, objCon, curUser.Id);
                
                objCas2.LastModifiedDate =System.today().addDays(-2);
                Database.update(objCas2);*/
                
                Test.startTest();
                NotificationAlertBatchScheduler notiAlertSch  = new NotificationAlertBatchScheduler();
                notiAlertSch.execute(sContext);
                Test.stopTest();
                
                System.assertEquals(sContext, null);
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'NotificationAlertBatchTest','notificationAlertMethod3','Notifications Management'); 
            }
        }
    }
}