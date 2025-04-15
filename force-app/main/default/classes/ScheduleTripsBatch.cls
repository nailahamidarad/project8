public class ScheduleTripsBatch implements Schedulable {
    
    public void execute(SchedulableContext SC) {
        CheckTripsBatch batch = new CheckTripsBatch();
        
        Database.executeBatch(batch, 200);
    }
}
