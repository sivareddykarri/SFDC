//@Test Class for updateOpportunityApplicationReceivedDate
@isTest
public class updateOpportunityARD_test {
    @testSetup static void setup() {        
        Account objAcc = ApexDataUtil.createGenRecTypeRecord('Influencer Account','Influencer');
        Opportunity objOpp = ApexDataUtil.createFranchiseSalesOppRecord(objAcc,'OppName', 'New', 'Not Applicable', 'Details');
        Product2 objProdRA = ApexDataUtil.createProdRec('Ramada','RA',true);
        Product2 objProdAA = ApexDataUtil.createProdRec('AmericInn','AA',true);
        Opportunity_Brand__c objObr =ApexDataUtil.createOppBrandRec(objOpp,objProdRA,true,true,false,'Hotel');
    } 
    //input details that comes to apex from flow
    public class FlowInputs{
        
        @InvocableVariable
        public string ContractID;
        
        @InvocableVariable
        public date Application_Received_Date;
        
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutputs{
        
        
        @InvocableVariable 
        public String strMessage; //  
        public String  isPASSED;
        
        
    }
    
    @isTest
    public static void testFlowApex()
    { 
        
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            try{
                Opportunity objOpp = [SELECT Id,StageName,Anticipated_Room_Count__c FROM Opportunity LIMIT 1];
                Opportunity_Brand__c objObr = [Select Id, Opportunity__c,Product__c,Primary__c from Opportunity_Brand__c LIMIT 1];
                Product2 objProdRA =[Select Id,productCode from Product2 Where productCode='RA'];
                Product2 objProdAA =[Select Id,productCode from Product2 Where productCode='AA'];
                updateOpportunityApplicationReceivedDate.FlowInputs argument;
                argument = new updateOpportunityApplicationReceivedDate.FlowInputs();
                argument.ContractID = null;
                argument.Application_Received_Date = date.today();
                
                Test.startTest();
                
                updateOpportunityApplicationReceivedDate.updateOpportunity(
                    new List<updateOpportunityApplicationReceivedDate.FlowInputs>{ argument }
                );
                
                  argument.Application_Received_Date = null;
                  updateOpportunityApplicationReceivedDate.updateOpportunity(
                    new List<updateOpportunityApplicationReceivedDate.FlowInputs>{ argument }
                );
                Test.stopTest();
                
                
                
                
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'OpportunityTriggerHelperTest','displayErrorOnDupBrand','Opportunity Management'); 
            }
        }
        
        
        
    } 
}