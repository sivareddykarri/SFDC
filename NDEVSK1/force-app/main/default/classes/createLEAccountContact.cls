//@Create LE Account & Contact from Create LE Account&Contact with Apex flow 
public class createLEAccountContact {
    
    //input details that comes to apex from flow
    public class FlowInputs{
        
        @InvocableVariable
        public string recordId;
        
        @InvocableVariable
        public String Select_Company_Role;
        
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutputs{
        
        @InvocableVariable 
        public String AccountID; // if it is duplicated, then store the duplicated Lead ID
        @InvocableVariable 
        public String isPASSED; // 
        @InvocableVariable 
        public String strMessage; //  
        
        @InvocableVariable 
        public String strCompany; // 
        @InvocableVariable 
        public String strContact; //  
        
        
    }
    
    @InvocableMethod
    public static List<FlowOutputs>  createAccount(List<FlowInputs> inputs) {
        List<List<String>> contact_results = new List<List<String>>(); 
        List<FlowOutputs> results = new List<FlowOutputs>();
        FlowOutputs  result  = new FlowOutputs();
        FlowOutputs  resultContact  = new FlowOutputs();
        result.AccountID = '' ; //1234512345, recordId=' +  inputs[0].recordId + ', Role=  ' +   inputs[0].Select_Company_Role;
        result.strMessage='';
        string ipId ='';
        try {  
            ipId =inputs[0].recordId;
            string strRole = inputs[0].Select_Company_Role;
            system.debug('### ipId = ' + ipId + ', strRole=' + strRole);
            list<Account> accounts = new list<account>();
            Account account1 = new Account();
            
            
            list<industry_Portfolio__c> ips = [SELECT id, Property_Street__c	,Property_Street_2__c	,Brand_Name__c	, Chain_Scale__c	,
                                               Property_City__c	,Description__c	,Property_Country__c	,Create_Developer_Owner_Lead__c	,
                                               Create_Management_Company_Lead__c	,Dev_Own_Company_Name__c	,
                                               Developer_Owner_Contact_Name__c	,Developer_Owner_Contact_Title__c	,
                                               Developer_Owner_Contact_Phone__c	,Property_Fax__c	,Property_Name__c	,Management_Company_Name__c	,
                                               Management_Company_Contact_Name__c	,Management_Company_Contact_Title__c	,Management_Company_Contact_Phone__c	,
                                               Property_Phone_Number__c	,Property_Postal_Code__c	,Property_State_Province__c	,Data_Source__c	,
                                               Rooms__c,LE_External_Id__c,LE_Dev_Owner_Company_ID__c,LE_Management_Company_ID__c,
                                               Developer_Owner_Company_Street__c,Developer_Owner_Company_City__c,Developer_Owner_Company_Country__c,Developer_Owner_Company_State_Province__c,
                                               Management_Company_Street__c,Management_Company_City__c,Management_Company_Country__c,Management_Company_State_Province__c,
                                               Developer_Owner_Contact_Fax__c,   Management_Company_Contact_Fax__c
                                               FROM industry_Portfolio__c WHERE id =:ipId] ;
            system.debug('### ips = ' + ips);
            
            Id accountInfluencerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Influencer').getRecordTypeId();
            
            for(industry_Portfolio__c ip: ips)
            {
                
                
                Account1.RecordTypeID=accountInfluencerId;
                Account1.AccountSource=ConstantsforLE.LEType;
                Account1.Industry_Portfolio__c=ipId;  //create related list for LEAD
                // Account1.recod
                if (strRole=='Management') 
                {
                    
                    account1.name=ip.Management_Company_name__c;
                    account1.ShippingStreet=ip.Management_Company_Street__c;
                    account1.ShippingCity=ip.Management_Company_City__c;
                    account1.ShippingCountry =ip.Management_Company_Country__c;
                    account1.ShippingState=ip.Management_Company_State_Province__c;
                    account1.LE_Company_ID__c= ip.LE_Management_Company_ID__c;
                    
                    
                    
                }
                else
                {
                    
                    
                    account1.name=ip.Dev_Own_Company_Name__c; 
                    account1.ShippingStreet=ip.Developer_Owner_Company_Street__c;
                    account1.ShippingCity=ip.Developer_Owner_Company_City__c;
                    account1.ShippingCountry =ip.Developer_Owner_Company_Country__c;
                    account1.ShippingState=ip.Developer_Owner_Company_State_Province__c;
                    account1.LE_Company_ID__c= ip.LE_Dev_Owner_Company_ID__c;
                }
                
                
                list<Account> lstAccount = [select id,name from Account where LE_Company_ID__c !=null and LE_Company_ID__c=:account1.LE_Company_ID__c];
                system.debug('###### find duplicated  ID= ' + account1.LE_Company_ID__c + ',  lstLead = ' + lstAccount.size());
                if (lstAccount.size()>0)
                {
                    result.AccountID= lstAccount[0].id ;  
                    result.strCompany=lstAccount[0].name;
                    
                }
                
                if (string.isBlank(account1.name))
                {
                    
                    result.strMessage=ConstantsforLE.LECompanyInformationMissingforAccountCreation; 
                    result.strCompany='';
                    result.AccountID= '' ;  
                    
                }
                accounts.add(account1);
                result.strCompany=account1.name;
            }
            
            // Savepoint sp = Database.setSavepoint();
            
            Database.SaveResult[] srList = Database.insert(accounts, false);
            system.debug('### srList =' + srList);
            // string errMsg='';
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    result.strMessage =ConstantsforLE.LEAccountCreationSuccess;
                    result.AccountID= sr.getId() ;  
                    result.isPASSED='PASS' ; 
                    
                    resultContact=createContact(sr.getId(),ipId,strRole);
                    result.strContact = resultContact.strcontact; 
                    if(resultContact.isPASSED=='PASS')
                    {
                        result.strMessage =ConstantsforLE.LEAccountContactCreationSuccess; 
                        
                    } else
                    {
                        result.strMessage =ConstantsforLE.LEAccountNotContactCreationSuccess + '. ' +   resultContact.strMessage  ;  
                        
                    }
                    
                }
                else {
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        //errMsg = 'Create Account Error: ' + err.getMessage(); 
                        system.debug('###### result.strMessage ' + result.strMessage);
                        if (string.isBlank(result.strMessage))
                        { 
                            result.strMessage =  err.getMessage() + '. ' + ConstantsforLE.LEAccountCreationFail;
                        }
                        result.isPASSED='FAIL' ; 
                        
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        
                        
                        
                    }
                }
            }
            
