/***
   @Author: Sunil Seelaboina
   @Name:
   @Created Date: 08/05/2018
   @Description: Test class for WebToCaseHandler class
   @Version: 0.1
   @reference: 
  */
@isTest
private class WebToCaseHandlerTest{
    /**
    * Description: This method will setup all the Test Data
    * @MethodName: testdata
    * @Created by: Narsimhulu
    * @parameters: Null
    * @return:Void
    */
    static testMethod void testdata() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord1();
                PageReference pageRef = Page.WebToCase;
                
                Case objCase1 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00015','Content', '');
                Case objCase2 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00015','Rate Plan','other');
                Case objCase3 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00015','National / Regional Preferred Accounts','other');
                Case objCase4 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00015','General','other');
                Case objCase5 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00014','Rate Plan','Modify');
                Case objCase6 = ApexDataUtil.createCaseInstance(objAcc,objCon,'00014','Room Type','Modify');
                
                objCon.AccountId = objAcc.id;
                objCon.FirstName = 'Test';
                objCon.LastName = 'LastName';
                objCon.Email = 'ab@gmail.com';
                objCon.Phone = '8907654321';
                objCon.HomePhone = '89076543890';
                 
             
             
              /** Attachment attach=new Attachment();  
                attach.Name='Unit Test Attachment';

               Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');

               attach.body=bodyBlob;

               attach.parentId=objCase4.id; **/
                
               //  insert attach;
             //   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objCase4.id];  **/
                
                WebtoCaseHandler cashandler = new WebtoCaseHandler();
                Test.startTest();
                cashandler.casetoinsert=objCase1;  
                cashandler.webToCaseMethod();
                 
                 Attachment attach=new Attachment();  
                 attach.Name='Unit Test Attachment';
                 Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                 attach.body=bodyBlob;
                 attach.parentId=objCase1.id; 
                 Database.insert(attach);
                
                cashandler.casetoinsert=objCase2;  
                cashandler.webToCaseMethod();
                cashandler.casetoinsert=objCase3;  
                cashandler.webToCaseMethod();
                cashandler.casetoinsert=objCase4;  
                cashandler.webToCaseMethod();
                cashandler.casetoinsert=objCase5;  
                cashandler.webToCaseMethod();
                cashandler.casetoinsert=objCase6;  
                cashandler.webToCaseMethod();
                
                Database.update(objCon);
                
                Test.stopTest();
            }
            catch(Exception exc){
                ExceptionHandler.logHandledExceptions(exc,'WebToCaseHandlerTest','testdata','Case Management');
            }
        }
    }
}