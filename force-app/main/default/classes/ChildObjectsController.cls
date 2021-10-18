public with sharing class ChildObjectsController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getChildrelationships(Map<String, String> childRelationships, String recordId) {
        Map<String, Integer> queryResult = new Map<String, Integer>();
        Integer entryCounts;
        for(String childName : childRelationships.keyset()){
            if(Schema.getGlobalDescribe().get(childName) != null && 
            Schema.getGlobalDescribe().get(childName).getDescribe().isQueryable() && 
            Schema.getGlobalDescribe().get(childName).getDescribe().isSearchable()){
                System.debug(childName);
                String relatedFieldName = childRelationships.get(childName);
                System.debug(relatedFieldName);
                String queryTemplate = 'SELECT ' + relatedFieldName + ' FROM ' + childName + ' WHERE ' + relatedFieldName + ' = ' + '\'' +  recordId + '\'';
                List<SObject> queryRequest = Database.query(queryTemplate);
                if(queryRequest != null){
                    entryCounts = queryRequest.size();
                }
                if(entryCounts == 0){
                    continue;
                }
                queryResult.put(childName, entryCounts);
            }
        }
        return queryResult;
    }
}