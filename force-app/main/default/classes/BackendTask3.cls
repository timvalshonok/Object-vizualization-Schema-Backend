public with sharing class BackendTask3 {
    
    @AuraEnabled(cacheable=true)
    public static Map<Id,List<Opportunity>> backendTask3() {
        List<Id> listIds = new List<Id>{'0015j000008skD3AAI', '0015j000008skW9AAI', '0015j000008skWEAAY'};
        
        Map<Id,List<Opportunity>> accIdWithOppListMap = new Map<Id,List<Opportunity>>();
        For(Account acc :[SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :listIds]){
            accIdWithOppListMap.put(acc.Id,acc.Opportunities);
        } 
        System.debug(accIdWithOppListMap);
    }
}
