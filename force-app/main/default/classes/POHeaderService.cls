@RestResource(urlMapping='/poheader/*')
global class POHeaderService {
    
    @HttpPost
    global static String createPOHeader() {
        
        RestRequest req = RestContext.request;
        String jsonString = req.requestBody.toString();
        System.debug('jsonString :: '+jsonString);


        Map<String, Object> poData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
System.debug('poData>>'+poData);
System.debug('poData>>'+poData.values()); 
 
System.debug(poData.keySet()); 

        Account company = null;
        if (poData.containsKey('Purchase Header Detail')) {
                       Map<String,Object> poHeaderDetailMap = (Map<String,Object>) poData.get('Purchase Header Detail'); // Correctly getting the list of Purchase Header Details
            List<Purchase_Order__c> orderList = new List<Purchase_Order__c>();

            
                // Convert dates from the JSON
                Date orderDateConverted = Date.valueOf((String) poHeaderDetailMap.get('Order Date'));
                Date postingDateConverted = Date.valueOf((String) poHeaderDetailMap.get('Posting Date'));
                Date expectedReceiptDateConverted = Date.valueOf((String) poHeaderDetailMap.get('Expected Receipt Date'));
                Date documentDateConverted = Date.valueOf((String) poHeaderDetailMap.get('Document Date'));
                
                // Lookup vendor and company accounts
                String buyFromVendorNo = (String) poHeaderDetailMap.get('Buy-from Vendor No.');
                String respCode = (String) poHeaderDetailMap.get('Responsibility Center');
                Account vendorAccount = [SELECT Id FROM Account WHERE No__c = :buyFromVendorNo LIMIT 1];
                company = [SELECT Id FROM Account WHERE Responsibility_centre_Code__c = :respCode LIMIT 1];

                // Create Purchase Order Header Record
                Purchase_Order__c order = new Purchase_Order__c(
                    Purchase_Order_No__c = (String) poHeaderDetailMap.get('No.'),
                    Buy_from_Vendor_No__c = vendorAccount.Id,
                    Pay_to_Vendor_No__c = (String) poHeaderDetailMap.get('Pay-to Vendor No.'),
                    Pay_to_Name__c = (String) poHeaderDetailMap.get('Pay-to Name'),
                    Pay_to_Address__c = (String) poHeaderDetailMap.get('Pay-to Address'),
                    Pay_to_Address_2__c = (String) poHeaderDetailMap.get('Pay-to Address 2'),
                    Pay_to_City__c = (String) poHeaderDetailMap.get('Pay-to City'),
                    Pay_to_Contact__c = (String) poHeaderDetailMap.get('Pay-to Contact'),
                    Your_Reference__c = (String) poHeaderDetailMap.get('Your Reference'),
                    Order_Date__c = orderDateConverted,
                    Posting_Date__c = postingDateConverted,
                    Posting_Description__c = (String) poHeaderDetailMap.get('Posting Description'),
                    Payment_Terms_Code__c = (String) poHeaderDetailMap.get('Payment Terms Code'),
                    Location_Code__c = (String) poHeaderDetailMap.get('Location Code'),
                    Project_ID__c = (String) poHeaderDetailMap.get('Project ID'),
                    Branch_Code__c = (String) poHeaderDetailMap.get('BRANCH CODE'),
                    Dept_Code__c = (String) poHeaderDetailMap.get('Dept Code'),
                    Currency_Code__c = (String) poHeaderDetailMap.get('Currency Code'),
                    Vendor_Invoice_No__c = (String) poHeaderDetailMap.get('Vendor Invoice No.'),
                    Buy_from_Country_Region_Code__c = (String) poHeaderDetailMap.get('Buy-from Country/Region Code'),
                    Document_Date__c = documentDateConverted,
                    Payment_Method_Code__c = (String) poHeaderDetailMap.get('Payment Method Code'),
                    Status__c = (String) poHeaderDetailMap.get('Status'),
                    Responsibility_Center__c = (String) poHeaderDetailMap.get('Responsibility Center'),
                    PO_Created_By__c = (String) poHeaderDetailMap.get('Assigned User ID'),
                    GST_Vendor_Type__c = (String) poHeaderDetailMap.get('GST Vendor Type'),
                    Vendor_GST_Reg_No__c = (String) poHeaderDetailMap.get('Vendor GST Reg. No.'),
                    Location_State_Code__c = (String) poHeaderDetailMap.get('Location State Code'),
                    Location_GST_Reg_No__c = (String) poHeaderDetailMap.get('Location GST Reg. No.'),
                    State__c = (String) poHeaderDetailMap.get('State'),
                    MSME_Status__c = (String) poHeaderDetailMap.get('MSME Status'),
                    Entity_Name__c = (String) poHeaderDetailMap.get('Entity Name'),
                    Vendor__c = vendorAccount.Id,
                    Company__c = company.Id,
                    Uniquey_Key__c = company.Id+'_'+(String) poHeaderDetailMap.get('No.'),
                    Assigned_User__c = (String) poHeaderDetailMap.get('Assigned User ID')
                );
                
                orderList.add(order);
            
            
            if (!orderList.isEmpty()) {
                upsert orderList Uniquey_Key__c;
                
                // Map to hold the Ids of the inserted Purchase_Order__c records
                Map<String, Id> poHeaderIdMap = new Map<String, Id>();
                for (Purchase_Order__c order1 : orderList) {
                    poHeaderIdMap.put(order1.Uniquey_Key__c, order1.Id);
                }
                
                List<Purchase_Order_Line__c> orderLineList = new List<Purchase_Order_Line__c>();
                
                    
                    if (poHeaderDetailMap.containsKey('Purchase Line Detail')) {
                        List<Object> poLineDetailsList = (List<Object>) poHeaderDetailMap.get('Purchase Line Detail');
                        
                        for (Object poLineDetail : poLineDetailsList) {
                            Map<String, Object> poLineDetailMap = (Map<String, Object>) poLineDetail;
                            System.debug('Purchase Line Detail>>>' + poLineDetailMap);
                            
                            Id poHeaderId = poHeaderIdMap.get(company.Id+'_'+(String) poHeaderDetailMap.get('No.'));
                            
                            // Create Purchase Order Line Record
                            Purchase_Order_Line__c orderLine = new Purchase_Order_Line__c(
                                PO_Header__c = poHeaderId,
                                Buy_from_Vendor_No__c = (String) poLineDetailMap.get('Buy-from Vendor No.'),
                                Document_No__c = (String) poLineDetailMap.get('Document No.'),
                                Line_No__c = String.valueOf(poLineDetailMap.get('Line No.')),
                                Description__c = (String) poLineDetailMap.get('Description'),
                                Unit_of_Measure__c = (String) poLineDetailMap.get('Unit of Measure'),
                                Quantity__c = (Decimal) poLineDetailMap.get('Quantity'),
                                Outstanding_Quantity__c = (Decimal) poLineDetailMap.get('Outstanding Quantity'),
                                Direct_Unit_Cost__c = String.valueOf(poLineDetailMap.get('Direct Unit Cost')),
                                Unit_Cost_LCY__c = String.valueOf(poLineDetailMap.get('Unit Cost (LCY)')),
                                Amount__c = String.valueOf(poLineDetailMap.get('Amount')),
                                Project_ID__c = (String) poLineDetailMap.get('Project ID (Dimension)'),
                                Outstanding_Amount__c = Decimal.valueOf(String.valueOf(poLineDetailMap.get('Outstanding Amount'))),
                                Responsibility_Center__c = (String) poLineDetailMap.get('Responsibility Center'),
                                Unique_Key__c  = poHeaderId+'_'+poLineDetailMap.get('Line No.')
                            );
                            
                            orderLineList.add(orderLine);
                        }
                    }
                
                
                if (!orderLineList.isEmpty()) {
                    upsert orderLineList Unique_Key__c ;
                }
                
                return 'Purchase order created successfully';
            } else {
                return 'No valid purchase order details found';
            }
        }
        
        return 'Invalid JSON';
    }
}