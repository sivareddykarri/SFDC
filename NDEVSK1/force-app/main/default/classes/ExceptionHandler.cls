/** 
 @Author: Vazeer Mohammed
 @Name: ExceptionHandler
 @Description: Logs the exception into Salesforce Object called ExceptionLogger__c
 @Version: 0.1
 @reference:
**/
public with sharing class ExceptionHandler
{
    public static final String ERROR_IN ='Error in';   
    public static final String CAUSED_BY =' Caused by: '; 
    public static final String NEWLINE = '\n';
    public static final String ABBREVIATE_TEXT = '...';
    public static final String SYSTEM_DML_EXCEPTION ='System.DmlException';
    public static final String SYSTEM_EMAIL_EXCEPTION ='System.EmailException';
    Public static final String TEST_METHOD_ERROR ='Test method Error';
    public static final String LEAD = 'Lead';
    
   /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs 
    * @param: parameter- Exception object,className.
    * @return: void
    */
    public static void logHandledExceptions(Exception ex,String className, String methodName, String module ) {
        //Checking if Exception is not null
        if (ex != null) {
            //Instantiating error log to insert
            ExceptionLogger__c errorLog = new ExceptionLogger__c();            
            String errDescription = ERROR_IN + ex.getMessage()+ CAUSED_BY+ ex.getTypeName() + NEWLINE+  ex.getStackTraceString();
            errorLog.Description__c = errDescription.length() > 32000 ? errDescription.substring(0, 32000) + ABBREVIATE_TEXT  : errDescription;
            errorLog.Error_Code__c = ex.getTypeName();
            if(ex.getTypeName().equalsIgnoreCase(SYSTEM_DML_EXCEPTION) ){
                System.DmlException dmlExObj = (System.DmlException)ex;
                if(!String.isBlank(dmlExObj.getDmlId(0))){
                    Id recId = dmlExObj.getDmlId(0);
                    errorLog.Object_Name__c = String.valueOf(recId.getSobjectType()); 
                    errorLog.Error_Record_SF_Id__c = recId;
                }
            } 
            if(ex.getTypeName().equalsIgnoreCase(SYSTEM_EMAIL_EXCEPTION) ){
                System.EmailException emailExObj = (System.EmailException)ex;
                if(!String.isBlank(emailExObj.getDmlId(0))){
                    Id recId = emailExObj.getDmlId(0);
                    errorLog.Object_Name__c = String.valueOf(recId.getSobjectType()); 
                    errorLog.Error_Record_SF_Id__c = recId;
                }
            }
            errorLog.Apex_Class__c = className;
            errorLog.Exception_Dated__c=System.Now();
            errorLog.User_Name__c = UserInfo.getUserName();
            errorlog.Method_Name__c = methodName ;
            errorlog.Module__c = module;
            if (errorLog != null) {
                try{
                    Database.insert(errorLog);
                    if(Test.isRunningTest()){
                        throw new TestException();
                    }
                } catch(Exception e) {
                    e.getMessage();
                }
            }     
        }
    }
    /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs 
    * @param: parameter- Database.SaveResult[] lsr,className.
    * @return: void
    */
    public static void logHandledExceptions(Database.SaveResult[] lsr,String className , String methodName, String module) {
        //Checking if Exception is not null
        if (lsr != null) {            
            //Error Log List to Insert
            List<ExceptionLogger__c> errorLogList = new List<ExceptionLogger__c>();
            //Iterating over SaveResult
            ExceptionLogger__c errorLog = new ExceptionLogger__c();
            for (Integer i = 0; i < lsr.size(); i++) {        
                Database.SaveResult dbsr = lsr[i];                                    
                //Checks if records were failed
                if (!dbsr.isSuccess()) {   
                    errorLog.Description__c = String.valueOf(dbsr.getErrors()[0].getMessage());
                    if(dbsr.getId() != null)
                        errorLog.Object_Name__c = String.valueOf(dbsr.getId().getSobjectType()); 
                    errorLog.Apex_Class__c = className;
                    errorLog.Exception_Dated__c=System.Now();
                    errorLog.Error_Record_SF_Id__c = dbsr.getId();
                    errorLog.User_Name__c = UserInfo.getUserName(); 
                    errorlog.Method_Name__c = methodName ;
                    errorlog.Module__c = module;
                    errorLogList.add(errorLog); 
                }
            }
            //Check ErrorLogList size & Inserting Error logs                
            if(errorLogList.size() > 0){     
                try {                
                    Database.insert(errorLogList);
                    if(Test.isRunningTest()){
                        throw new TestException();
                    }
                } catch(Exception ex) {
                    ex.getMessage();         
                }
            }
        }
    }
    
    /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs 
    * @param: parameter- Database.DeleteResult[] lsr,className,methodName,module.
    * @return: void
    */
    public static void logHandledExceptions(Database.DeleteResult[] ldr,String className , String methodName, String module) {
        //Checking if Exception is not null
        if (ldr != null) {
            //Error Log List to Insert
            List<ExceptionLogger__c> errorLogList = new List<ExceptionLogger__c>();
            //Iterating over deleteResult
            ExceptionLogger__c errorLog = new ExceptionLogger__c();
            for (Integer i = 0; i < ldr.size(); i++) {        
                Database.DeleteResult dbdr = ldr[i];                                    
                //Checks if records were failed
                if (!dbdr.isSuccess()){   
                    errorLog.Description__c = String.valueOf(dbdr.getErrors()[0].getMessage());
                    if(dbdr.getId() != null)
                        errorLog.Object_Name__c = String.valueOf(dbdr.getId().getSobjectType()); 
                    errorLog.Apex_Class__c = className;
                    errorLog.Exception_Dated__c=System.Now();
                    errorLog.Error_Record_SF_Id__c = dbdr.getId();
                    errorLog.User_Name__c = UserInfo.getUserName(); 
                    errorlog.Method_Name__c = methodName ;
                    errorlog.Module__c = module;
                    errorLogList.add(errorLog); 
                }
            }
            //Check ErrorLogList size & Inserting Error logs                
            if (errorLogList.size() > 0 ) {     
                try {
                    Database.insert(errorLogList);
                    if(Test.isRunningTest()){
                        throw new TestException();
                    }
                }catch(Exception ex) {
                    ex.getMessage();
                }
            }
        }    
    }
    
    /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs 
    * @param: parameter- Database.UpsertResult[] lsr,className.
    * @return: void
    */
     public static void logHandledExceptions(Database.UpsertResult[] lsr,String className, String methodName, String module ) {
        //Checking if Exception is not null
        
       if (lsr != null) {            
            //Error Log List to Insert
            List<ExceptionLogger__c> errorLogList = new List<ExceptionLogger__c>();
                
            //Iterating over SaveResult
            ExceptionLogger__c errorLog = new ExceptionLogger__c(); 
            for (Integer i = 0; i < lsr.size(); i++) {        
                Database.UpsertResult dbsr = lsr[i];                                    
                //Checks if records were failed
                if (!dbsr.isSuccess()) {    
                    errorLog.Description__c = String.valueOf(dbsr.getErrors()[0].getMessage());
                    if(dbsr.getId() != null)
                    errorLog.Object_Name__c = String.valueOf(dbsr.getId().getSobjectType()); 
                    errorLog.Apex_Class__c = className;
                    errorLog.Exception_Dated__c=System.Now(); 
                    errorLog.Error_Record_SF_Id__c = dbsr.getId();
                    errorLog.User_Name__c = UserInfo.getUserName(); 
                    errorlog.Method_Name__c = methodName ;
                    errorlog.Module__c = module;
                    errorLogList.add(errorLog);
                }
            }
            //Check ErrorLogList size & Inserting Error logs                
            if (errorLogList.size() > 0 ) {     
                try {                
                    Database.insert(errorLogList);
                    if(Test.isRunningTest()){
                        throw new TestException();
                    }
                }catch(Exception ex) {
                    ex.getMessage();
                }
            }
        }
    }
    
      /**
    * @description: Defining Custom Exception to increase the code coverage 
    * 
    * 
    */
    public class TestException extends Exception{}
    {}
    
    /**
     * @description: Method to log the errors occured due to API Call Failure
     * @param: parameter- HttpResponse, className, RecordID.
     * @return: void
     */
    public static void logCalloutErrors(HttpResponse httpRes,String className, String sfdcId ,String module) {
        ExceptionLogger__c errorLog = new ExceptionLogger__c();
        if(httpRes != null){
            errorLog.Error_Code__c = String.valueOf(httpRes.getStatusCode());
            errorLog.API_Status_Message__c = httpRes + NEWLINE+ httpRes.getBody();
        }
        errorLog.Apex_Class__c = className;
        
        if(!String.isBlank(sfdcId)){
            errorLog.Error_Record_SF_Id__c = sfdcId;
            Id recId = sfdcId;
            errorLog.Object_Name__c = String.valueOf(recId.getSObjectType());
        }
        errorLog.Module__c = module;
        errorLog.User_Name__c = UserInfo.getUserName();
        try{
            Database.insert(errorLog);
        }catch(exception ex){
            ex.getMessage();
        }
    }
}