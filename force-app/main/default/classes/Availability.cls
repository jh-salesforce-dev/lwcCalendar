global class Availability {
	private static final string ID_INVALID_AVAILABILITY_NULL    = 'Invalid Availability: null';
	private static final string ID_INVALID_AVAILABILITY_EMPTY   = 'Invalid Availability: empty';
	private static final string ID_INVALID_AVAILABILITY_LENGTH  = 'Invalid Availability: Length';
	private static final string ID_INVALID_AVAILABILITY_VALUE   = 'Invalid Availability: Value';

	
	private static final string ID_INVALID_TIME_RANGE_NULL    = 'Invalid Time Range: null';
	private static final string ID_INVALID_TIME_RANGE_EMPTY   = 'Invalid Time Range: empty';
	private static final string ID_INVALID_TIME_RANGE_LENGTH  = 'Invalid Time Range: Length';
	private static final string ID_INVALID_TIME_RANGE_FORMAT  = 'Invalid Time Range: Format';
	private static final string ID_INVALID_TIME_RANGE_BEGINTIME  = 'Invalid Time Range: Begin Time';
	private static final string ID_INVALID_TIME_RANGE_ENDTIME = 'Invalid Time Range: End Time';
	private static final string ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN = 'Invalid Time Range: Begin Time must preceed End Time';
	
	// PRIVATE MEMBERS
	private List<DayAvailable> a_days = new List<DayAvailable>();
	private Boolean b_HasError = false;
	private string s_errorMessage = '';
	
	
	// CONSTRUCTOR
	public Availability () {}
	
	public Availability(string textFormat) {
		if (textFormat == null) {
			s_errorMessage = ID_INVALID_AVAILABILITY_NULL; 
			return;
		}

		if (textFormat == '') {
			s_errorMessage = ID_INVALID_AVAILABILITY_EMPTY;
			return;
		}		
		//breaks the days down since they are seperated by ;
		// example string "Mon 9a-2p;Tue 12:19p-1p,2a-4a;Fri 12p-2p,3:15p-7p,9p-11p"
		string[] dayStrings = textFormat.split(';');
		
		for (string dayString : dayStrings) {			
			DayAvailable day = new DayAvailable(dayString);
			if (day.IsValid()) {
				a_days.add(day);	
			} else {
				s_errorMessage = ID_INVALID_AVAILABILITY_VALUE;
				return;
			}
		}
	}


	// ACCESSORS/PROPERTIES
	public List<DayAvailable> DaysAvailable {
		get { return a_days; }
		set { a_days = value; }
	}
			
	
	// PUBLIC METHODS
	public static Boolean IsAvailable(string baseAvailString, string compareAvailString, Integer minutesRequired) {
		System.debug ('Availability.IsAvailable: ' + baseAvailString + ',' + compareAvailString);
		Availability baseAvail = new Availability(baseAvailString);
		Availability compAvail = new Availability(compareAvailString);
		Boolean isAvailable = false;
		
		for (DayAvailable baseDay : baseAvail.DaysAvailable) {
			for (DayAvailable compareDay : compAvail.DaysAvailable) {
				if (baseDay.DayAbbreviation == compareDay.DayAbbreviation) {
					if (baseDay.IsAvailable(compareDay, minutesRequired)) {
						isAvailable = true;
						break;
					}
				}
			} // end for 
			if (isAvailable) {
				break;
			}	 
		}  // end for
		System.debug ('Availability.IsAvailable evalued to: ' + (isAvailable ? 'Yes':'No'));
		return isAvailable;
	}
	
	public Boolean IsValid() {
		Boolean isValid = true;
		
		if (a_days.size() > 0) {
			for (DayAvailable day : a_days) {
				if (!day.IsValid()) {
					isValid = false;
					break;
				}
			}
		} else {
			isValid = false;
		}		
		
		return isValid;
	}
	
	public static string validateAvailabilityString(string availString) {
		string message = '';
		Boolean isValid = true;
		
		if (availString == null) {
			message = 'Availability is null';
		}
		
		if (availString == '') {
			message = 'Availability is empty';
		}
		
		try {
			Availability testAvail = new Availability(availString);
		} catch (Exception e) {
			message = 'Invalid Availability: ' + availString;
		}
		
		return message;
	}
		
	public string getErrorMessage() {
		return s_errorMessage;
	}
	
	public static Availability GetIntersection(Availability baseAvail, Availability compAvail){
		Availability interAvail = new Availability();
		
		for (DayAvailable baseDay : baseAvail.DaysAvailable){
			for(DayAvailable compDay : compAvail.DaysAvailable){
				if(baseDay.DayAbbreviation == compDay.DayAbbreviation){
					DayAvailable interDay = baseDay.GetIntersection(compDay);
					if (interDay != null) {
						interAvail.DaysAvailable.add(interDay);
					}					
				}
			}
		}
		
		if(interAvail.DaysAvailable.size() == 0){
			// return null
			interAvail = null;
		}
		
		return interAvail;
	}
	
    
	public List<webSchedulerEvent> toSchedulerEventArray() {
		List<webSchedulerEvent> events = new List<webSchedulerEvent>();

		Integer eventCounter = 0;
		
		for(DayAvailable day : a_days) {
			List<Map<String,String>> dayEvents = day.toDateTimeArray();
			
			for(Map<String,String> dayEvent : dayEvents) {
				webSchedulerEvent schedulerEvent = new webSchedulerEvent();
				
				eventCounter++;
				schedulerEvent.EventId = eventCounter.format();
				schedulerEvent.Title = 'Available';
				schedulerEvent.Description = 'Description';
				schedulerEvent.StartDate = dayEvent.get('Begin DateTime');
				schedulerEvent.EndDate   = dayEvent.get('End DateTime');
				schedulerEvent.IsAllDay = false;
				
				events.add(schedulerEvent);
			} // end for map list (day array)

		} // end for 
		
		return events;
	}
    
    public List<Site_Schedule__c> toSiteSchedule(String schoolYear, String siteId, Integer capacity) {
        List<Site_Schedule__c> siteSchedule = new List<Site_Schedule__c>();
        
        Integer beginTime;
        Integer endTime;
        
        for(DayAvailable da: DaysAvailable){
            for(TimeAvailable ta : da.TimesAvailable){
                beginTime = ta.BeginTime;
                endTime = beginTime + 60;
                
                while(endTime <= ta.EndTime){
                    if (ta.getOverlap(beginTime, endTime) >= 60) {
                        Site_Schedule__c schedule = new Site_Schedule__c();

						schedule.School_Year__c    = schoolYear;
						schedule.Tutoring_Site__c  = siteId;
						schedule.Max_Volunteers__c = capacity;
						schedule.Begin_Time__c     = da.GetDateTime(beginTime);
						schedule.Begin_Number__c   = beginTime;
						schedule.End_Time__c       = da.GetDateTime(endTime);						
						schedule.End_Number__c	   = endTime;
                        
                        siteSchedule.add(schedule);
                        beginTime = endTime;
                        endTime = beginTime + 60;                        
                    } // end if
                } // end while
            } // end for time
        } // end for day
        
        return siteSchedule;
    }
			
}