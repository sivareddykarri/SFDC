/** 
@Author :  Vazeer Mohammed
@Name   :  OpportunityTriggerHelperTest
@Created Date: 29/05/2019
@Description: To cover the Test scenarios on OpportunityTrigger.
@Version:0.1
@Reference: 
**/
@isTest
global class OpportunityTriggerHelperTest  implements HttpCalloutMock{    
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "operationsResponse" : { "status" : "success","errCode" : "N/A","errMessage" : "","oppNumber" : "OP-00000105"},"lineItemsResponse" : [ { "oppBrandLine" : "OB-00000180","legacyOppId" : "0063C000007yyQ1QAI","legacyPIPId" : "" }]}');
        res.setStatusCode(200);
        return res;
    }
    
    /**
    * Description: Test Data Creation
    * @MethodName: setup
    * @Created by: Vazeer Mohammed
    * @parameters:Null
    * @return:Void
    */
    @testSetup static void setup() {
        Account objAcc = ApexDataUtil.createGenRecTypeRecord('Influencer Account','Influencer');
        Opportunity objOpp = ApexDataUtil.createFranchiseSalesOppRecord(objAcc,'OppName', 'New', 'Not Applicable', 'Details');
        Product2 objProd1 = ApexDataUtil.createProdRec('Ramada','RA',true);
        Opportunity_Brand__c objObr1 =ApexDataUtil.createOppBrandRec(objOpp,objProd1,true,true,false,'Hotel');
        OpportunityTriggerHelper.oppWithAdminAccess oppWrap = new OpportunityTriggerHelper.oppWithAdminAccess();
        
        
        List<Wyndham_Constants_List__c> wynConList = new List<Wyndham_Constants_List__c>();
        wynConList.add(new Wyndham_Constants_List__c(Name='LegacySalesforceClientID',Value__c='xyz'));
        wynConList.add(new Wyndham_Constants_List__c(Name='LegacySalesforceClientSecret',Value__c='xyz'));
        wynConList.add(new Wyndham_Constants_List__c(Name='LegacyEndPoint',Value__c='xyz/services/apexrest/postOpportunity'));
        Database.insert(wynConList);
    }
    
    /**
    * Description: Method to cover all the scenarios on Opportunity Trigger Helper
    * @MethodName: minOnePrimaryBrand
    * @Created by: Vazeer Mohammed
    * @parameters:Null
    * @return:Void
    */
    private static testmethod void minOnePrimaryBrand(){
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Opportunity objOpp = [SELECT Id,StageName,Anticipated_Room_Count__c FROM Opportunity LIMIT 1];
                Test.startTest();
                Test.setMock(HttpCalloutMock.class, new OpportunityTriggerHelperTest());
                
                objOpp.StageName='Application';
                objOpp.Anticipated_Room_Count__c= 12;
                Database.update(objOpp);
                
                OpportunityTriggerHelper.getOppDetailsWithUserAccess(objOpp.Id);
                OpportunityTriggerHelper.sendToLegacy(objOpp.Id);
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'OpportunityTriggerHelperTest','minOnePrimaryBrand','Opportunity Management'); 
            }
        }
    }
}