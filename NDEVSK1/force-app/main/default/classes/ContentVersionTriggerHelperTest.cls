/**
@Author :     Narsimhulu
@Name   :     ContentVersionTriggerHelperTest
@Created Date: 6/27/2018
@Description: To cover the Test scenarios on ContentVersionTriggerHelper.
@Version:0.0
@Reference: 
**/
@isTest
Private class ContentVersionTriggerHelperTest{
    /**
    * Description:
    * @MethodName:restrictExeFilesTest
    * @Created by:Narsimulu
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void restrictExeFilesTest(){   
         
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
               List<ContentVersion> cvList = new List<ContentVersion>(); 
                
               Test.startTest();
                ContentVersion cv = new ContentVersion();
                cv.PathOnClient = 'download.jfif';
                cvList.add(cv);
                Database.insert(cvList);
                Test.stopTest();
              
            }
            catch(exception exc) {
                ExceptionHandler.logHandledExceptions(exc,'ContentVersionTriggerHelperTest','restrictExeFilesTest','Live Chat Functionality'); 
            }
        }
    }
    
    /**
    * Description:
    * @MethodName:restrictExeFilesTestMethod
    * @Created by:Narsimulu
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void restrictExeFilesTestMethod(){   
         
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
               List<ContentVersion> cvList = new List<ContentVersion>(); 
                
               Test.startTest();
                ContentVersion cv = new ContentVersion();
                cv.PathOnClient = 'eclipse.exe';
                cvList.add(cv);
                Database.insert(cvList);
                Test.stopTest();
            }
            catch(exception exc) {
                ExceptionHandler.logHandledExceptions(exc,'ContentVersionTriggerHelperTest','restrictExeFilesTestMethod','Live Chat Functionality'); 
            }
        }
    }
}