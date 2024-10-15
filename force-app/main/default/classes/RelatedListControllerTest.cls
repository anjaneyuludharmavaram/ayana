@isTest
public with sharing class RelatedListControllerTest {
    @isTest public static void testInit(){
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account vendor = new Account(Name = 'Portal Test Account',Email__c = 'anjaneyulu@areya.tech',RecordTypeId = vendorRecordTypeId);
        insert vendor;
        Contact cnt = new Contact(LastName = 'test', AccountId = vendor.Id,Email='anjaneyulu@areya.tech',FirstName='Test first');
        insert cnt;
                
        Map<String, Object> requestMap = new Map<String, Object>(); 
        requestMap.put(RelatedListController.FIELDS_PARAM, 'Name, Title, Email, Phone');
        requestMap.put(RelatedListController.RELATED_FIELD_API_NAME_PARAM, 'AccountId');
        requestMap.put(RelatedListController.RECORD_ID_PARAM, vendor.Id);
        requestMap.put(RelatedListController.NUMBER_OF_RECORDS_PARAM, 1);
        requestMap.put(RelatedListController.SOBJECT_API_NAME_PARAM, 'Contact');
        requestMap.put(RelatedListController.SORTED_BY_PARAM, 'Name');
        requestMap.put(RelatedListController.SORTED_DIRECTION_PARAM, 'ASC');
                
        String jsonData = RelatedListController.initData(JSON.serialize(requestMap));
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        List<Object> records = (List<Object>)responseMap.get(RelatedListController.RECORDS_PARAM);
        System.assert(!records.isEmpty());
        String iconName = (String)responseMap.get(RelatedListController.ICON_NAME_PARAM);
        System.assert(String.isNotBlank(iconName));
    }
}