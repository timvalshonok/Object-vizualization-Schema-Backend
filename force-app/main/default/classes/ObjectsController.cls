public with sharing class ObjectsController {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getAllObjects() {
        Map<String, String> objectList = new Map<String, String>();
        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
        {
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            System.debug(objResult.getName());
            if(objResult.isQueryable()) {
            objectList.put(objResult.getName(), objResult.getLabel());
            }
        }
        return objectList;
    }
}
