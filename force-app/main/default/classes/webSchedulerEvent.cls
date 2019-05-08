public class webSchedulerEvent {
    public webSchedulerEvent() {}
    
    public webSchedulerEvent(String id, String eTitle, String eDescription, String eStartDate, String eEndDate, Boolean allDay) {
        EventId = id;
        Title = eTitle;
        Description = eDescription;
        StartDate = eStartDate;
        EndDate = eEndDate;
        IsAllDay = allDay;
    }
    
    public String  EventId     {get;set;}
    public String  Title       {get;set;}
    public String  Description {get;set;}
    public String  StartDate   {get;set;}
    public String  EndDate     {get;set;}
    public Boolean IsAllDay    {get;set;}
    public Integer ResourceId  {get;set;}
}