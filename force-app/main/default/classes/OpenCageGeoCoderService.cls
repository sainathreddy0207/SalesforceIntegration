public class OpenCageGeoCoderService {
    
    public static void reverseGeoCoding(String accountId){
        
        Account accRec = [Select Id, Location__latitude__s, Location__longitude__s  from Account
                          where id=:accountId AND Location__latitude__s!=null  AND Location__longitude__s!=null LIMIT 1];
        
        String queryParams = accRec.Location__latitude__s+','+accRec.Location__longitude__s;
        System.debug('testing the qeryparams'+queryParams);
        
        Http http = new Http();
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndPoint(System.Label.Open_Cage_API_URL+'?key='+System.Label.OPENCAGE_API_KEY+'&q='+queryParams+'&pretty=1');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setMethod('GET');
        
        try{
            HttpResponse httpRes = http.send(httpReq);
            String responseBody = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            if(statusCode == 200){
                //JSON Class Inside System NameSpace
                //deserialize ,deserializeUnTyped, deserializeStrict
                OpenCageReverseResponseWrapper wrapper = (OpenCageReverseResponseWrapper)System.JSON.deserialize(responseBody, OpenCageReverseResponseWrapper.class);
                if(wrapper?.results?.size()>0){ 
                    OpenCageReverseResponseWrapper.results rslts=wrapper.results.get(0);
                    
                    accRec.BillingCity = rslts?.components?.state_district;
                    update accRec;
                    
                    
                }
                
            }else{
                
            }
            
            
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
    
    public static void ForwardGeoCoding(String accountId){
        
        Account accRec = [SELECT Id, BillingStreet, BillingCity, BillingPostalCode, BillingCountry FROM Account
                          where id=:accountId LIMIT 1];
        
        
        String queryParams = accRec.BillingStreet+','+accRec.BillingPostalCode+' '+accRec.BillingCity+','+accRec.BillingCountry;
        String encodedQueryParams = EncodingUtil.urlEncode(queryParams, 'UTF-8');
        System.debug('testing the qeryparams'+queryParams);
        
        Http http = new Http();
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndPoint(System.Label.Open_Cage_API_URL+'?key='+System.Label.OPENCAGE_API_KEY+'&q='+encodedQueryParams);
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setMethod('GET');
        
        try{
            HttpResponse httpRes = http.send(httpReq);
            String responseBody = httpRes.getBody();
            Integer statusCode = httpRes.getStatusCode();
            if(statusCode == 200){
                //JSON Class Inside System NameSpace
                //deserialize ,deserializeUnTyped, deserializeStrict
                System.debug(responseBody);
                OpenCageForwardResponseWrapper wrapper = (OpenCageForwardResponseWrapper)System.JSON.deserialize(responseBody, OpenCageForwardResponseWrapper.class);
                system.debug('Wrapper'+ wrapper);
                
                if(wrapper != null && wrapper.results != null && wrapper.results.size() > 0){ 
                    OpenCageForwardResponseWrapper.results rslts = wrapper.results[0];
                    
                    accRec.Location__latitude__s = rslts?.geometry?.lat;
                    accRec.Location__longitude__s =  rslts?.geometry?.lng;
                    System.debug(accRec.Location__latitude__s+ accRec.Location__longitude__s);
                    update accRec;
                    
                    
                }
                
            }else{
                
            }
            
            
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