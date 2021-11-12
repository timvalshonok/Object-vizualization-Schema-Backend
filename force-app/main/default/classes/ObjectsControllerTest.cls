@isTest
public with sharing class ObjectsControllerTest {

    @isTest public static void testGetAllObjects() {

        test.startTest();
        Map<String, String> actual = ObjectsController.getAllObjects();
        test.stopTest();
    
        System.assert(actual.containsKey('Account'), 'Should contain Account object');
    }
}
