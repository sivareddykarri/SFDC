/**
@Author :  Jim Zheng
@Name   :  batchApplicationReceivedDateUpdate_test
@Created Date: 3/2/2020
@Description: Test class for batchApplicationReceivedDateUpdate Class
@Version: 1.0
@Reference: 
**/

@isTest
public class batchApplicationReceivedDateUpdate_test{
    /**
* Description: Test Data Creation
* @MethodName: setup
* @Created by: Jim Zheng
* @parameters:Null
* @return:Void
*/
 @TestSetup
static void setup()
{
   user curUser = [SELECT Id FROM user WHERE Name='Informatica2'][0];
        
        System.runAs(curUser){
        
        List<Account> accounts = new List<Account>();
        List<Contract> contracts = new List<Contract>();
        
        ID siteRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        //ID entityRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
        accounts.add(new Account(name='AccountTEWT001' , billingcity='New York', billingcountry='USA',RecordTypeID=siteRecordTypeID));
        
        insert accounts; 
        system.debug('#### accounts = ' + accounts);  
        
        //id entityID= ApexDataUtil.createEntityRecTypeRecord().Id;
        
        for (Account account : [select id from account where name='AccountTEWT001']) {
            system.debug('#### account = ' + account);  
            //Entity__c = entityID,
            contracts.add(new contract( accountId=account.id,Current_Site_Indicator__c='Y', Status__c=7,  Sequence__c=1,Application_Received_Date__c=System.today()));
        }
        insert contracts;
        system.debug('#### contracts = ' + contracts);
        //User curUser=new User(Id=UserInfo.getUserId());
        //Create Admin user to skip validation rules
       // system.debug('#### $Setup.PB_Execution_Control__c.Skip_Opportunity_Brand_Process_Builder__c = ' + $Setup.PB_Execution_Control__c.Skip_Opportunity_Brand_Process_Builder__c);
        
      
            List<Opportunity> opportunitys = new List<Opportunity>();
            List<Opportunity_brand__c> obs = new List<Opportunity_brand__c>();  
            id fsRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Franchise Sales').getRecordTypeId();
            account acct=[select id from account where name='AccountTEWT001'][0];
            date dataARD = system.today()-15;
            for (Integer i=0;i<1;i++) {
                opportunitys.add(new Opportunity(accountid=acct.id,Anticipated_Room_Count__c =100,Response_on_Term_Sheet_Received__c='Yes', 
                                                 Application_Received_Date__c=dataARD,IsConverted__c =true,
                                                 name='OppName'+i,RecordTypeID=fsRecordTypeID,  
                                                 CloseDate = System.today()+7, StageName='Closed Won',Deal_Terms_Final__c='Yes', Best_Deal_Analysis_Performed__c
                                                 = 'Not Applicable', Best_Deal_Analysis_Details__c='Details'));
                
                
            }
            insert opportunitys;
            
             system.debug('#### opportunitys= ' + opportunitys);  
            
            Product2 objProd1 = ApexDataUtil.createProdRec('Ramada','RA',true);
            obs.add(new Opportunity_brand__c(Opportunity__c=opportunitys[0].id, Product__c=objProd1.id,Primary__c = true, Request_Opportunity__c=true, 
                                             Request_PIP__c=false,Tier_Facility_Type__c='Hotel',contract__c= contracts[0].id));
            
            insert obs;
            
            
            opportunity_brand__c[] obs1 = [select id,name, Primary__c,  Opportunity__c, Opportunity__r.name,Opportunity__r.stagename, Contract__c,
                                           contract__r.name, contract__r.Status__c,Opportunity__r.Application_Received_Date__c,contract__r.Application_Received_Date__c 
                                           from opportunity_brand__c   where Primary__c =true and Contract__c!=null ];
            system.debug('#### obs1= ' + obs1);  
            //Test.startTest();

    
        }
}
    
   
    static testmethod  void batchApplicationReceivedDateUpdateMethod() {
            SchedulableContext sContext = null;
        
            Test.startTest();
            // batchApplicationReceivedDateUpdate  x = new batchApplicationReceivedDateUpdate();
            // Id  batchJobId = Database.executeBatch(x);
             batchARDUpdateScheduler batchARDAlertSch  = new batchARDUpdateScheduler();
             batchARDAlertSch.execute(sContext);
            
           
            Test.stopTest();
             opportunity_brand__c[] obs2 = [select id,name, Primary__c,  Opportunity__c, Opportunity__r.name,Opportunity__r.stagename, Contract__c,
                                           contract__r.name, contract__r.Status__c,Opportunity__r.Application_Received_Date__c,contract__r.Application_Received_Date__c 
                                           from opportunity_brand__c  ];
            system.debug('#### obs2= ' + obs2);  
            
            
 
         
    }
    
    
}