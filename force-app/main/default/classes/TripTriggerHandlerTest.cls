@isTest
public class TripTriggerHandlerTest {

    @isTest
    static void testTripWithValidDates() {
        Trip__c validTrip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(3),
            Number_of_participants__c = 3
        );

        Test.startTest();
        insert validTrip;
        Test.stopTest();

        Trip__c insertedTrip = [SELECT Id, Start_Date__c, End_Date__c FROM Trip__c WHERE Id = :validTrip.Id];
        System.assertNotEquals(null, insertedTrip);
    }

    @isTest
    static void testTripWithInvalidDates() {
        Trip__c invalidTrip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(-1),
            Number_of_participants__c = 3
        );

        Test.startTest();
        try {
            insert invalidTrip;
            System.assert(false, 'L\'insertion aurait dû échouer à cause des dates invalides');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('La date de Fin ne peut être plus tôt que la date de Début'));
        }
        Test.stopTest();
    }
}
