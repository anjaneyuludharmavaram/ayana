@RestResource(urlMapping='/vendor/*')
global class VendorService {
    
    @HttpPost
    global static String createVendor() {
        
            RestRequest req = RestContext.request;
            String jsonString = req.requestBody.toString();
            System.debug('JSON :: '+jsonString);
            Map<String, Object> vendorData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            System.debug('keys :: '+vendorData.keySet());
            System.debug(vendorData); 
            
            if (vendorData.containsKey('Vendor Detail')) {
                List<Object> vendorDetailsList = (List<Object>) vendorData.get('Vendor Detail');
                List<Account> accountsList = new List<Account>();
                
                for (Object vendorDetail : vendorDetailsList) {
                    Map<String, Object> vendorDetailMap = (Map<String, Object>) vendorDetail;
                    System.debug('Vendor Detail>>>' + vendorDetailMap);
                    
                    String vendorNo = (String) vendorDetailMap.get('No.');
                    String accountName = (String) vendorDetailMap.get('Name');
                    String address = (String) vendorDetailMap.get('Address');
                    String address2 = (String) vendorDetailMap.get('Address 2');
                    String city = (String) vendorDetailMap.get('City');
                    String contact = (String) vendorDetailMap.get('Contact');
                    String phoneNo = (String) vendorDetailMap.get('Phone No.');
                    String paymentTermsCode = (String) vendorDetailMap.get('Payment Terms Code');
                    String countryRegionCode = (String) vendorDetailMap.get('Country/Region Code');
                    String blocked = ''+vendorDetailMap.get('Blocked');
                    String paymentMethodCode = (String) vendorDetailMap.get('Payment Method Code');
                    String postCode = (String) vendorDetailMap.get('Post Code');
                    String email = (String) vendorDetailMap.get('Email');
                    String gstRegNo = (String) vendorDetailMap.get('GST Registration No.');
                    String gstVendorType = (String) vendorDetailMap.get('GST Vendor Type');
                    String assessesCode = (String) vendorDetailMap.get('Assesses Code');
                    String panNo = (String) vendorDetailMap.get('P.A.N. No.');
                    String panStatus = ''+ vendorDetailMap.get('P.A.N. Status');
                    String stateCode = (String) vendorDetailMap.get('State Code');
                    String createdBy = (String) vendorDetailMap.get('Created By');
                    String lastModifiedBy = (String) vendorDetailMap.get('Last Modified By');
                    String supplierCategory = ''+vendorDetailMap.get('Supplier Category');
                    String status = ''+ vendorDetailMap.get('Status');
                    String panAadhaarLinkingStatus = ''+ vendorDetailMap.get('PAN Aadhaar Linking Status');
                    String tradeName = (String) vendorDetailMap.get('Trade Name');
                    String creationDate = (String) vendorDetailMap.get('Creation Date');
                    Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                    Account acc = new Account(
                        RecordTypeId = vendorRecordTypeId,
                        Name = accountName,
                        Phone = phoneNo,
                        BillingCity = city,
                        BillingStreet = address + ' ' + address2,
                        BillingPostalCode = postCode,
                        Email__c = email, 
                        GST_Registration_No__c = gstRegNo, 
                        P_A_N_No__c  = panNo,
                        No__c = vendorNo, 
                        Payment_Terms_Code__c  = paymentTermsCode, 
                        Payment_Method_Code__c  = paymentMethodCode, 
                        GST_Vendor_Type__c = gstVendorType, 
                        Assessee_Code__c  = assessesCode, 
                        P_A_N_Status__c = panStatus, 
                        State_Code__c = stateCode, 
                        Supplier_Category__c  = supplierCategory, 
                        PAN_Adhaar_Linking_Status__c  = panAadhaarLinkingStatus, 
                        Trade_Name__c = tradeName 
                    );
                    
                    accountsList.add(acc);
                }
                
                if (!accountsList.isEmpty()) {
                    upsert accountsList No__c;
                    accountsList[0].isPartner = true;
                    upsert accountsList;
                    return 'Account(s) created successfully';
                } else {
                    return 'No valid vendor details found';
                }
            }
            
            return 'Invalid JSON';
       
    }
}