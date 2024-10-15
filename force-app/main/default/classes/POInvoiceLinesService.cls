@RestResource(urlMapping='/poinvoicelines/*')
global class POInvoiceLinesService {
 
    @HttpPost
    global static String createPOInvoiceLines() {
        
        RestRequest req = RestContext.request;
        System.debug(req.requestBody);
        return 'success';
    }
}