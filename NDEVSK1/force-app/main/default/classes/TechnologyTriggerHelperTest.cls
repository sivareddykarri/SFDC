/* 
@Author: Prajwal
@Name: TechnologyTriggerHelperTest
@Created Date: 12/10/2018
@Description: To cover the Test scenarios on Technology.
@Version: 0.1
@reference:
**/
@isTest
private class TechnologyTriggerHelperTest { 
    /**
* Description:Test to cover restrictPSDRecordTest method. 
* @MethodName:restrictPSDRecordTest
* @Created by:Prajwal
* @parameters:Null
* @return:Void
*/
    private static testMethod void restrictPSDRecordTest(){
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Account objAcc = ApexDataUtil.createSiteRecTypeRecordExt('11112');
                Technology__c objpsd = ApexDataUtil.createTechnology(objAcc); 
                Technology__c objpsd1 = ApexDataUtil.createTechnology(objAcc);
            }
            catch(exception exc) {
                ExceptionHandler.logHandledExceptions(exc,'TechnologyTriggerHelperTest','restrictPSDRecordTest','Technology Management'); 
            }
        }
    }
}