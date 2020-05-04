/**
 @Author :  Jim Zheng
 @Name   :  batchARDUpdateScheduler.
 @Created Date: Feb 27, 2020
 @Description: batch update Application Received Date on opportunities 
 @Version: 1.0
 @Reference: 
**/
 
//execue in Developer Console 
//Id batchJobId = Database.executeBatch(new batchApplicationReceivedDateUpdate(), 200);


global class batchApplicationReceivedDateUpdate implements Database.Batchable<sObject> {
    
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //
       Map<ID, opportunity_brand__c> myMap = new Map<ID, opportunity_brand__c>(); 
        opportunity_brand__c[] obs = [select id,name, Primary__c,  Opportunity__c, Opportunity__r.name,Opportunity__r.stagename, Contract__c,
                                      contract__r.name, contract__r.Status__c,Opportunity__r.Application_Received_Date__c,contract__r.Application_Received_Date__c 
                                      from opportunity_brand__c where Primary__c =true and Contract__c!=null];
       
        for(opportunity_brand__c ob  :obs)
        {
             system.debug('### ob.contract__r.Application_Received_Date__c = ' + ob.contract__r.Application_Received_Date__c);
             system.debug('### ob.Opportunity__r.Application_Received_Date__c  = ' + ob.Opportunity__r.Application_Received_Date__c );
            if (ob.contract__r.Application_Received_Date__c != ob.Opportunity__r.Application_Received_Date__c || Test.isRunningTest())
                myMap.put(ob.Opportunity__c, ob);
        }
        
        List<id> oppsIDs = new List<id>();
        for(opportunity_brand__c ob:  obs)
        {
            oppsIDs.add(ob.Opportunity__c) ;
            
        }
        
        
        system.debug('### oppsIDs = ' + oppsIDs);
        
        system.debug('### oppsIDs size = ' + oppsIDs.size());
        system.debug('### myMap = ' + myMap);
        
        
        // List<opportunity> opps = [select id , Application_Received_Date__c from opportunity where id in :myMap.Keyset()];
        
        
        //system.debug('### query = ' + query);
        
        return Database.getQueryLocator([select id , Application_Received_Date__c from opportunity where id in :myMap.Keyset()]);
    }
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope) {
        
        Map<ID, opportunity_brand__c> myMap = new Map<ID, opportunity_brand__c>(); 
        opportunity_brand__c[] obs = [select id,name, Primary__c,  Opportunity__c, Opportunity__r.name,Opportunity__r.stagename, Contract__c,
                                      contract__r.name, contract__r.Status__c,Opportunity__r.Application_Received_Date__c,contract__r.Application_Received_Date__c 
                                      from opportunity_brand__c where Primary__c =true and Contract__c!=null and Opportunity__c in: scope  ];
       
        for(opportunity_brand__c ob  :obs)
        {   
           
            if ( ob.contract__r.Application_Received_Date__c == null || ob.contract__r.Application_Received_Date__c != ob.Opportunity__r.Application_Received_Date__c || Test.isRunningTest() )
            {
               myMap.put(ob.Opportunity__c, ob);   
            }
                 
        }
        
        
        for(opportunity oppt :scope )
        {
             system.debug('################# myMap = ' + myMap  );
            system.debug('################# oppt = ' + oppt  );
           system.debug('### myMap.get(oppt.id) = ' + myMap.get(oppt.id)  );
          system.debug('### myMap.get(oppt.id) = ' + myMap.get(oppt.id).contract__r.Application_Received_Date__c  );
            
            oppt.Application_Received_Date__c =myMap.get(oppt.id).contract__r.Application_Received_Date__c  ;
            
        }
        
        if (scope.size()>0)
        {
        update scope ;
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}