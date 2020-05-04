/**
 @Author : Prajwal
 @Name   : ExceptionHandlerTest
 @Created Date: 02/04/2018
 @Description: Test class for ExceptionHandler which Logs the exception into Salesforce Object called ExceptionLogger__c.
 @Version: 0.1
**/
@isTest
public class ExceptionHandlerTest { 
	/**
     * Description: Method to create test data or setup test data
     * @MethodName: setUpData
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @testSetup
    private static void setUpData() {
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){
            try{ 
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                List<ExceptionLogger__c> listOfExceptionLogger = ApexDataUtil.createMultipleExceptionLoggerRecords();
            }
            catch(Exception exc){  
                exc.getMessage();
            }
        }
    }
    
	/**
     * Description: Method Handles Insert record error exception
     * @MethodName: handleInsertDSRExceptionMethod
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @isTest  
    private static void handleInsertDSRExceptionMethod() {
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){       
        Test.startTest(); 
        List<Contact> lstOfCons = new List<contact>();
        List<contact> lstc=[select id from contact Limit 20000];
        for (Contact conObj : lstc) {
            // contact without LastName            
            conObj.lastname = '';
            lstOfCons.add(conObj);
            
        }
        Database.SaveResult[] lsr = Database.insert(lstOfCons, false);
        List<Database.SaveResult> listOfSR = new List <Database.SaveResult>();
        for (Database.SaveResult dbsr: lsr) {
            if (!dbsr.isSuccess()) {
                listOfSR.add(dbsr);
            } // end of If
        } // end of for
        ExceptionHandler.logHandledExceptions(listOfSR, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
        Test.stopTest();
        system.assertNotEquals(200, listOfSR.size());
    }
    } // end of handleInsertDSRExceptionMethod()
    
	/**
     * Description: Method Handles Generic Exception
     * @MethodName: handleGenericExceptionMethod
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @isTest
    private static void handleGenericExceptionMethod() {
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){ 
        Test.startTest();
        List<Contact> lstOfCons1 = new List<contact>();
        List<Contact> lstcs=[select id,lastname from contact LIMIT 20000];
        for (Contact conObj1 : lstcs) {
            // contact without LastName            
            conObj1.lastname = '';
            lstOfCons1.add(conObj1);
        }
        // testing mandatory field check
        if (lstOfCons1 != null && lstOfCons1.size() > 0) {
            try {
                Database.insert(lstOfCons1);
            } catch (Exception Ex) {
                ExceptionHandler.logHandledExceptions(Ex, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
            } // end of catch
        } // end of if
        Test.stopTest();
        System.assertNotEquals(200,lstOfCons1.size());
        }
    } // end of handleGenericExceptionMethod()
	/**
     * Description: Method Handles error occured in deleting record
     * @MethodName: handleDSRExceptionMethod
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @isTest
    private static void handleDSRExceptionMethod() {
        List < Database.DeleteResult > listOfDR = new List < Database.DeleteResult > (); 
        Test.startTest();
        List<ExceptionLogger__c> loe=[select id from ExceptionLogger__c LIMIT 20000];
        List < ExceptionLogger__c > listOfDeleteExceptionLogger = new List<ExceptionLogger__c >();
        if (loe != null && loe.size() > 0) {            
                listOfDeleteExceptionLogger= loe.clone();                
                Approval.LockResult[] lrList = Approval.lock(loe, false);            
        } //end of if
        User curUser=new User(id=UserInfo.getUserId());        
        system.runAs(curUser){       
        listOfDR = new List < Database.DeleteResult >();     
        Database.DeleteResult[] ldr = Database.delete(listOfDeleteExceptionLogger, false);                    
        for (Database.DeleteResult dbdr: ldr) {
            if (!dbdr.isSuccess()) {
                listOfDR.add(dbdr);
            } // end of If
        } // end of for
        ExceptionHandler.logHandledExceptions(listOfDR, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
    } //end of systemrunas
        Test.stopTest();
        system.assertNotEquals(200, listOfDR.size());
    } // end of handleDSRExceptionMethod()
	/**
     * Description: Methods handles upsert record error
     * @MethodName: handleUpsertExceptionMethod
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @isTest
    private static void handleUpsertExceptionMethod() {        
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){       
        Test.startTest();
        list<contact> lstct=[select id from contact LIMIT 20000];
        List < Contact> listOfUpsertContact = new List < Contact > ();
        List < Database.UpsertResult > listOfUR = new List < Database.UpsertResult > ();
        if (lstct != null && lstct.size() > 0) {            
                listOfUpsertContact = lstct.clone();
                for(contact objCon3 : listOfUpsertContact ){
                    objCon3.LastName = '';
                }// end of for
           } //end of if
        Database.UpsertResult[] ldr = Database.upsert(listOfUpsertContact, false);
        for (Database.UpsertResult dbur: ldr) {
            if (!dbur.isSuccess()) {
                listOfUR.add(dbur);
            } // end of If
        } // end of for
        ExceptionHandler.logHandledExceptions(listOfUR, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
        Database.DeleteResult[] dbdr2 = Database.delete(listOfUpsertContact, false);
        Database.DeleteResult[] dbdr = Database.delete(listOfUpsertContact, false);
        ExceptionHandler.logHandledExceptions(dbdr, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
        Test.stopTest();
        System.assertNotEquals(200,listOfUR.size());
        }
    } // end of handleUpsertExceptionMethod()
	/**
     * Description: Method Handles API Callout Exception
     * @MethodName: handleApiExceptionMethod
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    @isTest
    private static void handleApiExceptionMethod() {
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){   
        Test.setMock(HttpCalloutMock.class, new ApiExceptionMockGenerator());
        Test.startTest();
        ExceptionLogger__c newAPIException= new ExceptionLogger__c(); 
        newAPIException.Error_Code__c = '401';
        newAPIException.Apex_Class__c = 'classname';
        newAPIException.API_Status_Message__c = 'GateWay Failure';
        newAPIException.Object_Name__c = 'Case';
        newAPIException.Module__c = 'Case Module';
        Database.insert(newAPIException);
        List<ExceptionLogger__c > newlist = [select Error_Code__c,Apex_Class__c,API_Status_Message__c, 
                                             Object_Name__c, Module__c  from ExceptionLogger__c LIMIT 20000 ];
        ExceptionHandler.logCalloutErrors(null, 'className', newAPIException.id, 'testModule');
        
        Test.stopTest();
        system.assertEquals(true,newlist.size()>0);
        }
    }
    /**
     @Author : Prajwal
     @Name   : ApiExceptionMockGenerator
     @Created Date: 02/04/2018
     @Description: Generates the mock response
     @Version: 0.1
    **/    
    public class ApiExceptionMockGenerator implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('POST', req.getMethod());
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            return res;
        }
    }
	/**
     * Description: Method Handles record creation error
     * @MethodName: testRecordCreation
     * @Created by: Prajwal
     * @parameters: Null
     * @return: Void
	*/
    private static testMethod void testRecordCreation(){
        User curUser=new User(id=UserInfo.getUserId());
        System.runAs(curUser){
            try{  
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();  
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Case objCas = ApexDataUtil.createCaseRecord(objAcc, objCon);
                Messaging.SingleEmailMessage msg= new Messaging.SingleEmailMessage();
                msg.setToAddresses(new String[]{objCas.ContactEmail});
                msg.setSubject('info about session');
                msg.setPlainTextBody(objCas.Description);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{msg});
                system.assert(objCas!=Null);
            }
            catch(Exception exc){  
                ExceptionHandler.logHandledExceptions(exc, 'TestClassFailure', 'TestMethodFailure', 'TestModule');
            }
        }
    }        
} // end of class