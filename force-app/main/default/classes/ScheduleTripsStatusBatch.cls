public class ScheduleTripsStatusBatch implements Schedulable {
    
    public void execute(SchedulableContext SC) {
        UpdateTripsStatusBatch batch = new UpdateTripsStatusBatch();
        
        Database.executeBatch(batch, 200);
    }
}
