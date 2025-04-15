@isTest
public class OpportunityTriggerHandlerTest {

    @isTest
    static void testCreateTripFromClosedWonOpportunity() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            CloseDate = Date.today().addDays(10),
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(5),
            End_Date__c = Date.today().addDays(9),
            Number_of_participants__c = 5,
            Amount = 10000,
            AccountId = testAccount.Id
        );
        insert opp;

        Test.startTest();
        OpportunityTriggerHandler.createTripFromOpportunity(new List<Opportunity>{opp});
        Test.stopTest();

        Trip__c createdTrip = [SELECT Id, Destination__c, Status__c, Number_of_participants__c, Opportunity__c 
                               FROM Trip__c 
                               WHERE Opportunity__c = :opp.Id
                               LIMIT 1];

        System.assertEquals('A venir', createdTrip.Status__c);
        System.assertEquals('Paris', createdTrip.Destination__c);
        System.assertEquals(opp.Id, createdTrip.Opportunity__c);
        System.assertEquals(5, createdTrip.Number_of_participants__c);
    }

    @isTest
    static void testNoTripCreatedIfNotClosedWon() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity opp = new Opportunity(
            Name = 'Opportunity Not Closed',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            Destination__c = 'Rome',
            Start_Date__c = Date.today().addDays(5),
            End_Date__c = Date.today().addDays(9),
            Number_of_participants__c = 3,
            Amount = 5000,
            AccountId = testAccount.Id
        );
        insert opp;

        Test.startTest();
        OpportunityTriggerHandler.createTripFromOpportunity(new List<Opportunity>{opp});
        Test.stopTest();

        List<Trip__c> trips = [SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(0, trips.size());
    }


}
