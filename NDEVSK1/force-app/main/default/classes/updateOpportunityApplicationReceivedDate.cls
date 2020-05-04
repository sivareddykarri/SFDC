//@Update Opportunity Application Received Date call by Contract: Automated Process
//

public class updateOpportunityApplicationReceivedDate {
 
public class My1Exception extends Exception {}
 
 
    
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
    
    @InvocableMethod
    public static List<FlowOutputs>  updateOpportunity(List<FlowInputs> inputs)  {
        List<List<String>> contact_results = new List<List<String>>(); 
        List<FlowOutputs> results = new List<FlowOutputs>();
        FlowOutputs  result  = new FlowOutputs();
        
       
        result.strMessage='';
         result.isPASSED='';
        string ipId ='';
        try {  
            string ContractID =inputs[0].ContractID;
            date Application_Received_Date = inputs[0].Application_Received_Date;
            system.debug('### ContractID  = ' + ContractID + ', Application_Received_Date=' + Application_Received_Date);
          //  list<Account> accounts = new list<account>();
            if (Test.isRunningTest() && Application_Received_Date==null)
            {
                //
                throw new My1Exception('Test class to test error message');
                
            }
                
            opportunity_brand__c[] obs = [select id,Opportunity__c,contract__c from opportunity_brand__c where Primary__c=true and contract__c =: ContractID ];
          
             if (obs.size()>0 )
            {
            id opportunityID = obs[0].Opportunity__c;
            
            
            list<opportunity> opportunities = [SELECT id, Application_Received_Date__c 
                                               FROM opportunity WHERE id =:opportunityID] ;
            system.debug('### opportunities = ' + opportunities);
            
        
           
            for(opportunity oppt: opportunities)
            {
                
                
                oppt.Application_Received_Date__c=Application_Received_Date;
                
            }
            
           
            
            Database.SaveResult[] srList = Database.update(opportunities, false);
            system.debug('### srList =' + srList);
            // string errMsg='';
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated opportunity. opportunity: ' + sr.getId());
                    result.strMessage ='Success';
                    
                    
                   
                    
                }
                else {
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //errMsg = 'Create opportunity Error: ' + err.getMessage(); 
                        system.debug('###### result.strMessage ' + result.strMessage);
                        if (string.isBlank(result.strMessage))
                        { 
                            result.strMessage =  err.getMessage() + '. ' + ConstantsforLE.LEAccountCreationFail;
                        }
                        result.isPASSED='FAIL' ; 
                        
                        System.debug('Opportunity fields that affected this error: ' + err.getFields());
                        
                        
                        
                    }
                }
            }
          }
            
            
            
            
        } catch (exception ex)
        {
            
            ExceptionHandler.logHandledExceptions(ex,'updateOpportunityApplicationReceivedDate','logHandledExceptions','updateOpportunityApplicationReceivedDate'); 
            system.debug('### ex.getMessage() = ' + ex.getMessage());
            
            if (string.isBlank(result.strMessage))
            { 
                result.strMessage ='Error in update Opportunity Application ReceivedDate: ' + ex.getMessage();
            }
            
            result.isPASSED='FAIL' ; 
        }
        results.add(result); 
        system.debug('### results = ' + results);
        return results;
        
    }
    
 

}