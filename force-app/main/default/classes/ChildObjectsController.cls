// public with sharing class ChildObjectsController {

//     @AuraEnabled(cacheable=true)
//     public static Map<String,Integer> getChildRelation(String recordId, Map<String, String> childRelationships) {

//         Map<String, Integer> queryResult = new Map<String, Integer>();
//         Integer entryCounts;
//         for(String childObject : childRelationships.keySet()){
//             if(Schema.getGlobalDescribe().get(childObject) == null ||
//                 !Schema.getGlobalDescribe().get(childObject).getDescribe().isQueryable() ||
//                 !Schema.getGlobalDescribe().get(childObject).getDescribe().isSearchable()) {
//                     continue;
//                 }
//                 String childObjectName = childRelationships.get(childObject);
//                 String query = 'SELECT ' + childObjectName + ' FROM ' + childObject + ' WHERE ' + childObjectName + ' = ' + '\'' + recordId + '\'';
//                 List<SObject> queryRequest = Database.query(query);
//                 if(queryRequest != null) {
//                     entryCounts = queryRequest.size();
//                 }
//                 if(entryCounts == 0) {
//                     continue;
//                 }
//                 queryResult.put(childObject, entryCounts);
//         }
//         return queryResult;
//     }
// }

public with sharing class ChildObjectsController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getChildrelationships(Map<String, String> childRelationships, String recordId) {
        Map<String, Integer> queryResult = new Map<String, Integer>();
        Integer entryCounts;
        for(String childName : childRelationships.keyset()){
            if(Schema.getGlobalDescribe().get(childName) != null && 
            Schema.getGlobalDescribe().get(childName).getDescribe().isQueryable() && 
            Schema.getGlobalDescribe().get(childName).getDescribe().isSearchable()){
                String relatedFieldName = childRelationships.get(childName);
                String queryTemplate = 'SELECT ' + relatedFieldName + ' FROM ' + childName + ' WHERE ' + relatedFieldName + ' = ' + '\'' +  recordId + '\'';
                List<SObject> queryRequest = Database.query(queryTemplate);
                if(queryRequest != null){
                    entryCounts = queryRequest.size();
                }
                if(entryCounts == 0){
                    continue;
                }
            }
            queryResult.put(childName, entryCounts);
        }
        return queryResult;
    }
}