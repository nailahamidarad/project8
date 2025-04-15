trigger TripTrigger on Trip__c (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        TripTriggerHandler.validateTripDates(Trigger.New);
    }
}

