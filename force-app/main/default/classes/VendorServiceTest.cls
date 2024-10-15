@IsTest
private class VendorServiceTest {
    
    @IsTest
    static void testCreateVendor_Success() {
        String mockJson = '{' +
            '"Vendor Detail": [' +
            '{' +
            '"No.": "V001",' +
            '"Name": "Vendor 1",' +
            '"Address": "123 Vendor St",' +
            '"Address 2": "Suite 100",' +
            '"City": "San Francisco",' +
            '"Phone No.": "1234567890",' +
            '"Payment Terms Code": "NET30",' +
            '"Country/Region Code": "US",' +
            '"Email": "vendor1@example.com",' +
            '"GST Registration No.": "GST001",' +
            '"GST Vendor Type": "Registered",' +
            '"P.A.N. No.": "PAN001",' +
            '"P.A.N. Status": "PAN APPLIED",' +
            '"State Code": "CA",' +
            '"Supplier Category": "MSME Vendors",' +
            '"PAN Aadhaar Linking Status": "Yes-Operative",' +
            '"Trade Name": "Vendor 1 Trade",' +
            '"Post Code": "94105"' +
            '}' +
            ']' +
            '}';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(mockJson);
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String response = VendorService.createVendor();
        Test.stopTest();

        System.assertEquals('Account(s) created successfully', response);

        List<Account> createdAccounts = [SELECT Name, Phone, BillingCity, GST_Registration_No__c FROM Account WHERE Name = 'Vendor 1'];
        System.assertEquals(1, createdAccounts.size());
        System.assertEquals('Vendor 1', createdAccounts[0].Name);
        System.assertEquals('1234567890', createdAccounts[0].Phone);
        System.assertEquals('San Francisco', createdAccounts[0].BillingCity);
        System.assertEquals('GST001', createdAccounts[0].GST_Registration_No__c);
    }
    
    @IsTest
    static void testCreateVendor_InvalidJSON() {
        String invalidJson = '{"Invalid Key": []}';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(invalidJson);
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String response = VendorService.createVendor();
        Test.stopTest();
        System.assertEquals('Invalid JSON', response);
    }
    
    @IsTest
    static void testCreateVendor_NoVendorDetails() {
        String emptyVendorDetailsJson = '{"Vendor Detail": []}';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(emptyVendorDetailsJson);
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        String response = VendorService.createVendor();
        Test.stopTest();

        System.assertEquals('No valid vendor details found', response);
    }
    
    
}