            // Database.rollback(sp);
            //upsert  accounts   account.LE_Account_ID__c ;
            
            system.debug('### accounts = ' + accounts);
            
            
            
            
            
        } catch (exception ex)
        {
            
            ExceptionHandler.logHandledExceptions(ex,'createLEAccountContact','logHandledExceptions',ConstantsforLE.LECreateLEAccount); 
            system.debug('### ex.getMessage() = ' + ex.getMessage());
            
            if (string.isBlank(result.strMessage))
            { 
                result.strMessage ='Error in creating account: ' + ex.getMessage();
            }
            
            result.isPASSED='FAIL' ; 
        }
        results.add(result); 
        system.debug('### results = ' + results);
        return results;
        
    }
    
    public static FlowOutputs  createContact(id accountid, string ipId,string strRole)
    {
        // List<List<String>> results = new List<List<String>>(); 
        account  account1 = [select id from account where id=:accountid][0];
        
        FlowOutputs  result  = new FlowOutputs();
        try {  
            
            system.debug('### Process Contact. accountid=' + accountid + ' ipId = ' + ipId + ', strRole=' + strRole);
            
            system.debug('### account = ' + account1);
            list<Contact> contacts = new list<contact>();
            Contact contact1 = new Contact();
            
            
            list<industry_Portfolio__c> ips = [SELECT id, Property_Street__c	,Property_Street_2__c	,Brand_Name__c	, Chain_Scale__c	,
                                               Property_City__c	,Description__c	,Property_Country__c	,Create_Developer_Owner_Lead__c	,
                                               Create_Management_Company_Lead__c	,Dev_Own_Company_Name__c	,
                                               Developer_Owner_Contact_Name__c	,Developer_Owner_Contact_Title__c	,
                                               Developer_Owner_Contact_Phone__c	,Property_Fax__c	,Property_Name__c	,Management_Company_Name__c	,
                                               Management_Company_Contact_Name__c	,Management_Company_Contact_Title__c	,Management_Company_Contact_Phone__c	,
                                               Property_Phone_Number__c	,Property_Postal_Code__c	,Property_State_Province__c	,Data_Source__c	,
                                               Rooms__c,LE_External_Id__c,LE_Dev_Owner_Company_ID__c,LE_Management_Company_ID__c,
                                               Developer_Owner_Company_Street__c,Developer_Owner_Company_City__c,Developer_Owner_Company_Country__c,Developer_Owner_Company_State_Province__c,
                                               Management_Company_Street__c,Management_Company_City__c,Management_Company_Country__c,Management_Company_State_Province__c,
                                               Developer_Owner_Contact_Fax__c,   Management_Company_Contact_Fax__c
                                               FROM industry_Portfolio__c WHERE id =:ipId] ;
            system.debug('### Process Contact ips = ' + ips);
            
            Id contactInfluencerId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Influencer').getRecordTypeId();
            string uniqueID ='';
            string lastName='';
            string firstName='';
            string fullname='';
            for(industry_Portfolio__c ip: ips)
            {
                
                
                Contact1.RecordTypeID=contactInfluencerId;
                Contact1.DataSource__C=ConstantsforLE.LEType;
                contact1.AccountId=account1.id; //accountid;
                // Contact1.recod
                if (strRole=='Management') 
                {
                    // contact1.LastName=ip.Management_Company_Contact_Name__c;
                    // 
                    
                    fullname=ip.Management_Company_Contact_Name__c;
                    contact1.LE_Company_ID__c= ip.LE_Management_Company_ID__c;
                    
                    contact1.Title=ip.Management_Company_Contact_Title__c;
                    contact1.Phone =ip.Management_Company_Contact_Phone__c;
                    contact1.fax =ip.Management_Company_Contact_Fax__c;
                    
                    
                    contact1.MailingStreet=ip.Management_Company_Street__c;
                    contact1.MailingCity=ip.Management_Company_City__c;
                    contact1.MailingCountry =ip.Management_Company_Country__c;
                    contact1.MailingState=ip.Management_Company_State_Province__c;
                }
                else
                {
                    
                    //contact1.LastName=ip.Developer_Owner_Contact_Name__c;
                    fullname=ip.Developer_Owner_Contact_Name__c; 
                    contact1.LE_Company_ID__c= ip.LE_Dev_Owner_Company_ID__c;
                    
                    contact1.Title=ip.Developer_Owner_Contact_Title__c;
                    contact1.Phone =ip.Developer_Owner_Contact_Phone__c;
                    contact1.fax =ip.Developer_Owner_Contact_Fax__c;
                    
                    contact1.MailingStreet=ip.Developer_Owner_Company_Street__c;
                    contact1.MailingCity=ip.Developer_Owner_Company_City__c;
                    contact1.MailingCountry =ip.Developer_Owner_Company_Country__c;
                    contact1.MailingState=ip.Developer_Owner_Company_State_Province__c;
                    
                }
                
                   if(string.isBlank(fullname))
            {    result.strMessage = ConstantsforLE.LEContactInformationMissingforAccountCreation; 
             
                 result.isPASSED='FAIL' ; 
            }
                
                String trimmedName = fullname.trim();
                if (trimmedName.IndexOf(' ') < 0 )
                {
                    lastname=trimmedName;
                    
                }
                else
                    
                {
                    firstname=trimmedName.split(' ')[0];
                    lastname= trimmedName.split(' ')[1];
                    
                }
                contact1.lastname= lastname;               
                contact1.firstname= firstname;                 
                contact1.Industry_Portfolio__c=ipId;
                
                uniqueID=contact1.LE_Company_ID__c + contact1.lastname + contact1.Title + contact1.Phone; 
                system.debug('############ uniqueID '  + uniqueID) ; 
                contact1.LE_UniqueID__c=uniqueID;
                contacts.add(contact1);
                
            }
            
            // Savepoint sp = Database.setSavepoint();
            system.debug('### Process contacts List =' + contacts);
            Schema.SObjectField f = contact.LE_UniqueID__c;
            Database.UpsertResult[] srList = Database.upsert(contacts,f,true);
            system.debug('###  Contact Process Result srList =' + srList);
            string errMsg='';
            // Iterate through each returned result
            result.isPASSED='FAIL' ; 
            result.strMessage=''; 
            result.strContact=fullname;
            
            
         
             system.debug('############ fullname '  + fullname) ; 
              system.debug('############ string.isBlank(fullname)'  + string.isBlank(fullname)) ; 
            
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
                    // result.add(sr.getId());  
                    
                    result.isPASSED='PASS' ; 
                    result.strMessage=ConstantsforLE.LECompanyInformationMissingforAccountCreation; 
                    
                    
                }
                else {
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        errMsg = 'Create Contact Error: ' + err.getMessage(); 
                        
                        
                        
                        if (string.isBlank(result.strMessage))
                        { 
                            result.strMessage=errMsg; 
                        }
                        result.isPASSED='FAIL' ; 
                        System.debug('Contact fields that affected this error: ' + err.getFields());
                        
                        
                        
                    }
                }
            }
            
            // Database.rollback(sp);
            //upsert  contacts   contact.LE_Contact_ID__c ;
            
            system.debug('### contacts = ' + contacts);
            
            
        } catch (exception ex)
        {
            
            ExceptionHandler.logHandledExceptions(ex,'createLEAccountContact. Industry Profolio ID=' + ipId,'logHandledExceptions',ConstantsforLE.LECreateLEContact); 
            
            if (string.isBlank(result.strMessage))
            { 
                result.strMessage=ex.getMessage() ; 
            }
            result.isPASSED='FAIL' ; 
            
            
        }
        
        system.debug('### result = ' + result);
        return result;
    }
    
}