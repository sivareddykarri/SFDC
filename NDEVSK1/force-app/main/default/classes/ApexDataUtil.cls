/*** 
 @Author : Prathyusha
 @Name   : ApexDataUtil
 @Created Date: 28/3/2018
 @Description: This is used for Test Data Creation.
 @Version:0.2
***/
@isTest 
Public class ApexDataUtil{
    /**
     * Description:This method will return the Account Id of Record type Site
     * @MethodName:createSiteRecTypeRecord
     * @Created by:Prathyusha
     * @parameters:Null
     * @return:Account
     */
    public static Account createSiteRecTypeRecord() {
        Account objAcc=new Account();
        try{
            objAcc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            objAcc.Name = '00015';
            objAcc.EXT_Site_Id__c = '00015';
            objAcc.Phone = '23423452';
            objAcc.ShippingStreet = 'Yroads';
            objAcc.ShippingCity = 'hyd';
            objAcc.ShippingState = 'Kansas';
            objAcc.ShippingPostalCode = '99929';
            Database.insert(objAcc);
            System.assert(objAcc!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createSiteRecTypeRecord','Account Management'); 
        }
        return objAcc;
    }    
    
    /**
     * Description:This method will return the Account Id of Record type Site
     * @MethodName:createSiteRecTypeRecord2
     * @Created by:Prathyusha
     * @parameters:Null
     * @return:Account
     */
    public static Account createSiteRecTypeRecord2() {
        Account objAcc=new Account();
        try{
            objAcc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            objAcc.Name = '00023';
            objAcc.EXT_Site_Id__c = '00023';
            objAcc.Phone = '23423452';
            objAcc.ShippingStreet = 'Yroads';
            objAcc.ShippingCity = 'hyd';
            objAcc.ShippingState = 'Kansas';
            objAcc.ShippingPostalCode = '99929';
            
            Database.insert(objAcc);
            System.assert(objAcc!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createSiteRecTypeRecord','Account Management'); 
        }
        return objAcc;
    }  
    /**
    * Description:This method will return the Account Id of Record type Site
    * @MethodName:createSiteRecTypeRecordExt
    * @Created by:Prathyusha
    * @parameters:Name
    * @return:Account
    */
    public static Account createSiteRecTypeRecordExt(String Name) {
        Account objAcc=new Account();
        try{
            objAcc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
            objAcc.Name = '00015';
            objAcc.EXT_Site_Id__c = Name;
            objAcc.Phone = '23423452';
            objAcc.ShippingStreet = 'Yroads';
            objAcc.ShippingCity = 'hyd';
            objAcc.ShippingState = 'Kansas';
            objAcc.ShippingPostalCode = '99929';
            
            Database.insert(objAcc);
            System.assert(objAcc!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createSiteRecTypeRecord','Account Management'); 
        }
        return objAcc;
    }  
    
    /**
    * Description:This method will return the Account Id of Record type Site
    * @MethodName:createContactRecUsingParams
    * @Created by:Prathyusha
    * @parameters:Name
    * @return:Account
    */
    public static Contact createContactRecUsingParams(Account acc,String FirstName, String LastName, String Phone, String Email) {
        Contact objcon=new Contact();
        try{
            objCon.RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Site').getRecordTypeId() ;
            objCon.FirstName = FirstName;
            objCon.lastname = LastName;
            objCon.Phone = Phone;
            objCon.MobilePhone=Phone;
            objCon.HomePhone=Phone;
            objCon.Email =Email;
            objCon.AccountId=acc.Id;
            Database.insert(objCon);
            system.assert(objCon!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createSiteRecTypeRecord','Account Management'); 
        }
        return objCon;
    }    
   
    /**
    * Description:This method will return the Account Id of Record type Entity
    * @MethodName:createEntityRecTypeRecord
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Account
    */
    public static Account createEntityRecTypeRecord() {
        Account objAcc=new Account();
        try{
            objAcc.RecordTypeID =Schema.SObjectType.account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
            objAcc.Name = '12345';
            objAcc.EXT_Entity_Id__c = '12345';
            objAcc.Phone = '9989456002';
            objAcc.ShippingStreet = 'Xroads';
            objAcc.ShippingCity = 'hyd';
            objAcc.ShippingState = 'Kansas';
            objAcc.ShippingPostalCode = '99929'; 
            Database.insert(objAcc);
            system.assert(objAcc!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createEntityRecTypeRecord','Account Management'); 
        }
        return objAcc;
    }
    
    /**
    * Description:This method will return the Account Id of Record type Site
    * @MethodName:createContractRecord
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Account
    */
    public static Contract createContractRecord(Account acc,Integer seq) {
        Contract objCrt=new Contract();
        try{
            objCrt.AccountId = acc.Id;
            objCrt.Entity__c = ApexDataUtil.createEntityRecTypeRecord().Id;
            objCrt.Current_Site_Indicator__c = 'Y';
            objCrt.Status__c = 7;
            objCrt.Sequence__c = seq;
            Database.insert(objCrt);
            system.assert(objCrt!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createContractRecord','Contract Management'); 
        }
        return objCrt;
    }
    

    
    /**
    * Description:This method will return the Contact Id of Record type Key Contacts
    * @MethodName:createContactRecord
    * @Created by:Prathyusha
    * @parameters:Account
    * @return:Contact
    */
    public static Contact createContactRecord(Account acc) {
        Contact objCon=new Contact();
        try{
            objCon.RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Site').getRecordTypeId() ;
            objCon.FirstName = 'Test';
            objCon.lastname = 'Contact';
            objCon.Phone = '9989456002';
            objCon.MobilePhone='9989456002';
            objCon.HomePhone='9989456002';
            objCon.AccountId = acc.Id;
            objCon.Email ='ab@gmail.com';            
            objCon.Requires_Attention__c = true;
            objCon.Form_Submission_Date__c = System.today();
            Database.insert(objCon);
            system.assert(objCon!=NULL);
        }
        catch(exception ex){
           ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createContactRecord','Contact Management');
        }
        return objCon;
    }

    /**
    * Description:This method will return the Contact Id of Record type Key Contacts
    * @MethodName:createContactRecord1
    * @Created by:Prajwal
    * @parameters:Null
    * @return:Contact
    */
    public static Contact createContactRecord1() {
        Contact objCon1=new Contact();
        try{
            objCon1.RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Site').getRecordTypeId() ;
            objCon1.lastname = 'heloo';
            objCon1.FirstName = 'Test';
            objCon1.Phone = 'test123' ;
            objCon1.Email ='ab@gmail.com';
            Database.insert(objCon1);
            System.assert(objCon1!=NULL);
        }
        catch(exception ex){
           ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createContactRecord1','Contact Management');
        }
        return objCon1;
    }
    
    /**
    * Description:This method will return a contractContactRelationship
    * @MethodName:createContractContactRelationshipRecord
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Account
    */
    public static Contract_Contact_Relationship__c  createContractContactRelationshipRecord(Contract crt, Contact con,String roles,String status) {
        Contract_Contact_Relationship__c  objCrtConRel=new Contract_Contact_Relationship__c ();
        try{
            objCrtConRel.Contact__c = con.Id;
            objCrtConRel.Contract__c = crt.Id;
            objCrtConRel.Roles__c = roles;
            objCrtConRel.Status__c = status;
            objCrtConRel.Owner_Percentage__c=90;
            objCrtConRel.Processing_Status__c='New';
            Database.insert(objCrtConRel);
            system.assert(objCrtConRel!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createContractContactRelationshipRecord','ContractContactRelation Management'); 
        }
        return objCrtConRel;
    }
    
    /**
    * Description:This method will return a Technology record
    * @MethodName:createTechnology
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Technology__c
    */
    public static Technology__c  createTechnology(Account acc) {
        Technology__c  objTech=new Technology__c ();
        try{
            objTech.RecordTypeID = Schema.SObjectType.Technology__c.getRecordTypeInfosByName().get('Property Support Data').getRecordTypeId() ;
            objTech.Account_name__c=acc.id;
            objTech.Model_Number__c='9989555550';
            objTech.Serial_Number__c='9989555550';
            objTech.Product_Description__c='ChatRequest';
            Database.insert(objTech);
            System.assert(objTech!=Null);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createTechnologyRecord','Technology Management'); 
        }
        return objTech;
    }
    
    /**
    * Description:This method will return the Case of Record type General Requests
    * @MethodName:createCaseRecord
    * @Created by:Prathyusha
    * @parameters:Account,Contact
    * @return:Case
    */
    public static Case createCaseRecord(Account acc,Contact con) {
        String RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Request').getRecordTypeId() ;
        Case objCase=new Case();
        try{
            objCase.AccountId = acc.Id;
            objCase.ContactId = con.Id;
            objCase.Priority = 'High';
            objCase.Origin = 'Web';
            objCase.status = 'Open';
            objCase.Case_Type__c = 'Finance';
            objCase.Case_Sub_Type__c= 'Financial Performace PPR';
            objCase.Case_Subject__c= 'PPR Report';
            objCase.SLA__c= 24;
            objCase.RecordTypeId=RecordTypeID;
            database.insert(objCase);
            system.assert(objCase!=NULL);
        }
        catch(exception ex){
             ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createCaseRecord','Case Management');
        }
        return objCase;
    } 
    
    /**
    * Description:This method will return the Case of Record type General Requests
    * @MethodName:createCaseRecord
    * @Created by:Prajwal
    * @parameters:Account,Contact
    * @return:Case
    */
    public static Case createCaseRecord2(Account acc,Contact con,Id ownerId) {
        Case objCase=new Case();
        try{
            objCase.AccountId = acc.Id;
            objCase.ContactId = con.Id;
            objCase.Priority = 'High';
            objCase.Origin = 'Web';
            objCase.status = 'Open';
            objCase.Subject = '00015';
            objCase.SuppliedEmail = 'test@test.com';
            objCase.SLA__c = 0;
            objCase.OwnerId = ownerId;
            objCase.Adjusted_ETC__c=System.now().addDays(1);
            objCase.Reason_for_Adjustment__c = 'Test1';
            database.insert(objCase);
            system.assert(objCase!=Null);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createCaseRecord2','Case Management');
        }
        return objCase;
    } 
    
    /**
    * Description:This method will return the Case of Record type General Requests
    * @MethodName:createCaseRecord3
    * @Created by:Prajwal
    * @parameters:Account,Contact
    * @return:Case
    */
    public static Case createCaseRecord3(Account acc,Contact con) {
        Case objCase=new Case();
        try{
            objCase.AccountId = acc.Id;
            objCase.ContactId = con.Id;
            objCase.Priority = 'High';
            objCase.Origin = 'Email';
            objCase.status = 'Open';
            objCase.Subject = '00015test273263';
            objCase.SuppliedEmail = 'test@test.com';
            database.insert(objCase);
            system.assert(objCase!=Null);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createCaseRecord2','Case Management');
        }
        return objCase;
    }
    
    /**
    * Description:This method will create the Child Case
    * @MethodName:createChildCaseRecord
    * @Created by:Vazeer Mohammed
    * @parameters:Account,Contact,Case
    * @return:Case
    */
    public static Case createChildCaseRecord(Account acc,Contact con,Case cas) {
        String RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Request').getRecordTypeId() ;
        Case objCase=new Case();
        try{
            objCase.ParentId = cas.Id;
            objCase.AccountId = acc.Id;
            objCase.ContactId = con.Id;
            objCase.Priority = 'High';
            objCase.Origin = 'Phone';
            objCase.status = 'New';
            objCase.Case_Type__c = 'Finance';
            objCase.Case_Sub_Type__c= 'Financial Performace PPR';
            objCase.Case_Subject__c= 'PPR Report';
            objCase.RecordTypeId=RecordTypeID;
            database.insert(objCase);
            system.assert(objCase!=Null);
        }
        catch(exception ex){
             ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createChildCaseRecord','Case Management');
        }
        return objCase;
    }
    
    /** 
    * Description: This method is used to create Case Instance
    * @MethodName: createCaseInstance
    * @Created by: Vazeer Mohammed
    * @parameters: Account acc,Contact con,String accName,String reqType,String reqTypeDetail
    * @return:Case
    */
    public static Case createCaseInstance(Account acc,Contact con,String accName,String reqType,String reqTypeDetail){
        Case objCase = new Case();
        try{
            objCase.AccountId = acc.id;
            objCase.ContactId = con.id;
            objCase.Priority = 'High';
            objCase.Account_Name__c = accName;
            objCase.Origin = 'Web';
            objCase.status = 'Open';
            objCase.Request_Type__c = reqType;
            objCase.Case_Type__c = 'Rates / OTA / Inventory / Content / GDS';
            objCase.Case_Sub_Type__c = 'OTA';
            objCase.Request_Type_detail__c= reqTypeDetail;
            objCase.Case_Subject__c = 'Modify';
            objCase.Description = 'Description';
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createCaseInstance','case Management');
        }
        return objCase;
        
    }
    /** 
    * Description: This method is used to create Closed Case Instance
    * @MethodName: ClosedCaseInstance
    * @Created by: Vazeer Mohammed
    * @parameters: Account acc,Contact con,String accName,String reqType
    * @return:Case
    */
    public static Case ClosedCaseInstance (Account acc,Contact con,String reqType){
        Case objClosedCase = new Case();
        try{
            objClosedCase.AccountId = acc.id;
            objClosedCase.ContactId = con.id;
            objClosedCase.Priority = 'High';
            objClosedCase.Origin = 'Chat';
            objClosedCase.status = 'New';
            objClosedCase.Request_Type__c = reqType;
            objClosedCase.Case_Type__c = 'Rates / OTA / Inventory / Content / GDS';
            objClosedCase.Case_Sub_Type__c = 'OTA';
            objClosedCase.Case_Subject__c = 'Modify';
            objClosedCase.Description = 'Description';
            objClosedCase.Resolution__c = 'Resolution';
            database.insert(objClosedCase);
            objClosedCase.status = 'Closed';
            database.update(objClosedCase);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','ClosedCaseInstance','case Management');
        }
        return objClosedCase;
        
    }
    /**
    * Description:This method will Create the Photoshoot record and will return the id of Photoshoot
    * @MethodName:createPhotoShootRecord
    * @Created by:Prathyusha
    * @parameters:NULL
    * @return:Photo_shoot__c
    */
    public static Photo_shoot__c createPhotoShootRecord() {
        Photo_shoot__c objPS=new Photo_shoot__c();
        try{
            objPS.Onboarding_Fee_Amount_Paid__c = 10.0;
            objPS.Contact_First_Name__c= 'Test';
            database.insert(objPS);
            system.assert(objPS.Id!=Null);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createPhotoShootRecord','Photoweb Application');
        }
        return objPS;
    }
    
    /** 
     * Description:This method will return ExceptionLogger record
     * @MethodName:createExceptionLoggerRecords
     * @Created by:Prajwal
     * @parameters:Null
     * @return:ExceptionLogger__c
     */
    public static ExceptionLogger__c createExceptionLoggerRecord() {
        ExceptionLogger__c objExe = new ExceptionLogger__c();
        try{
            ObjExe.Apex_Class__c = 'ApexDataUtil';
            ObjExe.Module__c = 'Case Management';
            ObjExe.Object_Name__c = 'Case';
            ObjExe.Method_Name__c = 'testdata_ChildCase';
            ObjExe.Description__c = 'Test2';
            ObjExe.User_Name__c = 'abc@gmail.com';
            database.insert(objExe);
            system.assert(objExe.id!=Null);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createExceptionLoggerRecord','Exception Logs');
        }
        return objExe;
    }
    
    /** 
    * Description:This method will return multiple ExceptionLogger record
    * @MethodName:createMultipleExceptionLoggerRecords
    * @Created by:Prajwal
    * @parameters:Null
    * @return:ExceptionLogger__c
    */
    public static List<ExceptionLogger__c> createMultipleExceptionLoggerRecords() {
        List<ExceptionLogger__c> exceLogList = new List<ExceptionLogger__c>();
        ExceptionLogger__c objExe = new ExceptionLogger__c();
        try{
            for(Integer i=1;i<=200;i++){
                objExe=new ExceptionLogger__c(Apex_Class__c='ApexDataUtil'+string.valueof(i),Module__c='Case Management',Object_Name__c='Case',Method_Name__c='testdata_ChildCase',
                                              Description__c='Test2',User_Name__c='abcx@gmail.com');
                exceLogList.add(objExe);
            }
            Database.insert(exceLogList);
            system.assert(!exceLogList.isEmpty());
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createMultipleExceptionLoggerRecords','Exception Logs');
        }
        return exceLogList;
    }
	
     /**
     * Description:This method will return the Opportunity Id of Record type Franchise Sales
     * @MethodName:createFranchiseSalesLeadRecord
     * @Created by:Prajwal
     * @parameters:Null
     * @return:Lead
     */
    public static Lead createFranchiseSalesLeadRecord(String firstName, String lastName,String company, String email, String propCountry, String brands) {
        Lead objLead=new Lead();
        try{
            objLead.RecordTypeID = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Franchise Sales').getRecordTypeId();
            objLead.FirstName = firstName;
            objLead.LastName = lastName;
            objLead.Company = company;
            objLead.Email = email;
            objLead.Property_Country__c = propCountry;
            ObjLead.Brand_Fit_MQ__c = brands;
            objLead.Portfolio_Experience__c='Random Test';
            ObjLead.Brand_Fit_Comments__c = 'Random Test';
            ObjLead.Wherewithal_Comments__c = 'Random Test';
            ObjLead.Demonstrated_Interest_Comments__c = 'Random Test';
            ObjLead.Budget_Range_USD__c = '0 - 100k';
            ObjLead.Land_Control__c = 'Yes';
            ObjLead.Demonstrated_Interest__c = TRUE;
            ObjLead.LeadSource = 'Cold Call';
            ObjLead.Size_of_Portfolio__c = 'First-timer (0 hotels)';
            ObjLead.Chain_Scale__c = 'Upscale';
            ObjLead.Owner_Operator_of_Wyndham_Property__c = 'Yes';
            ObjLead.Timeframe__c = '7+ months';
            ObjLead.New_or_Existing_Property__c = 'Build_New_Property';
            ObjLead.Requires_Attention__c = true;
            ObjLead.Form_Submission_Date__c = System.today();
            Database.insert(objlead);
            System.assert(objlead!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createFranchiseSalesLeadRecord','Lead Management'); 
        }
        return objlead;
    }  
     /**
     * Description:This method will return Generic Account Id
     * @MethodName:createGenRecTypeRecord
     * @Created by:Prajwal
     * @parameters:Null
     * @return:Account
     */
    public static Account createGenRecTypeRecord(String name, String recName) {
        Account objAcc=new Account();
        try{
            objAcc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recName).getRecordTypeId();
            objAcc.Name = name;
            Database.insert(objAcc);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createGenRecTypeRecord','Account Management'); 
        }
        return objAcc;
    } 
     /**
     * Description:This method will return the Opportunity Id of Record type Franchise Sales
     * @MethodName:createFranchiseSalesOppRecord
     * @Created by:Prajwal
     * @parameters:Null
     * @return:Opportunity
     */
    public static Opportunity createFranchiseSalesOppRecord(Account acc, String name, String stage,String bestdealanalysis, String bestdealdetails) {
        Opportunity objOpp=new Opportunity();
        try{
            objOpp.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Franchise Sales').getRecordTypeId();
            objOpp.Name = name;
            objOpp.AccountId = acc.Id;
            objOpp.CloseDate = System.today()+7;
            objOpp.StageName = stage;
            objOpp.Best_Deal_Analysis_Performed__c=bestdealanalysis;
            objOpp.Best_Deal_Analysis_Details__c=bestdealdetails;
            Database.insert(objOpp);
            System.assert(objOpp!=NULL);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createFranchiseSalesOppRecord','Opportunity Management'); 
        }
        return objOpp;
    }
     /**
     * Description:This method will return Generic Product2 Id
     * @MethodName:createprodRec
     * @Created by:Prajwal
     * @parameters:Null
     * @return:Product2
     */
    public static Product2 createProdRec(String name, String code, Boolean active) {
        Product2 objProd=new Product2();
        try{
            objProd.Name = name;
            objProd.ProductCode=code;
            objProd.IsActive = active;
            Database.insert(objProd);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createProdRec','Product2 Management'); 
        }
        return objProd;
    } 
    /**
    * Description:This method will return Generic Opportuntiy Brand Id
    * @MethodName:createOppBrandRec
    * @Created by:Prajwal
    * @parameters:Null
    * @return:Product2
    */
    public static Opportunity_Brand__c createOppBrandRec(Opportunity opp,Product2 prod,boolean primary,boolean reqOpp,boolean reqPIP, String tierFacility) {
        Opportunity_Brand__c objObr=new Opportunity_Brand__c();
        try{
            objObr.Opportunity__c=opp.Id;            
            objObr.Product__c=prod.Id;
            objObr.Primary__c = primary;
            objObr.Request_Opportunity__c = reqOpp;
            objObr.Request_PIP__c = reqPIP;
            objObr.Tier_Facility_Type__c = tierFacility;	
            Database.insert(objObr);
        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createOppBrandRec','Opportunity Brand Management'); 
        }
        return objObr;
    }
    /**
    * Description: This method will return Chat Transcript Record
    * @MethodName: CreateliveChatTranscriptRecord
    * @Created by:Prajwal
    * @parameters: Null
    * @return: LiveChatTranscript
    */
    public static LiveChatTranscript CreateChatTranscript(Account acc, Contact con) {
        Livechattranscript ObjLct = new Livechattranscript();
        try{
        ObjLct.Account_Name__c=acc.EXT_Site_Id__c;
        ObjLct.Contact_First_Name__c=con.FirstName;
        ObjLct.Contact_Last_Name__c=con.LastName;
        ObjLct.Contact_Email__c=con.Email;
        ObjLct.Contact_Phone__c=con.Phone;

        }
        catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,'ApexDataUtil','createOppBrandRec','Opportunity Brand Management'); 
        }
        return ObjLct;
    }
}