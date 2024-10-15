@RestResource(urlMapping='/srnlines/*')
global class SRNLinesService {
 
    @HttpPost
    global static String createSRNLines() {
        
        RestRequest req = RestContext.request;
        System.debug(req.requestBody);
        return 'success';
    }
}