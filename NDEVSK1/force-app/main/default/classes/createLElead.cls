//@Create LE LEAD from Create LE Lead with Apex flow 
global class createLElead {
    
    //input details that comes to apex from flow
    public class FlowInputs{
        
        @InvocableVariable
        public string recordId;
        
        @InvocableVariable
        public String Select_Company_Role;
        @InvocableVariable
        public String Competitor_Parent_Company;
        @InvocableVariable
        public String Competitor_Brand_Affiliation;
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutputs{
        
        @InvocableVariable 
        public String LeadID; // if it is duplicated, then store the duplicated Lead ID
        @InvocableVariable 
        public String isPASSED;  
        @InvocableVariable 
        public String strMessage; 
         @InvocableVariable 
        public String strContact; 
        @InvocableVariable 
        public String strCompany;  
        
    }
    
    @InvocableMethod
    
    public static List<FlowOutputs>  createLead(List<FlowInputs> inputs) {
        List<FlowOutputs> results = new List<FlowOutputs>();
        FlowOutputs  result  = new FlowOutputs();
        result.LeadID = '' ; //1234512345, recordId=' +  inputs[0].recordId + ', Role=  ' +   inputs[0].Select_Company_Role;
        result.strMessage='';
        string ipId ='';
        String trimmedName='';
        try {  
            ipId =inputs[0].recordId;
            string strRole = inputs[0].Select_Company_Role;
            string Competitor_Parent_Company =inputs[0].Competitor_Parent_Company;
            string Competitor_Brand_Affiliation = inputs[0].Competitor_Brand_Affiliation;
            system.debug('### ipId = ' + ipId + ', strRole=' + strRole);
            system.debug('### Competitor_Parent_Company = ' + Competitor_Parent_Company +
                         ', Competitor_Brand_Affiliation=' + Competitor_Brand_Affiliation);
            list<Lead> leads = new list<lead>();
            Lead lead1 = new Lead();
            
            
            list<industry_Portfolio__c> ips = [SELECT id, Property_Street__c	,Property_Street_2__c	,Brand_Name__c	, Chain_Scale__c	,
                                               Property_City__c	,Description__c	,Property_Country__c	,Create_Developer_Owner_Lead__c	,
                                               Create_Management_Company_Lead__c	,Dev_Own_Company_Name__c	,
                                               Developer_Owner_Contact_Name__c	,Developer_Owner_Contact_Title__c	,
                                               Developer_Owner_Contact_Phone__c	,Property_Fax__c	,Property_Name__c	,Management_Company_Name__c	,
                                               Management_Company_Contact_Name__c	,Management_Company_Contact_Title__c	,Management_Company_Contact_Phone__c	,
                                               Property_Phone_Number__c	,Property_Postal_Code__c	,Property_State_Province__c	,Data_Source__c	,
                                               Rooms__c,LE_External_Id__c,LE_Dev_Owner_Company_ID__c,LE_Management_Company_ID__c	  FROM industry_Portfolio__c WHERE id =:ipId] ;
            system.debug('### ips = ' + ips);
            string lastName='';
            string firstName='';
            string fullname='';
            system.debug('### fullname = ' + fullname);
            
            for(industry_Portfolio__c ip: ips)
            {
                
                //system.debug('### ip.Management_Company_Contact_Name__c = ' + ip.Management_Company_Contact_Name__c);
                // system.debug('### ip.LE_Dev_Owner_Company_ID__c = ' + ip.Developer_Owner_Contact_Name__c);
                Lead1.Status='New';
                Lead1.LeadSource=ConstantsforLE.LEType;
                // Lead1.recod
                if (strRole=='Management') 
                {
                    fullname=ip.Management_Company_Contact_Name__c;
                    lead1.Company=ip.Management_Company_name__c;
                    lead1.LE_Lead_ID__c=ip.LE_External_Id__c+ip.LE_Management_Company_ID__c;
                    lead1.LE_Company_ID__c=ip.LE_Management_Company_ID__c;
                    lead1.Phone=ip.Management_Company_Contact_Phone__c;
                    lead1.Title=ip.Management_Company_Contact_Title__c;
                    
                    
                }
                else
                {
                    
                    fullname=ip.Developer_Owner_Contact_Name__c;
                    lead1.Company=ip.Dev_Own_Company_Name__c; 
                    lead1.LE_Lead_ID__c=ip.LE_External_Id__c+ip.LE_Dev_Owner_Company_ID__c;
                    lead1.LE_Company_ID__c=ip.LE_Dev_Owner_Company_ID__c; 
                    lead1.Phone=ip.Developer_Owner_Contact_Phone__c;
                    lead1.Title=ip.Developer_Owner_Contact_Title__c;
                    
                }
                
                if(string.isBlank(fullname))
                {   result.strMessage = ConstantsforLE.LEContactInformationMissingforLeadCreation; // strRole + ' ' +  ConstantsforLE.LEContactInformationMissing + '. ' + ConstantsforLE.LELeadCreationFail ;
                    result.strCompany =lead1.Company ;
                 result.isPASSED='FAIL' ; 
                }
                
                 if(string.isBlank(lead1.Company))
                {   result.strMessage = ConstantsforLE.LECompanyInformationMissingforLeadCreation; // strRole + ' ' +  ConstantsforLE.LEContactInformationMissing + '. ' + ConstantsforLE.LELeadCreationFail ;
                    result.strCompany =lead1.Company ;
                 result.isPASSED='FAIL' ; 
                }
                
                  trimmedName = fullname.trim();
                if (trimmedName.IndexOf(' ') < 0 )
                {
                    lastname=trimmedName;
                    
                }
                else
                    
                {
                    firstname=trimmedName.split(' ')[0];
                    lastname= trimmedName.split(' ')[1];
                    
                }
                lead1.lastname= lastname;               
                lead1.firstname= firstname; 
                
                lead1.Industry_Portfolio__c=ipId;  //create related list for LEAD
                lead1.Property_Street__c = ip.Property_Street__c;  //Property_Street_2__c?
                
                
                //    lead1.Property_Current_Parent_Company__c = Competitor_Parent_Company;   //??  Property Current Parent Company: bad value for restricted picklist field: Holiday Inn Express
                //    lead1.Property_Current_Brand_Affiliation__c = Competitor_Brand_Affiliation;  //??  bad value for restricted picklist field: Holiday Inn Express
                
                
                
                lead1.Property_State_Province__c = ip.Property_State_Province__c;     //   -  Property State/Province: bad value for restricted picklist field: OK
                
                lead1.Chain_Scale__c = ip.Chain_Scale__c;  // Chain Scale: bad value for restricted picklist field: Upper Midscale
                lead1.Property_City__c = ip.Property_City__c;
                lead1.Property_Description__c = ip.Description__c;
                lead1.Property_Country__c = ip.Property_Country__c;
                
                lead1.fax = ip.Property_Fax__c;
                //lead1.phone = ip.Property_Name__c;
                lead1.Property_Phone_Number__c = ip.Property_Phone_Number__c;
                lead1.Property_Zip_Postal_Code__c = ip.Property_Postal_Code__c;
                
                // lead1.Property_State_Province__c = ip.Property_State_Province__c;    -  Property State/Province: bad value for restricted picklist field: OK
                
                //lead1.LeadSource = Deafult to 'Lodging Econometrics' ?Data_Source__c
                lead1.Number_of_Hotel_Rooms__c = ip.Rooms__c;
                lead1.LE_Property_ID__c = ip.LE_External_Id__c;
                
                
                list<lead> lstLead = [select id,name from lead where LE_Lead_ID__c !=null and LE_Lead_ID__c=:lead1.LE_Lead_ID__c];
                system.debug('###### find duplicated  ID= ' + lead1.LE_Lead_ID__c + ',  lstLead = ' + lstLead.size());
                if (lstLead.size()>0)
                {
                    result.LeadID= lstLead[0].id ;  
                      result.strContact=lstLead[0].name;
                }
                
                leads.add(lead1);
                result.strCompany=lead1.Company;
               // result.strContact=lead1.name;
                
            }
            
            // Savepoint sp = Database.setSavepoint();
            
            Database.SaveResult[] srList = Database.insert(leads, false);
            system.debug('### srList =' + srList);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Lead ID: ' + sr.getId());
                    result.strMessage ='Lead Created Successfully';
                    result.LeadID= sr.getId() ;  
                    result.isPASSED='PASS' ; 
                   
                     result.strContact=trimmedName;
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.' + err);                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
                        if (string.isBlank(result.strMessage))
                        { 
                            result.strMessage =ConstantsforLE.LELeadCreationFail + '. ' + err.getMessage();
                        }
                        result.isPASSED='FAIL' ; 
                        result.strContact=trimmedName;
                          
                    }
                }
            }
            
            // Database.rollback(sp);
            //upsert  leads   lead.LE_Lead_ID__c ;
            
            system.debug('### leads = ' + leads);
            
            
            
            
            
        } catch (exception ex)
        {
            system.debug('### ex.getMessage() = ' + ex.getMessage());
            
            ExceptionHandler.logHandledExceptions(ex,ConstantsforLE.LECreateLELead,'logHandledExceptions . Industry Profolio ID=' + ipId,ConstantsforLE.LECreateLELead); 
            
            
            if (string.isBlank(result.strMessage))
            { 
                result.strMessage =ConstantsforLE.LELeadCreationFail +'. ' + ex.getMessage();
            }
            result.isPASSED='FAIL' ; 
        }
        results.add(result); 
        system.debug('### results = ' + results);
        return results;
        
    }
}