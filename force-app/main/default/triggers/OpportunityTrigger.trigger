trigger OpportunityTrigger on Opportunity (after insert, after update) {    
    if (Trigger.isInsert || Trigger.isUpdate) {
        OpportunityTriggerHandler.createTripFromOpportunity(Trigger.New);
}}