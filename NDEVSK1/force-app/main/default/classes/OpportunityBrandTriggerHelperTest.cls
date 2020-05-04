/** 
@Author :  Vazeer Mohammed
@Name   :  OpportunityBrandTriggerHelperTest
@Created Date: 10/05/2019
@Description: To cover the Test scenarios on Opportunity.
@Version:0.1
@Reference: 
**/
@isTest
private class OpportunityBrandTriggerHelperTest {
    /**
    * Description: Test Data Creation
    * @MethodName:setup
    * @Updated by: Vazeer Mohammed
    * @parameters:Null
    * @return:Void
    */
    @testSetup static void setup() {        
        Account objAcc = ApexDataUtil.createGenRecTypeRecord('Influencer Account','Influencer');
        Opportunity objOpp = ApexDataUtil.createFranchiseSalesOppRecord(objAcc,'OppName', 'New', 'Not Applicable', 'Details');
        Product2 objProdRA = ApexDataUtil.createProdRec('Ramada','RA',true);
        Product2 objProdAA = ApexDataUtil.createProdRec('AmericInn','AA',true);
        Opportunity_Brand__c objObr =ApexDataUtil.createOppBrandRec(objOpp,objProdRA,true,true,false,'Hotel');
    }
    /**
    * Description: to Cover the Dup brand EXists Method
    * @MethodName: displayErrorOnDupBrand
    * @Updated by: Vazeer Mohammed
    * @parameters:Null
    * @return:Void
    */
    private static testmethod void displayErrorOnDupBrand(){        
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Opportunity objOpp = [SELECT Id,StageName,Anticipated_Room_Count__c FROM Opportunity LIMIT 1];
                Opportunity_Brand__c objObr = [Select Id, Opportunity__c,Product__c,Primary__c from Opportunity_Brand__c LIMIT 1];
                Product2 objProdRA =[Select Id,productCode from Product2 Where productCode='RA'];
                Product2 objProdAA =[Select Id,productCode from Product2 Where productCode='AA'];
                
                Test.startTest();
                
                objObr.Product__c = objProdAA.Id;
                objObr.Primary__c =false;
                Database.update(objObr);
                
                Opportunity_Brand__c objObr2 =ApexDataUtil.createOppBrandRec(objOpp,objProdRA,true,false,false,'Garden');
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'OpportunityTriggerHelperTest','displayErrorOnDupBrand','Opportunity Management'); 
            }
        }
    }
    /**
    * Description: This method will covers removePrimaryOnOtherOppBrands and atleastOnePrimaryOpportunityBrand methods
    * @MethodName: removePrimary
    * @Updated by: Vazeer Mohammed
    * @parameters:Null
    * @return:Void
    */
    private static testmethod void removePrimary(){        
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Opportunity objOpp = [SELECT Id,StageName,Anticipated_Room_Count__c FROM Opportunity LIMIT 1];
                Product2 objProdAA =[Select Id,productCode from Product2 Where productCode='AA'];                
                Test.startTest();                
                Opportunity_Brand__c objObr2 =ApexDataUtil.createOppBrandRec(objOpp,objProdAA,true,false,false,'Garden');                
                Database.delete(objObr2);
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'OpportunityTriggerHelperTest','removePrimary','Opportunity Management'); 
            }
        }
    }
}