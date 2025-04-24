@isTest
private class CheckTripsBatchTest {

    @isTest
    static void testBatchExecution() {
        List<Trip__c> testTrips = new List<Trip__c>();

        testTrips.add(new Trip__c(Name='Trip A', Start_Date__c = Date.today().addDays(2), Number_of_participants__c = 5, Status__c='Confirmé'));
        testTrips.add(new Trip__c(Name='Trip B', Start_Date__c = Date.today().addDays(6), Number_of_participants__c = 3, Status__c='Confirmé'));

        testTrips.add(new Trip__c(Name='Trip C', Start_Date__c = Date.today().addDays(10), Number_of_participants__c = 2, Status__c='Confirmé'));
        testTrips.add(new Trip__c(Name='Trip D', Start_Date__c = Date.today().addDays(3), Number_of_participants__c = 15, Status__c='Confirmé'));

        insert testTrips;

        Test.startTest();
        CheckTripsBatch batch = new CheckTripsBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();

        Map<String, Trip__c> tripsByName = new Map<String, Trip__c>(
            [SELECT Name, Status__c FROM Trip__c WHERE Name IN ('Trip A', 'Trip B', 'Trip C', 'Trip D')]
        );

        System.assertEquals('Annulé', tripsByName.get('Trip A').Status__c, 'Trip A doit être annulé');
        System.assertEquals('Annulé', tripsByName.get('Trip B').Status__c, 'Trip B doit être annulé');
        System.assertEquals('Confirmé', tripsByName.get('Trip C').Status__c, 'Trip C ne doit pas être modifié');
        System.assertEquals('Confirmé', tripsByName.get('Trip D').Status__c, 'Trip D ne doit pas être modifié');
    }
}
