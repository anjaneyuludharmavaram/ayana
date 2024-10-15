@RestResource(urlMapping='/srnheader/*')
global class SRNHeaderService {
 
    @HttpPost
    global static String createSRNHeader() {
        
        RestRequest req = RestContext.request;
        System.debug(req.requestBody);
        return 'success';
    }
}