@RestResource(urlMapping='/polines/*')
global class POLinesService {
 
    @HttpPost
    global static String createPOLines() {
        
        RestRequest req = RestContext.request;
        System.debug(req.requestBody);
        return 'success';
    }
}