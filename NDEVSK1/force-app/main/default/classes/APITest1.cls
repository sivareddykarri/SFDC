//APEX Callout 
//Testing API & Integration to an External System
//Decimal ConvertedAmt = APITest1.CurrencyConverterINR(100);
//System.Debug(ConvertedAmt);
public class APITest1 
{
	public static Decimal CurrencyConverterINR(Decimal input)
    {
        Decimal inr = 0.0;
        
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('https://api.exchangeratesapi.io/latest');
        req.setMethod('GET');
        
        HTTPResponse res = h.send(req);
        
        Map<String,Object> jsonBody = (Map<String,Object>) Json.deserializeUntyped(res.getBody());
        
        System.debug(jsonBody);
        
        Map<String,Object> nMap = (Map<String,Object>) jsonBody.get('rates');
        
        Decimal conversionRate = (Decimal) nMap.get('INR');
        
        inr = input * conversionRate ;
        
        return inr ;
                                  
    }
}