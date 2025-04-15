public class UpdateTripsStatusBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Start_Date__c, End_Date__c, Status__c FROM Trip__c WHERE Status__c != \'Annulé\'';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Trip__c> trips) {
        List<Trip__c> tripsToUpdate = new List<Trip__c>();
        Date today = Date.today();

        for (Trip__c trip : trips) {
            String newStatus;
            if (today < trip.Start_Date__c) {
                newStatus = 'A venir';
            } else if (today >= trip.Start_Date__c && today <= trip.End_Date__c) {
                newStatus = 'En cours';
            } else if (today > trip.End_Date__c) {
                newStatus = 'Terminé';
            }

            if (trip.Status__c != newStatus) {
                trip.Status__c = newStatus;
                tripsToUpdate.add(trip);
            }
        }

        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Batch terminée. Trips Status mis à jour.');
    }
}
