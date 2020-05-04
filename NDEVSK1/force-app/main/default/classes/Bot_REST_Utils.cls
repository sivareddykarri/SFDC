/***
@Author : Vazeer
@Name   : Bot_REST_Utils
@Created Date: 8/27/2019
@Description: Util Class to support Bot_CheckAgentAvailability
@Version:0.1
@Reference: 
**/ 
public with sharing class Bot_REST_Utils {
    public static Boolean getButtonAvailablityForTransfer(String sBotOrgId,String sBotTransferButtonId,String sBotDeploymentId){
        Boolean isAvailable =  false;
        
        String sOrgId = sBotOrgId.substring(0, 15);
      	String sButtonId = sBotTransferButtonId.substring(0, 15);
        String sDeploymentId = sBotDeploymentId.substring(0, 15);
        
        String sPath = 'callout:Bot_Live_Agent_REST'+ConstantClass.PATH+sOrgId+ConstantClass.PATH1+sDeploymentId+ConstantClass.PATH2+sButtonId;
        //String sPath = 'https://d.la2-c2cs-dfw.salesforceliveagent.com/chat/rest/Visitor/Availability?org_id=00D6C0000009TZm&deployment_id=5721I000000hARo&Availability.ids=5736C000000002b';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(sPath);
        request.setMethod(ConstantClass.GET);
        request.setHeader(ConstantClass.LIVEAGENT, ConstantClass.LIVE);
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {     
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == ConstantClass.TEXT)) {
                    // Get the value.
                    parser.nextToken();
                    isAvailable = parser.getBooleanValue();
                    if (isAvailable == null) {
                        isAvailable = false;
                    }
                }
            }
        }
        return isAvailable;
    }
}