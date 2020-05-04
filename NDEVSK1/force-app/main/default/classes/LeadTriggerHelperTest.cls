/* 
@Author: Narsimhulu
@Name: LeadTriggerHelperTest
@Created Date: 4/30/2019
@Description: To cover the Test scenarios on Lead.
@Version: 0.5
@reference:
**/
@isTest
private class LeadTriggerHelperTest { 
    /**
    * Description:Displays Error on Lead when trying to convert Lead as Account and Contact if Lead Influencer checkbox checked and Account Record Type is not Influencer.
    * @MethodName:leadDisplayErrorInflencerAcc
    * @Created by:Narsimhulu
    * @Updated by: Prajwal
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void leadDisplayErrorInflencerAcc(){
        User curUser=new user(Id=UserInfo.getUserId());
        System.runAs(curUser){
            Account objAcc = ApexDataUtil.createGenRecTypeRecord('Influencer Account','Influencer');
            Contact objCon = ApexDataUtil.createContactRecord(objAcc);
            Test.setCreatedDate(objAcc.Id, System.now().addminutes(-2));
            Test.setCreatedDate(objCon.Id, System.now().addminutes(-2));
            Lead objLead = ApexDataUtil.createFranchiseSalesLeadRecord('John','Doe','Domain Corp','email@domain.com','United States','BU');
            Product2 objProd = ApexDataUtil.createProdRec('Baymont', 'BU', true);
            try{
                Test.startTest();
                objLead.Status = 'Ready for Conversion';
                Database.update(ObjLead);
                
                Database.LeadConvert leadconv = new database.LeadConvert();
                leadconv.setLeadId(objlead.Id);
                leadconv.setAccountId(objAcc.Id);
                leadconv.setContactId(objCon.Id);
                leadconv.setDoNotCreateOpportunity(false);
                leadconv.setConvertedStatus('Converted');
                Database.LeadConvertResult leadconvres = Database.convertLead(leadconv);
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LeadTriggerHelperTest','leadDisplayErrorInflencerAcc','Lead Management'); 
            }
        }
    }
}