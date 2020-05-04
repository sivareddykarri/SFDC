/**
@Author :     Joognu Rao
@Name   :     WebToCaseHandler
@Created Date: 5/8/2018
@Description: To handle all actions on Web To Case form
@Version:0.0 
@Reference: 
**/
public without sharing class WebToCaseHandler{

     /**
    * Description: Getter Setter methods
    */
    public Case CaseToInsert { get; set; }
    public list<ContentVersion> attach { get; set;}
    public String Myportal{get; set;}
     public string url{get;set;}
   
    private Id DISTRIBUTION = Schema.SObjectType.case.getRecordTypeInfosByName().get(ConstantClass.DISTRIBUTIONRECORD).getRecordTypeId();                 
    private Id GENERAL = Schema.SObjectType.case.getRecordTypeInfosByName().get(ConstantClass.GENERALRECORD).getRecordTypeId();
    public List<Attachment> CaseAttachment{get;set;}
    public List<case>lstCaseContact = new List<case>();
    
     /**
    * Description:Constructor    
    */
    public WebToCaseHandler(){
        CaseToInsert = new case();               
       
        CaseAttachment = new List<Attachment>() ;
        
        //Adding values count list - you can change this according to your need
        for(Integer i = 1 ; i < 6 ; i++){
            CaseAttachment.add(new Attachment()) ;
        }
        //fetching My Portal id of the logged-in user
         ApexPages.currentPage().getParameters().put(ConstantClass.USERID, CaseToInsert.MyPortal_Id__c);
        
        //Get the list of content PDF to be downloaded from the form
        List <ContentWorkspaceDoc>lstContentDoc = [SELECT ContentDocumentId,ContentDocument.Id,ContentDocument.Title,ContentWorkspace.Name 
        FROM ContentWorkspaceDoc where ContentWorkspace.Name =: ConstantClass.WEBLIBRARY Limit 100];
       
        List<Id> lstDoc = new List<Id>();
        for(ContentWorkspaceDoc cw : lstContentDoc){
            lstDoc.add(cw.ContentDocumentId);
            
        }
       
        
        attach = [SELECT ContentDocumentId,Id,Title FROM ContentVersion where ContentDocumentId IN :lstDoc Limit 100];
         url= ApexPages.currentPage().getParameters().get('userid');

        
          }
    
     /**
    * Description: Custom Web to Case functional implementation.
    * @MethodName: webToCaseMethod
    * @Created by: Joognu Rao
    * @parameters: No
    * @return: Page reference
    */
    public PageReference webToCaseMethod(){
        try{
            if(CaseToInsert!=null){                       
                if(CaseToInsert.Request_Type__c== ConstantClass.CONTENT || CaseToInsert.Request_Type__c== ConstantClass.OTA || CaseToInsert.Request_Type__c== ConstantClass.SPECIALEVENTS){
                    
                    CaseToInsert.RecordTypeId = DISTRIBUTION;
                    CaseToInsert.Case_Type__c = ConstantClass.RATESOTAINVENTORY;  
                    CaseToInsert.Case_Sub_Type__c = CaseToInsert.Request_Type__c;
                    CaseToInsert.Case_Subject__c = CaseToInsert.Request_Type_detail__c;
                }
                else if(CaseToInsert.Request_Type__c== ConstantClass.RATEPLAN){
                   
                        CaseToInsert.RecordTypeId = DISTRIBUTION;
                        CaseToInsert.Case_Type__c = ConstantClass.RATESOTAINVENTORY;  
                        CaseToInsert.Case_Sub_Type__c = CaseToInsert.Request_Type__c;
                        CaseToInsert.Case_Subject__c = CaseToInsert.Request_Type_detail__c; 
                    
                    
                }
                else if(CaseToInsert.Request_Type__c== ConstantClass.ROOMTYPE){
                   
                        CaseToInsert.RecordTypeId = DISTRIBUTION;
                        CaseToInsert.Case_Type__c = ConstantClass.RATESOTAINVENTORY;  
                        CaseToInsert.Case_Sub_Type__c = ConstantClass.INVENTORY;
                        CaseToInsert.Case_Subject__c = CaseToInsert.Request_Type_detail__c; 
                    
                    
                }
                else if(CaseToInsert.Request_Type__c== ConstantClass.NATIONALREGION){
                    CaseToInsert.RecordTypeId = DISTRIBUTION;
                    CaseToInsert.Case_Type__c = ConstantClass.RATESOTAINVENTORY;
                    CaseToInsert.Case_Sub_Type__c =ConstantClass.RATEPLAN;
                    CaseToInsert.Case_Subject__c = ConstantClass.NATIONALREGION;
                }
                else if(CaseToInsert.Request_Type__c== ConstantClass.GENERALREQUEST){
                    CaseToInsert.RecordTypeId = GENERAL;
                    CaseToInsert.Case_Type__c = ConstantClass.HOWTO;     
                }
                CaseToInsert.origin = ConstantClass.ORIGINWEB;                                              
                CaseToInsert.MyPortal_Id__c = ApexPages.currentPage().getParameters().get(ConstantClass.USERID);
                
                //Fetch existing contact
                lstCaseContact.add(CaseToInsert);
                if(ContactManagement.genericMethodToFetchContact(lstCaseContact).size()!=0 && !(ContactManagement.genericMethodToFetchContact(lstCaseContact).isempty())){
                    CaseToInsert.contactId = ContactManagement.genericMethodToFetchContact(lstCaseContact)[0].id;
                }
               
                //Activate Assignment rules
                AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];                   
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox                   
                Database.DMLOptions dmlOpts = new Database.DMLOptions();                   
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;             
                //Setting the DMLOption on Case instance
                CaseToInsert.setOptions(dmlOpts);

                
                //Fetch Site details
                list<Account> lstAcc = new list<Account>();
                lstAcc = [SELECT Id,Name,EXT_Site_Id__c FROM Account WHERE EXT_Site_Id__c =:CaseToInsert.Account_Name__c LIMIT 1];
                if(lstAcc.size()==0 || lstAcc.Isempty()){                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ConstantClass.SITEERROR));
                    return null;
                }               
                else if(lstAcc.size()!=0 && !lstAcc.Isempty()){
                    CaseToInsert.accountid = lstAcc[0].id;                   
                    insert CaseToInsert;
                }  
                //inserting attachment
                List<Attachment> listToInsert = new List<Attachment>() ;
                integer sizecheck =0;
                for(Attachment a: CaseAttachment){
                    if(a.name != '' && a.name != '' && a.body != null){
                        sizecheck = sizecheck + (a.body.size());
                        listToInsert.add(new Attachment(parentId = CaseToInsert.id, name = a.name, body = a.body));
                }}
                Case InsertedCase = [select id, CaseNumber,Contact_First_Name__c,Contact_Phone__c,Contact_Last_Name__c,Contact_Email__c,AccountId,Request_Type__c,Request_Type_detail__c,Description from case where id=:CaseToInsert.id LIMIT 50000];      
                if(listToInsert.size() > 0){               
                     if(sizecheck > 10485760){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Oops!  Please read: We have received your request # '+ InsertedCase.CaseNumber+'; however, your attachments have exceeded the 10 MB size limit. Please send your attached files to us by replying to the email you receive with your request confirmation.')); 
                    }else{
                        insert listToInsert ;                
                    }
                }
                if(InsertedCase!=null){
                    ApexPages.message msg = new ApexPages.message(ApexPages.severity.CONFIRM,'Your request was submitted successfully! Here is your case number  '+ InsertedCase.CaseNumber);       
                    ApexPages.addmessage(msg);
                }
            }
        } Catch(exception ex){
            ex.getmessage();
        }finally {
            CaseToInsert = new case();
            CaseAttachment.clear();
            for(Integer i = 1 ; i < 6 ; i++){
            CaseAttachment.add(new Attachment()) ;
            }
        }
        return null;
    }
}