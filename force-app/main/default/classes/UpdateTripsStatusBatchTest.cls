@isTest
private class UpdateTripsStatusBatchTest {

    @isTest
    static void testUpdateTripStatus() {
        Date today = Date.today();

        Trip__c tripFuture = new Trip__c(
            Name = 'Trip Futur',
            Start_Date__c = today.addDays(5),
            End_Date__c = today.addDays(10),
            Status__c = 'Confirmé'
        );

        Trip__c tripOngoing = new Trip__c(
            Name = 'Trip En cours',
            Start_Date__c = today.addDays(-2),
            End_Date__c = today.addDays(2),
            Status__c = 'Confirmé'
        );

        Trip__c tripPast = new Trip__c(
            Name = 'Trip Terminé',
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-1),
            Status__c = 'Confirmé'
        );

        Trip__c tripCancelled = new Trip__c(
            Name = 'Trip Annulé',
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-1),
            Status__c = 'Annulé' 
        );

        insert new List<Trip__c>{ tripFuture, tripOngoing, tripPast, tripCancelled };

        Test.startTest();
        UpdateTripsStatusBatch batch = new UpdateTripsStatusBatch();
        Database.executeBatch(batch, 2);
        Test.stopTest();

        Map<String, Trip__c> tripsByName = new Map<String, Trip__c>(
            [SELECT Name, Status__c FROM Trip__c WHERE Name IN ('Trip Futur', 'Trip En cours', 'Trip Terminé', 'Trip Annulé')]
        );

        System.assertEquals('A venir', tripsByName.get('Trip Futur').Status__c, 'Doit être "A venir"');
        System.assertEquals('En cours', tripsByName.get('Trip En cours').Status__c, 'Doit être "En cours"');
        System.assertEquals('Terminé', tripsByName.get('Trip Terminé').Status__c, 'Doit être "Terminé"');
        System.assertEquals('Annulé', tripsByName.get('Trip Annulé').Status__c, 'Ne doit pas être modifié');
    }
}
