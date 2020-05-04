/* 
 @Author: Prathyusha
 @Name: CaseTriggerHelperTest
 @Created Date: 2/2/2018
 @Description: To cover the Test scenarios on Case.
 @Version: 0.1
 @reference:
**/
@isTest
private class CaseTriggerHelperTest { 
    /**
    * Description:Displays Error on Parent case when trying to close the case with out the closing the related child case used for request 034
    * @MethodName:auraCaseMethodsTest
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void auraCaseMethodsTest(){
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{ 
                List<Case> childList=new List<Case>();
                Map<Id,Case> casOldMap;
                String recordTypeLabel='Escalation';
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                Photo_shoot__c objPhsht = ApexDataUtil.createPhotoShootRecord();
                
                Case objCase = new Case(status='New',Subject='11112 test',Priority='High',Origin='Email',SuppliedEmail='p3n@gmail.com',AccountId=objacc.Id,ContactId=objCon.Id,Case_Type__c = 'Finance',Case_Sub_Type__c= 'Financial Performance PPR',Case_Subject__c= 'PPR Report',MyRequest_ID__c='12345');
                Database.insert(objCase);
                                
                Case chdCase=new Case(parentId=objCase.Id,status='New',Priority='High',Origin='Chat',AccountId=objAcc.Id,ContactId=objCon.Id,Case_Type__c = 'Finance',Case_Sub_Type__c= 'Financial Performance PPR',Case_Subject__c= 'PPR Report');
                Database.insert(chdCase);
                childList.add(chdCase);
                casOldMap=new Map<Id,Case>([select Id,Status,CaseNumber FROM Case WHERE Id=:chdCase.Id]);
                
                CaseTriggerHelper.getCasesWithLimit(objAcc.Id,'6');
                CaseTriggerHelper.getCasesWithLimit(objPhsht.Id, '6');
                CaseTriggerHelper.getRecTypeId(recordTypeLabel);
                CaseTriggerHelper.fetchRecordTypeValues();
                CaseTriggerHelper.setFlagTrue();
                CaseTriggerHelper.getSobjectName(objAcc.Id);
                
                Test.startTest();
                chdCase.Status='Closed';
                chdCase.Resolution__c='Test';
                Database.update(chdCase);
                CaseTriggerHelper.sendPushNotificationtoCaseOwnerWhenClosed(childList, casOldMap);
        		Test.stopTest();
            }
            catch(Exception exc){
                Boolean expectedExceptionThrown = exc.getMessage().contains('Parent Case cannot be closed') ? true : false;
            }
        }
    }
    
    /**
    * Description:covers display error with parent case, update SLA on field methods
    * @MethodName:caseExceptions
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Void
    **/
    private static testMethod void caseExceptions(){
        User curUser=new user(Id=UserInfo.getUserId());
        try{
            Map<Id,Case> casOldMap;
            List<Case> cwList=new List<Case>();
            List<Case> csList=new List<Case>();
            List<Wyndham_SLA_Custom_Settings__c> slaList = new List<Wyndham_SLA_Custom_Settings__c>();
            String csRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Request').getRecordTypeId();
            
            Account objAcc = ApexDataUtil.createSiteRecTypeRecordExt('11112');
            Contact objCon = ApexDataUtil.createContactRecusingParams(objAcc,'testhello','helloworld','7878787879','contest@gmail.com');
            Case objCase = new Case(recordTypeID=csRecordTypeID,status='New',Subject='11112 test',Priority='High',Origin='Email',SuppliedEmail='test45@gmail.com',AccountId=objacc.Id,ContactId=objCon.Id,Case_Type__c = 'Finance',Case_Sub_Type__c= 'Financial Performance PPR',Case_Subject__c= 'PPR Report',MyRequest_ID__c='12345');
            cwList.add(objCase);
            Database.insert(objCase);
            
            Case childCase=new Case(recordTypeID=csRecordTypeID,parentId=objCase.Id,status='New',Priority='High',Origin='Chat',AccountId=objacc.Id,ContactId=objCon.Id,Case_Type__c = 'Finance',Case_Sub_Type__c= 'Financial Performance PPR',Case_Subject__c= 'PPR Report');
            Database.insert(childCase);
            casOldMap = new Map<Id,Case>([SELECT Id,Status,CaseNumber FROM Case WHERE Id=:childCase.Id]);
            
            Wyndham_SLA_Custom_Settings__c wynslacs =new Wyndham_SLA_Custom_Settings__c(Case_Record_Type__c='General Request',Case_Sub_Type__c='Financial Performance PPR',Case_Subject__c='PPR Report',Case_Type__c='Finance',Name='testsla',MyRequest_Team__c=true,Total_SLA__c='24');
            slaList.add(wynslacs);
            
            Wyndham_SLA_Custom_Settings__c wynslacs1 =new Wyndham_SLA_Custom_Settings__c(Case_Record_Type__c='Distribution',Case_Sub_Type__c='OTA',Case_Subject__c='OTA Blackout',Case_Type__c='Rates / OTA / Inventory / Content / GDS',Name='testsla12',Total_SLA__c='48');
            slaList.add(wynslacs1);
            Database.insert(slaList);
            
            objCase.Status='Aborted';
            csList.add(objCase);
            Database.update(csList);
            
            CaseTriggerHelper.updateSLAFieldOnCase(cwList);
            CaseTriggerHelper.updateAccount(cwList);
            CaseTriggerHelper.displayErrorOnParentCase(cwList);
            CaseTriggerHelper.updateChildRecordsToAbortedWhenParentAborted(csList);
        }
        catch(Exception exc){
            Boolean expectedExceptionThrown = exc.getMessage().contains('parent') ? true : false;
            system.debug('Boolean expectedExceptionThrown'+expectedExceptionThrown);
        } 
    } 
    
    /**
    * Description:covers updateContactOnCase method for Integration Informatica user
    * @MethodName:caseInformatica
    * @Created by:Narsimhulu
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void caseInformatica(){
        Profile objProfile = [Select Id, Name from Profile where Name ='Integration - Informatica' limit 1];
        User curUser = new User(Alias = 'standt', Email='standarduser@testorg.com', LastName='Testing', ProfileId = objProfile.Id, UserName='standarduser23@testorg.com', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US'); 
        System.runAs(curUser){
            try{  
                Account objAcc=ApexDataUtil.createSiteRecTypeRecordExt('11113');
                Contact objCon=ApexDataUtil.createContactRecusingParams(objAcc,'FIS','User','7878787879','contest@gmail.com');
                case cs=new Case(status='New',Priority='High',Origin='Chat',AccountId=objacc.Id,Case_Type__c = 'Internal Requests',Case_Sub_Type__c= 'Status Change');
                Database.insert(cs);
            }
            catch(Exception exc){       
            }
        }
    }
}