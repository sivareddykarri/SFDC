//@Test Class for createLEAccountContact
@isTest
public class createLEAccountContactTest {
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
    
    @isTest
    public static void testFlowApex()
    {
        
        
        
        
        industry_portfolio__c ip = new industry_portfolio__c() ;
        ip.LE_External_Id__c='LE2345';
        
        ip.LE_Management_Company_ID__c='LEMC12345';
        ip.Management_Company_Contact_Name__c='ABCM Manager';
        ip.Management_Company_name__c='ABCM Company';
        ip.Management_Company_Contact_Phone__c='1111111111';
        ip.Management_Company_Contact_Title__c='Manager1';
        
        ip.LE_Dev_Owner_Company_ID__c='LED12345'; 
        ip.Developer_Owner_Contact_Name__c='LEDC12345';
        ip.Dev_Own_Company_Name__c='ABCD Company';
        ip.Developer_Owner_Contact_Phone__c='2222222222';
        ip.Developer_Owner_Contact_Title__c='Developer1';
        
        insert ip;
        
        // Create data that's relevant, like ContentDocuments, as well as `o` and `a`.
        
        // Now, create the argument data structure for the InvocableMethod
        createLEAccountContact.FlowInputs argument;
        argument = new createLEAccountContact.FlowInputs();
        argument.recordId = ip.Id;
        argument.Select_Company_Role = ConstantsforLE.LERoleManagement;
      
        
        
        createLEAccountContact.createAccount(
            new List<createLEAccountContact.FlowInputs>{ argument }
        );
        argument.Select_Company_Role = ConstantsforLE.LERoleDeveloperOwner;
        createLEAccountContact.createAccount(
            new List<createLEAccountContact.FlowInputs>{ argument }
        );
        
        ip.Developer_Owner_Contact_Name__c=null;
        ip.Dev_Own_Company_Name__c='ABCD Company';
        update ip;
        createLEAccountContact.createAccount(
            new List<createLEAccountContact.FlowInputs>{ argument }
        );
        ip.Developer_Owner_Contact_Name__c='LEDC12345';
        ip.Dev_Own_Company_Name__c=null;
          update ip;
        createLEAccountContact.createAccount(
            new List<createLEAccountContact.FlowInputs>{ argument }
        );
        
    } 
}