/***
@Author : Vazeer Mohammed
@Name   : ConstantClass
@Created Date: 21/03/2018
@Description: To Store all the String Values to avoid NovaCop issues
@Version:0.1
@Update Date: 9/30/2019 by JZ
@Description: add opportunity stage  contract signed
@Reference: **/ 
global without sharing class ConstantClass {
    public Static final String SHAREDTOPW = 'Shared To PW';
    public Static final String SHAREDTOVRX = 'Shared To VRX';
    public Static final String CONNECTIONID ='ConnectionId';
    public Static final String STATUS='Status';
    public Static final String STARTDATE='StartDate';
    public Static final String ENDDATE='EndDate';
    public Static final String MASTER='Master';
    public Static final String CLOSED='Closed';
    public Static final String ABORTED='Aborted';
    public Static final String CLOSED_ACTION_REQ='Closed - Action Required';
    public Static final String APEX_CASE_ERRMSG_001='APEX-Case-001-Parent Case cannot be closed until the related child cases are closed,So please close the Related Child Cases';
    public Static final String NUMERIC_1='1';
    public Static final String UNDERSCORE='_';
    public Static final String ACCEPTED='Accepted';
    
    //PhotoshootTriggerHandler
    public Static final String PHOTOSHOOTHANDLER = 'PhotoShootHandler';
    public Static final String AUTOSHARETOCONNECTION = 'autoShareToConnection';
    public Static final String CREATECASEAUTOMATICALLY = 'createCaseAutomatically';
    public Static final String GETPHOTORECORDS = 'getPhotoRecords';
    public Static final String PHOTOWEB_APPLICATION = 'Photoweb Application';
    public Static final String MRCONTENT2QUEUE = 'MR Content 2 Queue';
    public Static final String QUEUE = 'Queue';
       
    //CaseTriggerHandler
    public Static final String TESTDATA_CHILDCASE ='testdata_ChildCase';
    public Static final String DISPLAYERRORONPARENTCASE ='displayErrorOnParentCase';
    public Static final String SENDPUSHNOTIFICATIONTOCASEOWNER ='sendPushNotificationtoCaseOwner';
    public Static final String GETCASESLIMIT3 = 'getCasesLimit3';
    public Static final String UPDATESLAFIELDONCASE = 'updateSLAFieldOnCase';
    public Static final String UPDATEPMSYSTEMFIELD = 'updatePMSystemField';
    public Static final String GETCASESWITHLIMIT = 'getCasesWithLimit';
    public Static final String FETCHRECORDTYPEVALUES = 'fetchRecordTypeValues';
    public Static final String UPDATELEGACYFIELDSNULL = 'updateLegacyFieldsNull';
    public Static final String GETRECTYPEID = 'getRecTypeId';
    public Static final String SETFLAGTRUE = 'setFlagTrue';
    public Static final String GETSOBJECTNAME = 'getSobjectName';
    public Static final String HARDWARECONFIGURATION ='Hardware Configuration';
    public Static final String CASEHANDLER = 'CaseHandler';
    public Static final String CASE_MANAGEMENT ='Case Management';
    public Static final String ACCOUNTOBJECT = 'Account';
    public Static final String PHOTOSHOOTOBJECT = 'Photo_shoot__c';
    public Static final String TECHNOLOGYOBJECT = 'Technology__c';
    public Static final String UPDATECONTACTONCASE = 'updateContactOnCase';
    public Static final String UPDATECHILDRECORDSTOABORTEDWHENPARENTABORTED= 'updateChildRecordsToAbortedWhenParentAborted';
    public Static final String INTEGRATIONINFORMATICA = 'Integration - Informatica';
    public Static final String INTERNALREQUESTS= 'Internal Requests';
    public Static final String RESCTRICTUNRESCTRICT = 'Restrict/Un-Restrict';
    public Static final String STATUSCHANGE = 'Status Change';
    
    Public Static final Id ACCSITERECTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    Public Static final Id ACCENTITYRECTYPEID = Schema.SObjectType.account.getRecordTypeInfosByName().get('Entity').getRecordTypeId();
    Public Static final Id TECHRECTYPEID = Schema.SObjectType.Technology__c.getRecordTypeInfosByName().get('Hardware Configuration').getRecordTypeId();
    
    //LiveChatTranscriptHandler
    Public Static final Id CASEDISTRECTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Distribution').getRecordTypeId();                 
    Public Static final Id CASEGENREQRECTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Request').getRecordTypeId();
    Public Static final Id CASESYSREQRECTYPEID =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('System Requests').getRecordTypeId();
    Public Static final String LIVECHATTRANSCRIPTHANDLER = 'LiveChatTranscriptHandler';
    Public Static final String LIVEAGENTFUNCTIONALITY = 'LiveAgentFunctionality';
    Public Static final String LIVECHATUTILMETHOD = 'liveChatUtilMethod';
    Public Static final String FETCHEXISTINGCONTACT = 'fetchExistingContact';
    Public Static final String FETCHEXISTINGCONORCREATEACCCON = 'fetchExistingConOrCreateAccCon';
    Public Static final String FETCHACCOUNT = 'fetchAccount';
    Public Static final String CREATECASE = 'createcase';
    Public Static final String FETCHCASE = 'fetchcase';
    public Static final String FINANCE ='Finance';
    
    //LiveChatTranscriptHelper
    public Static final String DESCRIPTION='Test data to create case';
    public Static final String TYPE='Standard';
    public Static final String BUTTONNAME='ChatButton1';
    public Static final String ROUTINGTYPE='Omni';
    public Static final String ACCOUNTSITE='12345';
    public Static final String COMMA = ',';
    public Static final String NEWLINE = '\n';
    public Static final String NEWSTATUS='New';
    public Static final String AUTOGENERATED='Auto-Generated';
    public Static final String MEDIUMPRIORITY='Medium';
    public Static final String CASETYPERATESOTA='Rates / OTA / Inventory / Content / GDS';
    public Static final String CONTENTTYPE='Content';
    public Static final String PHOTOSPERFROMVENDOR='Photos Permenant from Vendor';
    public Static final String DELIVERY='Delivery';
    public Static final String UPLOADFINAL='Upload Final';
    public Static final String ORIGINCHAT='Chat';
    public Static final String PRIORITYHIGH='High';
    public Static final String SYSTEMINSTALLUPGRADETYPE='System Install & Upgrades';
    public Static final String CHECKSERVICETYPE='Check status of Service Request/ Request Form';
    public Static final String HOWTOSTYPE='How To\'s';
    public Static final String FINANCETYPE='Finance';
    public Static final String RATESOTAINVENTORYTYPE= 'Rates / OTA / Inventory / Content / GDS';
    public Static final String SYSTEMINQUIRESSUPPORT='System Inquiries & Support';
    
    public Static final String CHATBUTTON1 = 'Installation_or_upgrade_of_my_property_technology_HTCS_L1_No_Sys_Chat';
    public Static final String CHATBUTTON2 = 'Get_status_of_an_existing_request_ticket_OSD_L1_General_Chat';
    public Static final String CHATBUTTON3 = 'Technology_issue_question_about_my_Opera_PM_System_HTCS_L1_Opera_Chat';
    public Static final String CHATBUTTON4 = 'Tech_issue_question_about_a_WHG_Managed_Property_HTCS_L1_Managed_Chat';
    public Static final String CHATBUTTON5 = 'Technology_issue_question_about_my_SynXis_PM_System_HTCS_L1_Synxis_Chat';
    public Static final String CHATBUTTON6 = 'Technology_issue_question_about_MyPortal_HTCS_OSD_L1_MyPortal_Chat';
    public Static final String CHATBUTTON7 = 'How_do_I_Formerly_Operations_Support_Desk_OSD_L1_General_Chat';
    public Static final String CHATBUTTON8 = 'Financial_billing_or_performance_OSD_L1_General_Chat';
    public Static final String CHATBUTTON9 = 'Rates_inventory_online_travel_agencies_OTAs_or_GDS_OSD_L1_General_Chat';
    public Static final String CHATBUTTON10= 'Technology_issue_question_about_my_SynXis_CR_System_HTCS_L1_No_Sys_Chat';
    public Static final String CHATBUTTON11= 'I_don_t_see_my_inquiry_listed_here_HTCS_L1_No_Sys_Chat';
    public Static final String CHATBUTTON12= 'Site_Installation_or_upgrade_of_my_property_technology_HTCS_L1_No_Sys_Chat';
    public Static final String CHATBUTTON13= 'Site_Get_status_of_an_existing_request_ticket_OSD_L1_General_Chat';
    public Static final String CHATBUTTON14= 'Site_Tech_issue_question_about_my_Opera_PM_System_HTCS_L1_Opera_Chat';
    public Static final String CHATBUTTON15= 'Site_Tech_issue_ques_about_a_WHR_Managed_Property_HTCS_L1_Managed_Chat';
    public Static final String CHATBUTTON16= 'Site_Tech_issue_question_about_my_SynXis_PM_System_HTCS_L1_Synxis_Chat';
    public Static final String CHATBUTTON17= 'Site_Tech_issue_question_about_MyPortal_HTCS_OSD_L1_MyPortal_Chat';
    public Static final String CHATBUTTON18= 'Site_How_do_I_Formerly_Operations_Support_Desk_OSD_L1_General_Chat';
    public Static final String CHATBUTTON19= 'Site_Financial_billing_or_performance_OSD_L1_General_Chat';
    public Static final String CHATBUTTON20= 'Site_Rates_Invent_online_travel_agencies_or_GDS_OSD_L1_General_Chat';
    public Static final String CHATBUTTON21= 'Site_Tech_issue_question_about_my_SynXis_CR_System_HTCS_L1_No_Sys_Chat';
    public Static final String CHATBUTTON22= 'Site_I_don_t_see_my_inquiry_listed_here_HTCS_L1_No_Sys_Chat';
    
    public Static final String GETSTATUS='Get status of an existing';
    public Static final String GETS='Get status';
    public Static final String HOW='How do I';
    public Static final String OTHER='Other';
    public Static final String INPROGRESS='InProgress';
    public Static final String WAIT='Waiting';
    Public Static final String LIVECHATTRANSCRIPTHELPER = 'LiveChatTranscriptHelper';
    Public Static final String GETCUSTOMPRECHATDATA = 'Get custom Prechat Data';
    Public Static final String CREATECASEFORFAQ = 'createCaseForFAQ';
    Public Static final String CHATBOTFUNCTION = 'ChatBotFunctionality';
    
        
    // NotificationAlertBatch
    public Static final String NUMERIC_005 = '005';
    public Static final String NUMERIC_00G = '00G';
    public Static final String LEFT_BRACE = '{';
    public Static final String RIGHT_BRACE = '}';
    public Static final String LEFT_PARENTHESIS = '(';
    public Static final String RIGHT_PARENTHESIS = ')';
    public Static final String INACTIVITYALERTPRE = ' This case ';
    public Static final String INACTIVITYALERTPOST = ' has been inactive for 2 days. Kindly follow up on it';
    public Static final String ESTIMATEDDATEALERTPRE = ' The Estimated Completion Date for the case ';
    public Static final String ESTIMATEDDATEALERTPOST = ' is in 1 day. Kindly follow up on it';
    public Static final String ADJUSTEDESTIMATEDDATEALERTPRE = ' The Adjusted Estimated Completion Date for the case ';
    public Static final String ADJUSTEDESTIMATEDDATEALERTPOST = ' is in 1 day. Kindly follow up on it';
    
    //ConnectAPIHelper
    public Static final String TEXTWITHMENTIONS = 'textWithMentions';
    public Static final String THE = 'the';
    public Static final String PARAMETER_NON_EMPTY  = 'parameter must be non-empty.';
    public Static final String INPUT_TEXT_PARAMETER_NOT_NULL  = 'The inputText parameter cannot be null.';
    public Static final String PATTERN = '(\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})|(<[a-zA-Z]*>)|(</[a-zA-Z]*>)|(\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})';
    public Static final String IMG = 'img:';
    public Static final String COLON = ':';
    public Static final String BEGINTAG = '</';
    public Static final String TAG = '>';  
    public Static final String CONNECTAPIHELPER = 'ConnectApiHelper';
    public Static final String GETMESSAGESEGMENTINPUTS = 'getMessageSegmentInputs';
    public Static final String PUSHNOTIFICATIONFUNCTIONALITY  = 'PushNotificationFunctionality';
    public Static final String POSTFEEDITEMWITHMENTIONS = 'postFeedItemWithMentions';
       
    //AccountContactRelationshipHelper
    public Static final String SEMICOLON = ';';
    public Static final String ALPHA_Y = 'Y';
    public Static final String INACTIVE = 'Inactive';
    public Static final String ACTIVE = 'Active';
    public Static final String ACCOUNTCONTACTRELATIONSHIPUTILITY = 'AccountContactRelationshipUtility';
    public Static final String CREATEACCOUNTCONTACTRELATION = 'createAccountContactRelation';
    public Static final String ACCOUNTCONTACTRELATIONBATCH = 'AccountContactRelationBatch';
    public Static final String ACCOUNTCONTACTMANAGEMENT = 'AccountContactManagement';
    public Static final String SITE = 'Site';
    public Static final String ENTITY = 'Entity';
    public Static final String TOPLEVEL = 'Top Level';
    public Static final String LINELEVEL = ' ';
    public Static final String ENTITYPRINCIPLE = 'Entity Principle';
    public Static final String ENTITYOWNER = 'Entity Owner';
    public Static final String ORGANIZATION = 'Organization';
    public Static final String ERROR = 'Error';
    public Static final String PROCESSED = 'Processed';
    public Static final String UPDATECONRESULTLIST = 'updateConResultList';
    public Static final String INSERTACCCONRELTLISTRESULT = 'insertAccConReltListResult';
    public Static final String UPDATEACCCONRELTLISTRESULT = 'updateAccConReltListResult';
    public Static final String UPDATECONTRCTCONRELTLISTRESULT = 'updateContrctConReltListResult';
    
    //ContactManagement
    public Static final String CONTACTFIRSTNAMEFIELD = 'Contact_First_Name__c';
    public Static final String CONTACTLASTNAMEFIELD = 'Contact_Last_Name__c';
    public Static final String CONTACTEMAILFIELD = 'Contact_Email__c';
    public Static final String CONTACTPHONEFIELD = 'Contact_Phone__c';
    public Static final String ACCOUNTNAMEFIELD = 'Account_Name__c';
    public Static final String CONTACTMANAGEMENT = 'ContactManagement';
    public Static final String GENERICMETHODTOFETCHCONTACT = 'genericMethodToFetchContact';
    
    public static Boolean isBeforeInsertFirstTime = true;
    public static Boolean isBeforeUpdateFirstTime = true;
    public static Boolean isAfterInsertFirstTime = true;
    public static Boolean isAfterUpdateFirstTime = true;
    
    //ExceptionHandler
    public Static final String EXCEPTIONHANDLER = 'ExceptionHandler';
    public Static final String LOGHANDLEDEXCEPTIONS = 'logHandledExceptions';
    public Static final String LOGCALLOUTERRORS = 'logCalloutErrors';
    public Static final String EXCEPTIONHANDLING = 'exceptionhandling';
    
    //PhotoshootTriggerMainHandler
    public Static final String PHOTOSHOOTRIGGERMAINHANDLER = 'PhotoshootTriggerMainHandler';
    public Static final String AFTERUPDATE = 'afterUpdate';
    
    //LiveChatTranscriptTriggerMainHandler
    public Static final String LIVECHATTRANSCRIPTTRIGGERMAINHANDLER = 'LiveChatTranscriptTriggerMainHandler';
    public Static final String BEFOREINSERT = 'beforeInsert';
    
    //CaseTriggerMainHandler
    public Static final String CASETRIGGERMAINHANDLER = 'CaseTriggerMainHandler';
    public Static final String BEFOREUPDATE = 'beforeUpdate';
    public Static final String AFTERINSERT = 'afterInsert';
    
    //WebToCaseHandler
    public Static final String WEBLIBRARY = 'webToCase library';
    public Static final String USERID = 'userid';
    public Static final String CONTENT = 'Content';
    public Static final String OTA = 'OTA';
    public Static final String SPECIALEVENTS = 'Special Events Consultation';
    public Static final String GENERALREQUEST = 'General';
    public Static final String RATEPLAN = 'Rate Plan';
    public Static final String NATIONALREGION = 'National/Regional Preferred Accounts';
    public Static final String OTHERREQUEST = 'other';
    public Static final String RATESOTAINVENTORY = 'Rates / OTA / Inventory / Content / GDS';
    public Static final String HOWTO ='How To\'s';
    public Static final String ORIGINWEB ='Web';
    public Static final String SITEERROR ='Please enter correct site# ';
    public Static final String DISTRIBUTIONRECORD ='Distribution';
    public Static final String GENERALRECORD ='General Request';
    public Static final String ROOMTYPE ='Room Type';
    public Static final String INVENTORY = 'Inventory';
    
    //TriggerHandler
    public Static final String PROPERTYSUPPORTDATA = 'Property Support Data';
    public Static final String TECHERRORMESSAGE='You Cannot associate more than one PSD record';
    
    //LeadTriggerHelper
    public Static final String TEMPORARY = 'Temporary';
    public Static final String ACCOUNTRECORDTYPEINTERMEDIARYERROR = 'Apex-ACC-001-Account Record Type Should be Temporary';
    public Static final String CONTACTRECORDTYPEINTERMEDIARYERROR = 'Apex-CON-001-Contact Record Type Should be Temporary';
    public Static final String INTERNAL = 'Internal';
    public Static final String LEADTRIGGERHELPER  = 'LeadTriggerHelper';
    public Static final String CREATEOPPORTUNITYPRODUCTS  = 'createOpportunityProducts';
    public Static final String DISPLAYERRORONLEAD  = 'displayErrorOnLead';
    public Static final String LEAD_MANAGEMENT  = 'Lead Management';
    public Static final String LEAD  = 'Lead';
    public Static final String CONTACT  = 'Contact';
   
    
    //Bypass before Update Opportunity Brand Trigger
    private static boolean blnOppBrandTriggerBeforeUpdate = false;
    
    /*Method: getBlnOppBrandTriggerBeforeUpdate bypass Before Update opportunity Brand Trigger*/
    public static Boolean getBlnOppBrandTriggerBeforeUpdate(){
        return blnOppBrandTriggerBeforeUpdate;
    }
    
    /*Method: setBlnOppBrandTriggerBeforeUpdate bypass Before Update opportunity Brand Trigger*/
    public static void setBlnOppBrandTriggerBeforeUpdate(Boolean value){
        blnOppBrandTriggerBeforeUpdate = value;
    }
    
     //OpportunityBrandTriggerHelper
     public Static final String OPPORTUNITYBRANDTRIGGERHELPER ='OpportunityBrandTriggerHelper';
     public Static final String DISPLAYERRORIFBRANDDUPLICATE  ='displayErrorIfBrandDuplicate';
     public Static final String OPPORTUNITY_BRAND_MANAGEMENT  ='Opportunity Brand Management';
     public Static final String REMOVEPRIMARYONOTHEROPPBRANDS  ='removePrimaryOnOtherOppBrands';
     public Static final String ATLEASTONEPRIMARYOPPORTUNITYBRAND  ='atleastOnePrimaryOpportunityBrand';
     public Static final String DUPLICATEBRANDERROR  ='APEX_OppBrand_001-This opportunity Brand already exists for this opportunity';
     public Static final String PRIMARYBRANDERROR  ='APEX_OppBrand_002-There must be one primary Opportunity Brand when stage is Application, Negotation, Contracting, Contract Signed, or Closed Won';
     public Static final String CLOSEDLOST='Closed Lost';
    
     //OpportunityTriggerHelper
     public Static final String ONEPRIMARYOPPORTUNITYBRANDERROR  ='APEX_OPP_001-There must be one primary Opportunity Brand when stage is Application, Negotation, Contracting, Contract Signed, or Closed Won';
     public Static final String OPPORTUNITYTRIGGERHELPER ='OpportunityTriggerHelper';
     public Static final String OPPORTUNITY_MANAGEMENT  ='Opportunity Management';
     public Static final String CLIENTID ='LegacySalesforceClientID';
     public Static final String CLIENTSECRET ='LegacySalesforceClientSecret';
     public Static final String USERNAME ='{!$Credential.UserName}';
     public Static final String PASSWORD ='{!$Credential.Password}';
     public Static final String CONTRACTSIGNED ='Contract Signed';
     public Static final String OPPORTUNITYINLEGACYERROR ='APEX_OPP_002-Primary Opportunity Brand must be requested for Opportunity creation in Legacy';
     public Static final String REQBODY ='grant_type=password&client_id=';
     public Static final String REQCLIENTSECRET ='&client_secret=';
     public Static final String REQUSERNAME ='&username=';
     public Static final String REQPASSWORD ='&password=';
     public Static final String POST ='POST';
     public Static final String CALLOUT1 ='callout:Named_Credentials_Legacy_Salesforce';
     public Static final String CALLOUT2 ='/services/oauth2/token';
     public Static final String AUTHORIZATION ='Authorization';
     public Static final String BEARER ='Bearer ';
     public Static final String CONTENTTYPE1 ='Content-Type';
     public Static final String APPJSON ='application/json';
     public Static final String LEGACYENDPOINT = 'LegacyEndPoint';
     public Static final String POSTOPPORTUNITY ='/services/apexrest/PostOpportunity/';
     public Static final String OPERATIONSREQUEST ='Operations Request';
     public Static final String SUCCESS ='success';
     public Static final String STATUSERROR ='error';
     public Static final String LEGACYERROR ='Legacy Error';
     public Static final String GENERICMETHOD ='genericMethodForOpportunityIntegration';
     public Static final String UPDATEPIPOPPREF ='UpdatePipOppRefInOppBrand';
     public Static final String INSERTINTSERVICE ='insertIntegrationServiceRecord';
     public Static final String REQUESTERROR ='Request Error';
     public Static final String ERROR1 ='An error occurred when processing an Operations Request integration. Please click on the link ';
     public Static final String ERROR2 =' for more details.';
     public Static final String ADMINCHATTER ='Admin Chatter GroupId';
     public Static final String SLASH ='/';
     public Static final String CLOSEDWON = 'Closed Won';
     public Static final String CONTRACTING = 'Contracting';
     public Static final String NUMERIC_100 = '100%';
     public Static final String NUMERIC_0 = '0%';
     
     
     //Messaging
     public Static final String INBOUNDINITIATED = 'InboundInitiated';
     public Static final String TRIGGEREDOUTBOUND = 'Triggered Outbound';
     public Static final String SMS = 'SMS';
     public Static final String HTCSSYNXIS = 'HTCS Synxis';
     public Static final String HTCSOPERA = 'HTCS Opera';
     public Static final String HTCSMANAGED = 'HTCS Managed';
     public Static final String OSDGENERALMESSAGE = 'OSD General Message';
     public Static final String CASENOTIFICATIONCHANNEL = 'Case Notification';
     public Static final String MESSAGETRIGGERHANLDER = 'MessageTriggerHandler';
     public Static final String CREATECASEFORMESSAGE = 'createCaseForMessage';   
     public Static final String SMSMANAGEMENT = 'SMS Management'; 
     public Static final String CONVERSATIONENTRY = 'conversationEntry'; 
     public Static final String CLOSECASEFORMESSAGE = 'closeCaseForMessage';  
    
    //Bot
    public Static final String PATH='/chat/rest/Visitor/Availability?org_id=';
    public Static final String PATH1='&deployment_id=';
    public Static final String PATH2='&Availability.ids=';
    public Static final String GET='GET';
    public Static final String LIVEAGENT='X-LIVEAGENT-API-VERSION';
    public Static final String LIVE='42';
    public Static final String TEXT='isAvailable';
   }