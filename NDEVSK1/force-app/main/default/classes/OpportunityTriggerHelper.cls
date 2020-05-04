/** 
@Author :  Vazeer Mohammed
@Name   :  OpportunityTriggerHelper
@Created Date: 1/05/2019
@Created Date: 1/05/2019
@Description: Helper class to handle all Opportunity operations on Trigger

 
@Update Date: 9/13/2019 by JZ
@Description: add probabilitySystem (Property - %) and probabilityOpen (Openings Probability )

@Update Date: 9/30/2019 by JZ
@Description: SFR-001366 - Opportunity Stages Update - Automate: Update to closed won from contract signed & ACD with execution date
@ Add updateStagetoClosedWon
≈
@Reference: 
**/
public class OpportunityTriggerHelper{
    
    private static final String clientId = Wyndham_Constants_List__c.getInstance(ConstantClass.CLIENTID).Value__c;
    private static final String clientSecret = Wyndham_Constants_List__c.getInstance(ConstantClass.CLIENTSECRET).Value__c;
    private static final String username = ConstantClass.USERNAME;
    private static final String password = ConstantClass.PASSWORD;
        
    public class operationsRequest {
        public String oppNumber;
        public String oppName;
        public String accountName;
        public String accountId;
        public String stageName;
        public String anticipatedOpenDate;
        public String anticipatedRoomCnt;
        public String closedDate;
        public String propertyStreet;
        public String propertyCity;
        public String propertyState;
        public String propertyCountry;
        public String propertyZip;
        public String pipRequestComments;
        public String currentBrand;
        public String contactName;
        public String contactPhone;
        public String dealType;
        public String oppOwnerPhone;
        public String oppOwnerEmail;
        public String oppOwner;
        public String inspectionType;
        public String inspectionReason;
        public String splitProperty;
        public String probability;
        public String probabilitySystem;
        public String probabilityOpen;
        public String region;
        public String managedFranchised;
        public String primary;
        public String oppBrandLine;
        public String brandCode;
        public String requestOpp;
        public String requestPIP;
        public String legacyOppId;
        public String legacyPIPId;
    }
    
    public class OppRequest {
        public List<operationsRequest> operationsRequest;
    }
    
    public class OperationsResponse {
        public String status;
        public String errCode;
        public String errMessage;
        public String oppNumber;
    }
    
    public class LineItemsResponse {
        public String oppBrandLine;
        public String legacyOppId;
        public String legacyPIPId;
    }
    
    public class oppResponse{
        public OperationsResponse operationsResponse; 
        public List<LineItemsResponse> lineItemsResponse; 
    }
    
    public class deserializeAccessTokenResponse {
        public String id;
        public String access_token;
    }
    
    public class oppWithAdminAccess {
        @AuraEnabled
        public Opportunity opp;
        @AuraEnabled
        public boolean access;
        @AuraEnabled
        public Integer oppBrandSize;
    }
    
