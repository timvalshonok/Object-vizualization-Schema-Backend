public with sharing class ChildObjectsController {

    @AuraEnabled(cacheable=true)
    public static List<SObject> getChildRelationships(Id recordId, List<String> properties, String objectName) {
        
        List <SObject> sobjList = Database.Query('SELECT'+properties+'FROM'+objectName+'WHERE Id ='+recordId+'LIMIT 30');
        return sobjList;

        // List<SObject> integerList = Database.Query(
        //     'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Contracts), (SELECT Id FROM Opportunities), (SELECT Id FROM Cases) FROM Account WHERE Id = :accountId');
        // return integerList;

        // Database.Query('Select COUNT() FROM'+chidObject+'WHERE'+)
    }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getAccountChildRecords(Id accountId) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Contracts), (SELECT Id FROM Opportunities), (SELECT Id FROM Cases) FROM Account WHERE Id = :accountId');
    //     return integerList;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getContactChildRecords(Id contactId) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Opportunities), (SELECT Id FROM Cases) FROM Contact WHERE Id = :contactId');
    //     return integerList;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getContractChildRecords(Id contractId) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Opportunities), (SELECT Id FROM Cases) FROM Contract WHERE Id = :contractId');
    //     return integerList;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getOpportunityChildRecords(Id opportunityId) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Contracts), (SELECT Id FROM Cases) FROM Opportunity WHERE Id = :opportunityId');
    //     return integerList;
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getCaseChildRecords(Id caseId) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Contracts), (SELECT Id FROM Opportunities) FROM Case WHERE Id = :caseId');
    //     return integerList;
    // }
}
