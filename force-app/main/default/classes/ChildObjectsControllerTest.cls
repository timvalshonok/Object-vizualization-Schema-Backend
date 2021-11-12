@isTest
public with sharing class ChildObjectsControllerTest {

    @isTest
    public static void getChildRelationshipsTest() {
        
        Map<String, String> childRelationships = new Map<String, String>{'Contact' => 'AccountId'};
        Map<String, Integer> expected = new Map<String, Integer>{'Contact' => 1};

        Test.startTest();
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact con = new Contact(LastName = 'test', AccountId = acc.Id);
        insert con;
        Test.stopTest();
    
        Map<String, Integer> actual = ChildObjectsController.getChildrelationships(childRelationships, acc.Id);
        System.assertEquals(actual, expected, 'expected result: match Contact - 1');
    }
}
