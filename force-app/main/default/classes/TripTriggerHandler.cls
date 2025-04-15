public with sharing class TripTriggerHandler {

    public static void validateTripDates(List<Trip__c> tripsToValidate) {

        for (Trip__c trip : tripsToValidate) {
            
            if (trip.Start_Date__c != null && trip.End_Date__c != null && trip.End_Date__c < trip.Start_Date__c) {
                
                trip.addError('La date de Fin ne peut être plus tôt que la date de Début');
                
            }
        }
    }
}
