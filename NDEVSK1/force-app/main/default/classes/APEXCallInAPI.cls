//APEX Call In - API in SFDC org
//
@RestResource(urlMapping = '/AcctData/')
global class APEXCallInAPI 
{
	@HTTPPost
    global static String doPost()
    {
        String fieldValue;
        String fieldName;
        String AcctName;
        String AcctSite;
        
        //List<String> AcctList = new String[3];
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        system.debug('Param is ;' + req.params);
        system.debug('Param is :' + req.requestBody);
        
        String arr = req.requestBody.toString();
        
        JSONParser parser = JSON.createParser(arr);
        
        while(parser.nextToken()!=null)
        {
            if(parser.getCurrentToken()!=JSONToken.END_OBJECT)
            {
                parser.nextValue();
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                
               	if(fieldName == 'Name')
                {
                    AcctName = parser.getText();
                }
                else if(fieldName == 'Site')
                {
                    AcctSite = parser.getText();
                }
             }
        }
        
        Account accNew = new Account(Name=AcctName,Site=AcctSite);
        insert accNew;
        
        return accNew.Id;
        
    }
    
}