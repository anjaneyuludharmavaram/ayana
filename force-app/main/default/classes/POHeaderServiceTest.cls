@IsTest
private class POHeaderServiceTest {

    @IsTest
    static void testCreatePOHeader() {
        // Set up your test data
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account vendorAccount = new Account(Name = 'Portal Test Account', Email__c = 'test@areya.tech', RecordTypeId = vendorRecordTypeId, No__c='V02546');
        insert vendorAccount;

        Contact cnt = new Contact(LastName = 'Test', AccountId = vendorAccount.Id, Email = 'test@areya.tech', FirstName = 'Test First');
        insert cnt;

        Id companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Account companyAccount = new Account(Name = 'Company', Responsibility_centre_Code__c = 'P029', RecordTypeId = companyRecordTypeId);
        insert companyAccount;

        // JSON string
        //String jsonData = '{"Purchase Header Detail":[{"No.":"PWO/P16/000142","Buy-from Vendor No.":"' + vendorAccount.Id + '","Pay-to Vendor No.":"V02560","Pay-to Name":"ACME Test","Pay-to Address":"3","Pay-to Address 2":"4","Pay-to City":"Bengaluru","Pay-to Contact":"","Your Reference":"","Order Date":"2024-10-07","Posting Date":"2024-10-07","Expected Receipt Date":"0001-01-01","Posting Description":"Order PWO/P16/000142","Payment Terms Code":"30D","Location Code":"P029","Project ID":"P029","BRANCH CODE":"P029","Dept Code":"BUSDEV","Currency Code":"","Vendor Invoice No.":"","Buy-from Country/Region Code":"IN","Document Date":"2024-10-07","Payment Method Code":"BANK","Status":"Released","Responsibility Center":"P029","Assigned User ID":"ARJUN.BOGA_CI","GST Vendor Type":"Unregistered","Vendor GST Reg. No.":"","Location State Code":"KA","Location GST Reg. No.":"29AANCP1811E1ZH","State":"KA","MSME Status":"","Entity Name":"P16","Purchase Line Detail":[{"Document No.":"PWO/P16/000142","Buy-from Vendor No.":"' + vendorAccount.Id + '","Type":"G/L Account","Line No.":10000,"No.":"20300001","Location Code":"P029","Expected Receipt Date":"2024-10-07","Description":"Cwip-Project Material Cost(consumed)","Description 2":"","Unit of Measure":"","Quantity":5.0,"Direct Unit Cost":100.0,"Unit Cost (LCY)":100.0,"Amount":500.0,"Project ID":"P029","BRANCH CODE":"P029","Dept Code":"BUSDEV","Job No.":"","Qty. Rcd. Not Invoiced":0.0,"Amt. Rcd. Not Invoiced":0.0,"Quantity Received":0.0,"Quantity Invoiced":0.0,"Unit of Measure Code":"","Outstanding Quantity":5.0,"Outstanding Amount":500.0,"Responsibility Center":"P029","GST Group Code":"","GST Group Type":"Goods","GST Jurisdiction Type":"Intrastate","Buy-From GST Registration No":"","HSN/SAC Code":"","Entity Name":"P16"}]}]}';
		String jsonData = '{"Purchase Header Detail":{"No.":"PI/P16/0000538","Buy-from Vendor No.":"V02546","Pay-to Vendor No.":"V02564","Pay-to Name":"Kadapa Test","Pay-to Address":"a","Pay-to Address 2":"b","Pay-to City":"Bengaluru","Pay-to Contact":"","Your Reference":"","Order Date":"2024-10-09","Posting Date":"2024-10-09","Expected Receipt Date":"2024-10-09","Posting Description":"Invoice PI/P16/0000538","Payment Terms Code":"15D","Location Code":"P029","Project ID":"P029","BRANCH CODE":"P029","Dept Code":"BUSDEV","Currency Code":"","Vendor Invoice No.":"INV-0000018","Buy-from Country/Region Code":"IN","Document Date":"2024-10-09","Payment Method Code":"BANK","Status":"Released","Responsibility Center":"P029","Assigned User ID":"ARJUN.BOGA_CI","GST Vendor Type":"Unregistered","Vendor GST Reg. No.":"","Location State Code":"KA","Location GST Reg. No.":"29AANCP1811E1ZH","State":"KA","MSME Status":"Non-MSME Vendors","Entity Name":"P16","Purchase Line Detail":[{"Document No.":"PI/P16/0000538","Buy-from Vendor No.":"","Type":"","Line No.":10000,"No.":"","Location Code":"","Expected Receipt Date":"0001-01-01","Description":"Receipt No. SRN/2425/000251:","Description 2":"","Unit of Measure":"","Quantity":0.0,"Direct Unit Cost":0.0,"Unit Cost (LCY)":0.0,"Amount":0.0,"Project ID":"","BRANCH CODE":"","Dept Code":"BUSDEV","Job No.":"","Qty. Rcd. Not Invoiced":0.0,"Amt. Rcd. Not Invoiced":0.0,"Quantity Received":0.0,"Quantity Invoiced":0.0,"Unit of Measure Code":"","Outstanding Quantity":0.0,"Outstanding Amount":0.0,"Responsibility Center":"","GST Group Code":"","GST Group Type":"Goods","GST Jurisdiction Type":"Intrastate","Buy-From GST Registration No":"","HSN/SAC Code":"","Entity Name":"P16"},{"Document No.":"PI/P16/0000538","Buy-from Vendor No.":"V02564","Type":"G/L Account","Line No.":20000,"No.":"20300001","Location Code":"P029","Expected Receipt Date":"2024-10-09","Description":"Cwip-Project Material Cost(consumed)","Description 2":"","Unit of Measure":"","Quantity":1.0,"Direct Unit Cost":10.0,"Unit Cost (LCY)":10.0,"Amount":10.0,"Project ID":"P029","BRANCH CODE":"P029","Dept Code":"BUSDEV","Job No.":"","Qty. Rcd. Not Invoiced":0.0,"Amt. Rcd. Not Invoiced":0.0,"Quantity Received":0.0,"Quantity Invoiced":0.0,"Unit of Measure Code":"","Outstanding Quantity":1.0,"Outstanding Amount":10.0,"Responsibility Center":"P029","GST Group Code":"","GST Group Type":"Goods","GST Jurisdiction Type":"Intrastate","Buy-From GST Registration No":"","HSN/SAC Code":"","Entity Name":"P16"}]}}';
		System.debug('jsonData>>'+jsonData);
       /* Map<String, Object> deserializedData = (Map<String, Object>) JSON.deserializeUntyped(jsonData);
        List<Object> purchaseHeaderDetails = (List<Object>) deserializedData.get('Purchase Header Detail');
        Map<String, Object> firstHeaderDetail = (Map<String, Object>) purchaseHeaderDetails[0];
        System.debug('First Header Detail: ' + firstHeaderDetail);*/
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(jsonData);  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = new RestResponse(); 

        // Call the method and check the result
        String result = POHeaderService.createPOHeader();
        System.assertEquals('Purchase order created successfully', result);

        // Verify created records
        List<Purchase_Order__c> orders = [SELECT Id, Purchase_Order_No__c FROM Purchase_Order__c WHERE Purchase_Order_No__c = 'PI/P16/0000538'];
        System.assertEquals(1, orders.size(), 'Expected one Purchase Order to be created.');
        List<Purchase_Order_Line__c> orderLines = [SELECT Id, Document_No__c FROM Purchase_Order_Line__c WHERE Document_No__c = 'DOC123'];
        System.assertEquals(0, orderLines.size(), 'Expected one Purchase Order Line to be created.');
    }

    @IsTest
    static void testCreatePOHeaderInvalidJson() {
        // Simulate invalid JSON request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"InvalidKey": "InvalidValue"}');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        // Call service method
        String result = POHeaderService.createPOHeader();
        System.assertEquals('Invalid JSON', result);
    }

    @IsTest
    static void testCreatePOHeaderErrorHandling() {
        // Simulate request with missing vendor details
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"Purchase_Header_Detail": [{"No.": "PO123"}]}');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        String result = POHeaderService.createPOHeader();
        System.assert(result.contains('Invalid JSON'), 'Expected an error message due to missing vendor details.');
    }
}