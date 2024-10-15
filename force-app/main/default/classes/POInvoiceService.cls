@RestResource(urlMapping='/invoice/*')
global without sharing class POInvoiceService {
    
    @HttpPost
    global static String createPOInvoice() {
        //{"Invoice Details":[{"Invoice Number":"BP/2425/0000729","Name":"TELNET SPACE","Sales Force ID":"INV-0000008","UTR":"","Status":"SRN Generated"}]}
        RestRequest req = RestContext.request;
        String jsonString = req.requestBody.toString();
        jsonString = jsonString.substringAfter(':[');
        jsonString = jsonString.removeEnd(']}'); 
        System.debug('jsonString :: '+jsonString);
        Map<String, Object> invoiceData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        if((String) invoiceData.get('Sales Force ID') != ''){
            String accountName = (String) invoiceData.get('Name');
            List<Account> vendor = new List<Account>([Select Id,Name from Account where Name =:accountName limit 1]);
            String buyFromVendorNo = (String) invoiceData.get('Sales Force ID');
            Purchase_Order_Invoice__c invoice = [SELECT Id FROM Purchase_Order_Invoice__c where Name =:buyFromVendorNo limit 1];
            invoice.Invoice_Number__c = (String) invoiceData.get('Invoice Number');
            invoice.Vendor__c = vendor[0].Id;
            invoice.UTR__c = (String) invoiceData.get('UTR');
            invoice.Invoice_Status__c  = (String) invoiceData.get('Status');
            
            update invoice;
            
            
            return 'success';
        }else{
            return 'Salesforce Id is not found';
        }
    }
}