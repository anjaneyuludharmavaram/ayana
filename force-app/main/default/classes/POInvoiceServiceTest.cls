@IsTest
private class POInvoiceServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create Account (Vendor)
        // 
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account vendor = new Account(Name = 'Portal Test Account',Email__c = 'anjaneyulu@areya.tech',RecordTypeId = vendorRecordTypeId);
        insert vendor;
        Contact cnt = new Contact(LastName = 'test', AccountId = vendor.Id,Email='anjaneyulu@areya.tech',FirstName='Test first');
        insert cnt;
      
        system.debug(cnt.Id+' Id FROM Profile '+[SELECT Id,Name,ContactId FROM USER WHERE AccountId =: vendor.Id]);
        // Create Purchase Order Invoice
        Purchase_Order_Invoice__c invoice = new Purchase_Order_Invoice__c(
            Invoice_Number__c = 'IN1234',
            Vendor__c = vendor.Id,
            UTR__c = 'UTR12434',
            Invoice_Status__c = 'SRN Generated',
            Invoice_Date__c = System.today()
        );
        insert invoice;
    }

    @IsTest
    static void testCreatePOInvoiceSuccess() {
        Purchase_Order_Invoice__c invoiceRec = [SELECT Id,Name FROM Purchase_Order_Invoice__c LIMIT 1];
        // Create mock REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/invoice/';
        req.httpMethod = 'POST';

        // Set request body with correct data
        req.requestBody = Blob.valueOf('{"Invoice Details":[{"Invoice Number":"BP/2425/0000729","Name":"TELNET SPACE","Sales Force ID":"'+invoiceRec.Name+'","UTR":"UTR123","Name": "Portal Test Account"}]}');
        RestContext.request = req;
        RestContext.response = res;
        
        // Call the method
        String result = POInvoiceService.createPOInvoice();
        
        // Verify that the method returned success
        System.assertEquals('success', result);

        // Verify the Purchase_Order_Invoice__c record was updated correctly
        Purchase_Order_Invoice__c updatedInvoice = [SELECT Id, Invoice_Number__c, UTR__c, Invoice_Status__c, Vendor__c FROM Purchase_Order_Invoice__c LIMIT 1];
        System.assertEquals('BP/2425/0000729', updatedInvoice.Invoice_Number__c);
        System.assertEquals('UTR123', updatedInvoice.UTR__c);
    }

    @IsTest
    static void testCreatePOInvoiceSalesforceIdNotFound() {
        // Create mock REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/invoice/';
        req.httpMethod = 'POST';

        // Set request body with missing Sales Force ID
        req.requestBody = Blob.valueOf('{"Invoice Details":[{"Invoice Number":"BP/2425/0000729","Name":"TELNET SPACE","Sales Force ID":"","UTR":"UTR123","Status":"SRN Generated"}]}');
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        String result = POInvoiceService.createPOInvoice();

        // Verify that the method returned the correct error message
        System.assertEquals('Salesforce Id is not found', result);
    }
}