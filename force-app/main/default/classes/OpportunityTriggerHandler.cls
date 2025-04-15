public with sharing class OpportunityTriggerHandler {
    public static void createTripFromOpportunity(List<Opportunity> opportunities) {

        List<Trip__c> tripsToCreate = new List<Trip__c>();

        for (Opportunity opp : opportunities) {
            if (opp.StageName == 'Closed Won') {

                Trip__c newTrip = new Trip__c();

                newTrip.Status__c = 'A Venir';
                newTrip.Destination__c = opp.Destination__c;
                newTrip.Start_Date__c = opp.Start_Date__c;
                newTrip.End_Date__c = opp.End_Date__c;
                newTrip.Number_of_participants__c = opp.Number_of_participants__c;
                newTrip.Total_Cost__c = opp.Amount;
                newTrip.Account__c = opp.AccountId;
                newTrip.Opportunity__c = opp.Id;

                tripsToCreate.add(newTrip);
            }
        }
        try{
            if (tripsToCreate.size() > 0) {
                insert tripsToCreate;
            }
        }
        catch(customDevException me) {
            System.debug('Message: ' + me.getMessage());    
            System.debug('Cause: ' + me.getCause());    
            System.debug('Line number: ' + me.getLineNumber());    
            System.debug('Stack trace: ' + me.getStackTraceString());    

            throw new customDevException(
                'Opportunity could not be closed.', me);
        }
    }
    public class customDevException extends Exception {
        

    }
}
