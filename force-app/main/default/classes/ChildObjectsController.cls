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

// DescribeSObjectResult describeResult = Account.SObjectType.getDescribe();
// for (ChildRelationship childRelation : describeResult.getChildRelationships()) {
//     if(childRelation != null && childRelation.getChildSObject().getDescribe().isQueryable() && 
//     childRelation.getChildSObject().getDescribe().isCreateable() && 
//     childRelation.getChildSObject().getDescribe().isUpdateable() && 
//     childRelation.getChildSObject().getDescribe().isDeletable() && 
//     childRelation.getChildSObject().getDescribe().isSearchable()){
//         if (childRelation.getRelationshipName() != null){
//             subqueries.add('(SELECT Id FROM ' + childRelation.getRelationshipName() + ')');
//         }
//     }
// } 
// System.debug(subqueries.size());
// System.debug(subqueries);
// String query = 'SELECT ' + String.join(subQueries, ',') + ' FROM ' +objectName+ ' WHERE Id = :recordId LIMIT 20';
// return Database.Query(query);

public inherited sharing class ChildObjectsController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getRelatedChilds(Map<String, String> childRelationships, String recordId) {
        Map<String, Integer> result = new Map<String, Integer>();
        Integer numberOfEntries;
        for(String childName : childRelationships.keyset()){
            if(Schema.getGlobalDescribe().get(childName) == null 
            || !Schema.getGlobalDescribe().get(childName).getDescribe().isQueryable() 
            || !Schema.getGlobalDescribe().get(childName).getDescribe().isSearchable()){
                continue;
            }
            String relatedFieldName = childRelationships.get(childName);
            String queryTemplate = 'SELECT ' + relatedFieldName + ' FROM ' + childName + ' WHERE ' + relatedFieldName + ' = ' + '\'' +  recordId + '\'';
            List<SObject> queryReply = Database.query(queryTemplate);
            if(queryReply != null){
                numberOfEntries = queryReply.size();
            }
            if(numberOfEntries == 0){
                continue;
            }
            result.put(childName, numberOfEntries);
        }
        
        return result;
    }
}