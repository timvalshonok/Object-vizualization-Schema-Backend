public with sharing class ChildObjectsController {

    @AuraEnabled(cacheable=true)
    public static void getChildRelationships(Id recordId, String objectName) {
    
        //to store childRelationShipName
        Map<integer,List<string>> childObjectmap = new Map<integer,List<string>>(); 
        //to store inner query string for child objects
        Map<integer,List<string>> childObjectQStringmap = new Map<integer,List<string>>(); 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String ss1: schemaMap.keyset()){
            Schema.SObjectType objToken=schemaMap.get(ss1);
            if(ss1.equalsignorecase(objectName)){
                //find details about sobject
                Schema.DescribeSObjectResult objDescribe=objToken.getdescribe();
                List<Schema.ChildRelationship> childRelationshipList = objDescribe.getChildRelationships();
                system.debug('*********childRelationshipList size:'+childRelationshipList.size()); 
                for(Schema.ChildRelationship ss:childRelationshipList){
                    if(ss.getRelationshipName()!=null){
                        string RelationshipName=ss.getRelationshipName();
                        string childObjName = string.valueof(ss.getChildSObject());
                        //Check if child object is isQueryable() or not
                        Schema.DescribeSObjectResult childObjDescribe = schemaMap.get(childObjName).getdescribe();
                        system.debug('*******childObjName:'+childObjName);
                        //system.debug('*********isRestrictedDelete():'+ss.isRestrictedDelete());
                        //system.debug('*********RelationshipName:'+RelationshipName);
                        if(childObjDescribe.isQueryable()){
                            if(childObjectmap.size()==0){
                                childObjectmap.put(1,new List<string>());
                                childObjectmap.get(childObjectmap.size()).add(RelationshipName);
                                childObjectQStringmap.put(1,new List<string>());
                                childObjectQStringmap.get(childObjectQStringmap.size()).add('(select id from '+ RelationshipName + ' )');
                            }else{
                                if(childObjectmap.get(childObjectmap.size()).size()<20){
                                    childObjectmap.get(childObjectmap.size()).add(RelationshipName);
                                    childObjectQStringmap.get(childObjectQStringmap.size()).add('(select id from '+ RelationshipName + ' )');
                                }else{
                                    childObjectmap.put(childObjectmap.size()+1,new List<string>());
                                    childObjectmap.get(childObjectmap.size()).add(RelationshipName);
                                    childObjectQStringmap.put(childObjectQStringmap.size()+1,new List<string>());
                                    childObjectQStringmap.get(childObjectQStringmap.size()).add('(select id from '+ RelationshipName + ' )');
                                }
                            }    
                        }else{
                            system.debug('******'+childObjName+' object is not querable.');
                        }
                    }
                }
            }
        }
        system.debug('***childObjectmap.size():'+childObjectmap.size());
        system.debug('***childObjectQStringmap.size():'+childObjectQStringmap.size());
        string header = 'Related Object name , Records deatils \n';
        string finalstr = header ;
        try{
            for(integer i:childObjectmap.keyset()){
                string qString = 'Select id,'+ string.join(childObjectQStringmap.get(i),',') +' from ' +objectName+ ' where Id=:recordId LIMIT 1';
                system.debug('***qString:'+qString);
                sObject records = database.query(qString);
                for(string childObjectRec:childObjectmap.get(i)){
                    string childRecordId ='';
                    for(sobject ch:records.getSObjects(childObjectRec)){
                        childRecordId = childRecordId +'  '+ ch.get('Id');
                    }
                    //string recordString= childObjectRec + ',' + records.getSObjects(childObjectRec) + '\n';
                    string recordString= childObjectRec + ',' + childRecordId + '\n';
                    finalstr = finalstr + recordString;
                }
            }
        }catch(exception ex){
            system.debug('******exception:'+ex.getmessage());
        }
    }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getChildRelationships(Id recordId, Object properties, String objectName) {
        
    //     List <SObject> sobjList = Database.Query('SELECT'+properties+'FROM'+objectName+'WHERE Id ='+recordId+'LIMIT 30');
    //     return sobjList;

    //     // Database.Query('Select COUNT() FROM'+chidObject+'WHERE'+)
    // }

    // @AuraEnabled(cacheable=true)
    // public static List<SObject> getChildRelationships(Id recordId, String objectName) {
       
    //     List<SObject> integerList = Database.Query(
    //         'SELECT (SELECT Id FROM Contacts), (SELECT Id FROM Contracts), (SELECT Id FROM Opportunities), (SELECT Id FROM Cases) FROM '+objectName+' WHERE Id = :recordId');
    //     return integerList;
    // }

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
