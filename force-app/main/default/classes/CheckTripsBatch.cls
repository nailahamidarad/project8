public class CheckTripsBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Start_Date__c, Number_of_participants__c, Status__c FROM Trip__c WHERE Start_Date__c <= NEXT_N_DAYS:7 AND Number_of_participants__c < 10 ';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        for (Trip__c trip : trips) {
                trip.Status__c = 'Annulé'; 
                tripsToUpdate.add(trip);  
        }

        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Batch terminée. Trips mis à jour.');
    }
}
