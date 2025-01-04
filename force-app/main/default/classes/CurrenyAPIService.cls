public with sharing class CurrenyAPIService {
    
    public static void getExchangeRates(){
        
        /* CallOuts Only*/
        Http http=  new Http();
        /* Step 1 - Prepare the request*/
        HttpRequest httpReq = new HttpRequest();
        /* Step 1.1 Set the EndPoint*/
        httpReq.setEndPoint('https://open.er-api.com/v6/latest/USD');
        /* Step 1.2 Set the Headers*/
        httpReq.setHeader('Content-Type','application/json');
        httpReq.setHeader('Accept','application/json'); // JSON,XML, Text,HTML Here the point is we will accept only JSON if there are mutliple response we need to consider json only
        /* Step1.3- Set the Method*/
        httpReq.setMethod('GET'); // GET,POST,PUT,PATCH,DELETE
        try{
            
            /*Step2- Send the Request*/
            
            
            HttpResponse httpRes = http.send(httpReq);
            /*HttP Response methods 
            * getStatus()
            * getStatusCode()
            * getBody()
            * getXmlStreamReader() ==> SOAP
            * getBodyAsBlod()
            */
            String responseBody = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            String status = httpRes.getStatus();
            System.debug('The Response from currency responseBody '+ responseBody );
            System.debug('The Response from currency statusCode '+ statusCode );
            System.debug('The Response from currency status '+ status );
            
        }catch(System.CalloutException calloutEx){
            
            if(String.valueOf(calloutEx).startsWith('System.CalloutException: Unauthorized endpoint')){
                //Remote Site Missing Error
                system.debug('callout Exceptipon '+calloutEx );
                
            }
            
        }catch(System.Exception ex){
            if(String.valueOf(ex).startsWith('System.CalloutException: Unauthorized endpoint')){
                system.debug('Sytem Exceptipon '+ex );
                //Error Log
            }           
        }
    }
    
    
    
}