    /**
    * Description: Displays Error When Opportunity Stage is Changed to Application, Negotation,
                   Contracting, Contract Signed, or Closed Won without Primary Opportunity Brand
    * @MethodName: atleastOnePrimaryOpportunityBrand
    * @Created by: Vazeer Mohammed
    * @parameters: List<Opportunity>
    * @return: Void
    * @throws Exception-when ever the list is not found.
    */
    public static void atleastOnePrimaryOpportunityBrand(List<Opportunity> oppList){
        try{
            Map<Id,List<Opportunity_Brand__c>> oppOppBrandMap = new Map<Id,List<Opportunity_Brand__c>>();
            
            for(Opportunity_Brand__c objOppBrand : [SELECT Id,Opportunity__c,Primary__c,Request_Opportunity__c
                                                    FROM Opportunity_Brand__c
                                                    WHERE Opportunity__c=:oppList 
                                                    AND Primary__c=true
                                                    LIMIT 50000]){
               if(oppOppBrandMap.containsKey(objOppBrand.Opportunity__c)){
                    oppOppBrandMap.get(objOppBrand.Opportunity__c).add(objOppBrand);
                }else{
                    oppOppBrandMap.put(objOppBrand.Opportunity__c, new List<Opportunity_Brand__c>{objOppBrand});
                }    
            }
            for(Opportunity objOpp : oppList){
                if(oppOppBrandMap.containsKey(objOpp.Id) && oppOppBrandMap.get(objOpp.Id)!=null){
                    for(Opportunity_Brand__c objOppBrand: oppOppBrandMap.get(objOpp.Id)){                        
                        if(objOpp.StageName==ConstantClass.CONTRACTSIGNED &&  !objOppBrand.Request_Opportunity__c){
                            objOpp.addError(ConstantClass.OPPORTUNITYINLEGACYERROR);
                        }
                    }
                }else{            
                    if(objOpp.StageName!=ConstantClass.NEWSTATUS && objOpp.StageName!=ConstantClass.CLOSEDLOST){
                        objOpp.addError(ConstantClass.ONEPRIMARYOPPORTUNITYBRANDERROR);
                    }
                }
            }
        }catch(Exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.OPPORTUNITYTRIGGERHELPER,ConstantClass.ATLEASTONEPRIMARYOPPORTUNITYBRAND,ConstantClass.OPPORTUNITY_MANAGEMENT);
        }
    }

    /**
    * Description: Fetching the Opportunity Detatils from Opportunity ID
    * @MethodName: getOppDetailsWithUserAccess
    * @Created by: Vazeer Mohammed
    * @parameters: Id recId
    * @return: Void
    */
    @AuraEnabled
    public static oppWithAdminAccess getOppDetailsWithUserAccess(Id recId){
                
        oppWithAdminAccess objOppAccess = new oppWithAdminAccess();
        objOppAccess.opp = [SELECT Id,PIP_Contact_Name__c,PIP_Contact_Phone__c,
                              Inspection_Reason__c,Inspection_Type__c,Split_Property__c,Management_Probability__c,probability,Openings_Probability__c , Managed_Franchised__c,Region_and_Sub_Region__c,StageName,Owner.Phone,Owner.Email,Current_Brand__c,
                              Opportunity_Number__c,Name,Anticipated_Room_Count__c,Anticipated_Opening_Date__c,Account.Name,Originating_Account__c,Property_Street__c,Property_City__c,
                              Property_State_Province__c,Intl_Property_State_Province__c,Property_Country__c,Property_Zip_Postal_Code__c,CloseDate,Owner.Name,Deal_Type__c
                              FROM Opportunity
                              WHERE Id=:recId LIMIT 1];
        objOppAccess.oppBrandSize = [SELECT Id,Opportunity__c, Request_PIP__c FROM Opportunity_Brand__c Where Opportunity__c=:recId AND Request_PIP__c =true LIMIT 50000].size();
		objOppAccess.access = Sales_Configuration_Settings__c.getInstance().Send_to_Legacy_Override__c;
        return objOppAccess;
    }
    
    /**
    * Description: Number of Opportunity Brands requested for Opportunity
    * @MethodName: getOppBrandSize
    * @Created by: Vazeer Mohammed
    * @parameters: Id recId
    * @return: Void
    */
    @AuraEnabled
    public static Integer getOppBrandSize(Id recId){
        return [SELECT Id FROM Opportunity_Brand__c WHERE Opportunity__c=:recId AND Request_Opportunity__c=true].size();
    }
    
    /**
    * Description: This will return the Access token which requires to Send the Request to Legacy
    * @MethodName: returnAccessToken
    * @Created by: Vazeer Mohammed
    * @parameters:
    * @return: String
    */
    public static String returnAccessToken(){
        String reqbody = ConstantClass.REQBODY+clientId+ConstantClass.REQCLIENTSECRET+clientSecret+ConstantClass.REQUSERNAME+username+ConstantClass.REQPASSWORD+password;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod(ConstantClass.POST);
        req.setEndPoint(ConstantClass.CALLOUT1+ConstantClass.CALLOUT2);        
        HttpResponse res = h.send(req);
        deserializeAccessTokenResponse resp1 = (deserializeAccessTokenResponse)JSON.deserialize(res.getbody(),deserializeAccessTokenResponse.class);
        return resp1.access_token;
    }
    
    /**
    * Description: Opportunity Integration
    * @MethodName: sendToLegacy
    * @Created by: Vazeer Mohammed
    * @parameters: Id recId
    * @return: Void
    */
    @AuraEnabled
    public static String sendToLegacy(Id recId){
        return genericMethodForOpportunityIntegration(recId);
    }

    /**
    * Description: Opportunity Integration
    * @MethodName: updateManagementProbability
    * @Created by: Vazeer Mohammed
    * @parameters: List<Opportunity> oppList
    * @return: Void
    */
    public static void updateManagementProbability(List<Opportunity> oppList){
        for(Opportunity objOpp:oppList){
            if(objOpp.StageName == ConstantClass.CLOSEDWON){
                objOpp.Management_Probability__c= ConstantClass.NUMERIC_100;
            }else if(objOpp.StageName == ConstantClass.CLOSEDLOST){
                objOpp.Management_Probability__c= ConstantClass.NUMERIC_0;
            }
        }
    }
    
        /**
    * Description: Opportunity Integration
    * @MethodName: updateStagetoClosedWon
    * @Created by: JZ
    * @parameters: List<Opportunity> oppList
    * @return: Void
    */
    public static void updateStagetoClosedWon(List<Opportunity> oppList){
        for(Opportunity objOpp:oppList){
            if (!String.isEmpty(objOpp.ContractId))
            {
                list<contract> ctList = [select Execution_Date__c, Status__c from contract where id=:objOpp.ContractId];
             if(ctList.size()>0)
             {
            if( (objOpp.StageName == ConstantClass.CONTRACTING || objOpp.StageName == ConstantClass.CONTRACTSIGNED ) && 
               (ctList[0].status__c ==4 || ctList[0].status__c ==5 || ctList[0].status__c ==6 || ctList[0].status__c ==7)   
              )
            {
                objOpp.StageName= ConstantClass.CLOSEDWON;
                objOpp.CloseDate = ctList[0].Execution_Date__c;
              }
               } 
            }    
      }
    }
    
    /**
    * Description: Opportunity Integration
    * @MethodName: calloutToLegacySalesforce
    * @Created by: Vazeer Mohammed
    * @parameters: Id
    * @return: Void
    */
    @future(callout=true)
    public static void calloutToLegacySalesforce(Id oppId){
        genericMethodForOpportunityIntegration(oppId);
        
        Opportunity objOpp = new Opportunity(Id=oppId);
        objOpp.Is_Processing__c = false;
        Database.update(objOpp);
    }
    
    /**
    * Description: Generic Method for Request body and response
    * @MethodName: genericMethodForOpportunityIntegration
    * @Created by: Vazeer Mohammed
    * @parameters: Id
    * @return: Void
    */
    public static String genericMethodForOpportunityIntegration(Id recId){
        Map<String,String> objOppRefPIPrefMap = new Map<String,String>();
        List<operationsRequest> operationsList = new List<operationsRequest>();
        List<Opportunity_Brand__c> oppBrandUpdList = new List<Opportunity_Brand__c>();
        List<Integration_Service__c> intSerList = new List<Integration_Service__c>();
        operationsRequest oppIntHan;
        oppResponse resp1;
        String status;
        HttpResponse res;
        try{
            List<Opportunity_Brand__c> oppBrandDataList = 
                new List<Opportunity_Brand__c>([Select Id,Name,Opportunity__r.Opportunity_Number__c,Opportunity__r.Name,Opportunity__r.Account.Name,Opportunity__r.AccountId,Opportunity__r.StageName,
                                                                                          Opportunity__r.Anticipated_Opening_Date__c,Opportunity__r.Anticipated_Room_Count__c,Opportunity__r.CloseDate,
                                                                                          Opportunity__r.Property_Street__c, Opportunity__r.Property_City__c,Opportunity__r.Property_Country__c, Opportunity__r.Property_State_Province__c, Opportunity__r.Intl_Property_State_Province__c,Opportunity__r.Property_Zip_Postal_Code__c,
                                                                                          toLabel(Opportunity__r.Deal_Type__c),Opportunity__r.Current_Brand__c,Opportunity__r.PIP_Contact_Name__c, Opportunity__r.PIP_Contact_Phone__c, Opportunity__r.Inspection_Type__c, Opportunity__r.Inspection_Reason__c, Opportunity__r.Split_Property__c,
                                                                                          Opportunity__r.Management_Probability__c, Opportunity__r.Probability,Opportunity__r.Openings_Probability__c , Opportunity__r.Managed_Franchised__c,Opportunity__r.Region_and_Sub_Region__c,
                                                                                          Opportunity__r.Owner.Name,Opportunity__r.Owner.Email,Opportunity__r.Owner.Phone,
                                                                                          PIP_Ref_Number__c,Opportunity_Ref_Number__c,Request_Opportunity__c,Request_PIP__c,Primary__c,Product__r.ProductCode,PIP_Request_Comments__c
                                                                                          FROM Opportunity_Brand__c 
                                                                                          Where Opportunity__c =: recId 
                                                                                          AND Request_Opportunity__c=true
                                                                                          LIMIT 50000]);
            for(Opportunity_Brand__c objOppBrand : oppBrandDataList){
                oppIntHan = new operationsRequest();
                oppIntHan.oppNumber = objOppBrand.Opportunity__r.Opportunity_Number__c;
                oppIntHan.oppName = objOppBrand.Opportunity__r.Name;
                oppIntHan.accountName = objOppBrand.Opportunity__r.Account.Name;
                oppIntHan.accountId = objOppBrand.Opportunity__r.AccountId;
                oppIntHan.stageName = objOppBrand.Opportunity__r.StageName;
                oppIntHan.anticipatedOpenDate =  String.isBlank(String.valueOf(objOppBrand.Opportunity__r.Anticipated_Opening_Date__c)) ? '' : String.valueOf(objOppBrand.Opportunity__r.Anticipated_Opening_Date__c);                              
                oppIntHan.anticipatedRoomCnt = String.isBlank(String.valueOf(objOppBrand.Opportunity__r.Anticipated_Room_Count__c)) ? '' : String.valueOf(objOppBrand.Opportunity__r.Anticipated_Room_Count__c);
                oppIntHan.closedDate =  String.isBlank(String.valueOf(objOppBrand.Opportunity__r.CloseDate)) ? '' : String.valueOf(objOppBrand.Opportunity__r.CloseDate);
                oppIntHan.propertyStreet = String.isBlank(objOppBrand.Opportunity__r.Property_Street__c) ? '' : objOppBrand.Opportunity__r.Property_Street__c;
                oppIntHan.propertyCity = String.isBlank(objOppBrand.Opportunity__r.Property_City__c) ? '' : objOppBrand.Opportunity__r.Property_City__c;
                oppIntHan.propertyState = String.isBlank(objOppBrand.Opportunity__r.Property_State_Province__c) ? (String.isBlank(objOppBrand.Opportunity__r.Intl_Property_State_Province__c) ? '' : objOppBrand.Opportunity__r.Intl_Property_State_Province__c ) : objOppBrand.Opportunity__r.Property_State_Province__c;
                oppIntHan.propertyCountry = String.isBlank(objOppBrand.Opportunity__r.Property_Country__c) ? '' : objOppBrand.Opportunity__r.Property_Country__c;
                oppIntHan.propertyZip = String.isBlank(objOppBrand.Opportunity__r.Property_Zip_Postal_Code__c) ? '' : objOppBrand.Opportunity__r.Property_Zip_Postal_Code__c;
                oppIntHan.dealType = String.isBlank(objOppBrand.Opportunity__r.Deal_Type__c) ? '' : objOppBrand.Opportunity__r.Deal_Type__c;
                oppIntHan.pipRequestComments = String.isBlank(objOppBrand.PIP_Request_Comments__c) ? '' : objOppBrand.PIP_Request_Comments__c;
                oppIntHan.oppOwnerPhone = String.isBlank(objOppBrand.Opportunity__r.Owner.Phone) ? '' : objOppBrand.Opportunity__r.Owner.Phone;
                oppIntHan.oppOwnerEmail = objOppBrand.Opportunity__r.Owner.Email;
                oppIntHan.currentBrand = String.isBlank(objOppBrand.Opportunity__r.Current_Brand__c) ? '' : objOppBrand.Opportunity__r.Current_Brand__c;                                      
                oppIntHan.contactName = String.isBlank(objOppBrand.Opportunity__r.PIP_Contact_Name__c) ? '' : objOppBrand.Opportunity__r.PIP_Contact_Name__c;
                oppIntHan.contactPhone = String.isBlank(objOppBrand.Opportunity__r.PIP_Contact_Phone__c) ? '' : objOppBrand.Opportunity__r.PIP_Contact_Phone__c;
                oppIntHan.inspectionType = String.isBlank(objOppBrand.Opportunity__r.Inspection_Type__c) ? '' : objOppBrand.Opportunity__r.Inspection_Type__c;
                oppIntHan.inspectionReason = String.isBlank(objOppBrand.Opportunity__r.Inspection_Reason__c) ? '' : objOppBrand.Opportunity__r.Inspection_Reason__c;
                oppIntHan.splitProperty= String.isBlank(objOppBrand.Opportunity__r.Split_Property__c) ? '' : objOppBrand.Opportunity__r.Split_Property__c;
                oppIntHan.oppOwner = objOppBrand.Opportunity__r.Owner.Name;
                oppIntHan.probability = String.isBlank(objOppBrand.Opportunity__r.Management_Probability__c) ? '' : objOppBrand.Opportunity__r.Management_Probability__c.removeEnd('%');
                oppIntHan.probabilitySystem = objOppBrand.Opportunity__r.Probability ==null ? '' : string.valueof(objOppBrand.Opportunity__r.Probability) ;
                oppIntHan.probabilityOpen = String.isBlank(objOppBrand.Opportunity__r.Openings_Probability__c) ? '' : objOppBrand.Opportunity__r.Openings_Probability__c.removeEnd('%');

                
                oppIntHan.region = String.isBlank(objOppBrand.Opportunity__r.Region_and_Sub_Region__c) ? '' : objOppBrand.Opportunity__r.Region_and_Sub_Region__c;
                oppIntHan.managedFranchised = String.isBlank(objOppBrand.Opportunity__r.Managed_Franchised__c) ? '' : objOppBrand.Opportunity__r.Managed_Franchised__c;
                oppIntHan.primary = objOppBrand.Primary__c ? '1' : '0';
                oppIntHan.oppBrandLine = objOppBrand.Name;
                oppIntHan.brandCode = objOppBrand.Product__r.ProductCode;
                oppIntHan.requestOpp = objOppBrand.Request_Opportunity__c ? '1' : '0';
                oppIntHan.requestPIP = objOppBrand.Request_PIP__c ? '1' : '0';
                oppIntHan.legacyOppId = String.isBlank(objOppBrand.Opportunity_Ref_Number__c) ? '' : objOppBrand.Opportunity_Ref_Number__c;
                oppIntHan.legacyPIPId = String.isBlank(objOppBrand.PIP_Ref_Number__c) ? '' : objOppBrand.PIP_Ref_Number__c;
                operationsList.add(oppIntHan);
            }
            
            OppRequest objOppRequest = new OppRequest();
            objOppRequest.operationsRequest = operationsList;
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setBody(json.serializepretty(objOppRequest));
            req.setMethod(ConstantClass.POST);
            req.setHeader(ConstantClass.AUTHORIZATION, ConstantClass.BEARER+ ReturnAccessToken());
            req.setHeader(ConstantClass.CONTENTTYPE1, ConstantClass.APPJSON);
            req.setTimeout(10000);
            req.setEndpoint(Wyndham_Constants_List__c.getInstance(ConstantClass.LEGACYENDPOINT).Value__c+ConstantClass.POSTOPPORTUNITY);
            res = h.send(req);
            
            Integration_Service__c objIntSer = new Integration_Service__c();
            objIntSer.Opportunity__c = recId;
            objIntSer.Request__c = json.serializepretty(objOppRequest);
            objIntSer.Integration_Name__c = ConstantClass.OPERATIONSREQUEST;
            
            if(res.getStatusCode()==200){
                resp1 = (oppResponse)JSON.deserialize(res.getbody(),oppResponse.class);
                objIntSer.Status__c = resp1.operationsResponse.status;
                status = ConstantClass.SUCCESS;
                if(objIntSer.Status__c==ConstantClass.STATUSERROR){
                    status = ConstantClass.LEGACYERROR;
                    objIntSer.Error_Code__c = resp1.operationsResponse.errCode;
                    objIntSer.Error_Message__c = resp1.operationsResponse.errMessage;
                }
                if(resp1.lineItemsResponse!=null){
                    for(LineItemsResponse objLineItems: resp1.lineItemsResponse){
                        objOppRefPIPrefMap.put(objLineItems.oppBrandLine, objLineItems.legacyOppId+ConstantClass.UNDERSCORE+objLineItems.legacyPIPId);
                    }
                    for(Opportunity_Brand__c objOppBrand : oppBrandDataList){
                        if(objOppRefPIPrefMap.containsKey(objOppBrand.Name) && objOppRefPIPrefMap.get(objOppBrand.Name)!=null){
                            if(objOppBrand.Opportunity_Ref_Number__c==null && objOppRefPIPrefMap.get(objOppBrand.Name).substringBefore(ConstantClass.UNDERSCORE)!=null){
                                objOppBrand.Opportunity_Ref_Number__c=objOppRefPIPrefMap.get(objOppBrand.Name).substringBefore(ConstantClass.UNDERSCORE);
                            }
                            if(objOppBrand.PIP_Ref_Number__c==null && objOppRefPIPrefMap.get(objOppBrand.Name).substringAfter(ConstantClass.UNDERSCORE)!=null){
                                objOppBrand.PIP_Ref_Number__c=objOppRefPIPrefMap.get(objOppBrand.Name).substringAfter(ConstantClass.UNDERSCORE);
                            }
                            oppBrandUpdList.add(objOppBrand);
                        }
                    }
                    if(!oppBrandUpdList.isEmpty()){
                        Database.SaveResult[] updateOppBrandList= Database.update(oppBrandUpdList,False);
                        ExceptionHandler.logHandledExceptions(updateOppBrandList,ConstantClass.OPPORTUNITYTRIGGERHELPER,ConstantClass.UPDATEPIPOPPREF,ConstantClass.OPPORTUNITY_MANAGEMENT);
                    }
                }
            }
            
            if(objIntSer.Status__c==null){
                objIntSer.Status__c=ConstantClass.ERROR;
                status = ConstantClass.REQUESTERROR;
            }
            if(res !=null){
                objIntSer.Response__c = res.getbody();
                objIntSer.Return_Status__c = res.getStatus();
                objIntSer.Return_Code__c = String.valueOf(res.getStatusCode());
            }
            intSerList.add(objIntSer);
            
            if(!intSerList.isEmpty()){
                Database.SaveResult[] insIntSerList= Database.insert(intSerList,False);
                ExceptionHandler.logHandledExceptions(insIntSerList,ConstantClass.OPPORTUNITYTRIGGERHELPER,ConstantClass.INSERTINTSERVICE,ConstantClass.OPPORTUNITY_MANAGEMENT);
            }
            
            if(status==ConstantClass.LEGACYERROR && objIntSer.Id != null){
                String recordLink = URL.getSalesforceBaseUrl().toExternalForm()+ConstantClass.SLASH+ objIntSer.Id;
                FeedItem objFi= new FeedItem();
                objFi.body=ConstantClass.ERROR1 +recordLink+ConstantClass.ERROR2;
                objFi.parentId= Wyndham_Constants_List__c.getInstance(ConstantClass.ADMINCHATTER).Value__c;
                Database.insert(objFi);
            }
        }catch(exception ex){
            ExceptionHandler.logHandledExceptions(ex,ConstantClass.OPPORTUNITYTRIGGERHELPER,ConstantClass.GENERICMETHOD,ConstantClass.OPPORTUNITY_MANAGEMENT);          
        }
        return status;
    }
}