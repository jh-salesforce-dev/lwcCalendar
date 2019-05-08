public class DayAvailable {
	private static final string ID_INVALID_DAY_NULL    = 'Invalid Day: null';
	private static final string ID_INVALID_DAY_EMPTY   = 'Invalid Day: empty';
	private static final string ID_INVALID_DAY_LENGTH  = 'Invalid Day: Length';
	private static final string ID_INVALID_DAY_VALUE   = 'Invalid Day: Value';

	private static final string ID_INVALID_TIME_RANGE_NULL    = 'Invalid Time Range: null';
	private static final string ID_INVALID_TIME_RANGE_EMPTY   = 'Invalid Time Range: empty';
	private static final string ID_INVALID_TIME_RANGE_LENGTH  = 'Invalid Time Range: Length';
	private static final string ID_INVALID_TIME_RANGE_FORMAT  = 'Invalid Time Range: Format';
	private static final string ID_INVALID_TIME_RANGE_BEGINTIME  = 'Invalid Time Range: Begin Time';
	private static final string ID_INVALID_TIME_RANGE_ENDTIME = 'Invalid Time Range: End Time';
	private static final string ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN = 'Invalid Time Range: Begin Time must preceed End Time';	

	private string s_DayAbbreviation = '';
	private List<TimeAvailable> a_times = new List<TimeAvailable>();
	private string s_errorMessage = '';

	// new constructor 8/20/15
	public DayAvailable(){}
	
	public DayAvailable(string dayAndTimeRangesString) { 
		string timeRangesString = '';
		string[] timeRangeStrings = null;			
		
        //example dayAndTimeRangeString 
		//"Tue 12:19p-1p,2a-4a"
				
		if (dayAndTimeRangesString == null) {		
			s_errorMessage = ID_INVALID_DAY_NULL;
			return;
		}
		
		if (dayAndTimeRangesString.trim() == '') {
			s_errorMessage = ID_INVALID_DAY_EMPTY;
			return;			
		}
		
        //takes out any white trailing/leading white space
		dayAndTimeRangesString = dayAndTimeRangesString.trim();
		
        
		if (dayAndTimeRangesString.length() < 9) {
			s_errorMessage = ID_INVALID_DAY_LENGTH;
			return;
		}

		// Day Abbreviation
		s_DayAbbreviation = dayAndTimeRangesString.substring(0,3);
		if (!IsValidDayAbbreviation()) {
			// error message is set in validation
			return;
		}					
		
		// Time Range(s)		
		timeRangesString = dayAndTimeRangesString.substring(4);
		timeRangeStrings = timeRangesString.split(',');
		
		for (string timeRangeString : timeRangeStrings) {
			TimeAvailable timeRange = new TimeAvailable(timeRangeString.trim());
			if (timeRange.IsValidTimeRange()) {
				a_times.add(timeRange);	
			} else {
				s_errorMessage = timeRange.getErrorMessage();
				return;
			}					
		} // end for

	}
	
	public string DayAbbreviation {
		get { return s_DayAbbreviation; }
		set { s_DayAbbreviation = value; }
	}
	
	public List<TimeAvailable> TimesAvailable {
		get { return a_times; }
		set { a_times = value; }
	}
	
	public Boolean IsAvailable(DayAvailable day, Integer minutesRequired) {
		Boolean isAvailable = false;
		
		if (s_DayAbbreviation != day.DayAbbreviation) {
			return isAvailable;
		}
		
		for (TimeAvailable baseTime : a_times) {
			for (TimeAvailable compareTime : day.TimesAvailable) {
				if (baseTime.getOverlap(compareTime.BeginTime, compareTime.EndTime) >= minutesRequired) {
					isAvailable = true;
					break;
				}
			}
			if (isAvailable) {
				break;
			}
		}			
		
		return isAvailable;
	}
	
	public DayAvailable GetIntersection(DayAvailable compDay){
		DayAvailable interDay = new DayAvailable();
		
		if (DayAbbreviation == compDay.DayAbbreviation){
			interDay.DayAbbreviation = DayAbbreviation;
			// only run if it is for the same day of week
			for(TimeAvailable baseTime: TimesAvailable){
				for(TimeAvailable compTime : compDay.TimesAvailable){
					
					TimeAvailable interTime = baseTime.GetOverlapTimeAvailable(compTime);
					if (interTime != null){
						interDay.TimesAvailable.add(interTime);
					}
				}
			}
		}
		
		if(interDay.TimesAvailable.size() == 0){
			interDay = null;
		}
		
		return interDay;
	}
	
	public Boolean IsValidDayAbbreviation() {
		s_errorMessage = '';
			
		if (s_DayAbbreviation == null) {
			s_errorMessage = ID_INVALID_DAY_NULL;
			return false;
		}
		
		if (s_DayAbbreviation == '') {
			s_errorMessage = ID_INVALID_DAY_EMPTY;
			return false;
		}

		if (s_DayAbbreviation.length() != 3) {
			s_errorMessage = ID_INVALID_DAY_LENGTH;
			return false;
		}
		
		if (s_DayAbbreviation != 'Mon' && s_DayAbbreviation != 'Tue' && s_DayAbbreviation != 'Wed' && s_DayAbbreviation != 'Thu' && s_DayAbbreviation != 'Fri') {
			s_errorMessage = ID_INVALID_DAY_VALUE;
			return false;
		}
		
		return true;
	}
	
	public Boolean HasValidTimeRanges() {
		
		if (a_times.size() < 1) {
			return false;
		}
		
		return true;
	}
	
	public Boolean IsValid() {
		
		if (!IsValidDayAbbreviation()) {
			return false;
		}		

		if (!HasValidTimeRanges()) {
			return false;
		}
		
		return true;
	}
	
	public string getErrorMessage() {
		return s_errorMessage;
	}
    
    public Date GetDate() {
        Integer dayOffset = 0;
        
        if(s_DayAbbreviation == 'Mon') {
            dayOffset = 1;
        }
        
        if(s_DayAbbreviation == 'Tue') {
            dayOffset = 2;
        }
        
         if(s_DayAbbreviation == 'Wed') {
            dayOffset = 3;
        }
        
        if(s_DayAbbreviation == 'Thu') {
            dayOffset = 4;
        }
        
        if(s_DayAbbreviation == 'Fri') {
            dayOffset = 5;
        }        
        
        Date baseDate = Date.today().toStartOfWeek().addDays(dayOffset);
        
        return baseDate;
    }
    
    public Datetime GetDateTime(Integer timeNumber){
        Date dateOfWeek = GetDate();
        Time timeOfDay =  TimeAvailable.getTime(timeNumber);
        Datetime daDateTime = Datetime.newInstance(dateOfWeek, timeOfDay);
        
        return daDateTime;
    }
    
    public List<Map<String,String>> toDateTimeArray() {
        Integer dayOffset = 0;
        List<Map<String,String>> dateTimeRanges = new List<Map<String,String>>();
        

        // Get Date
        if(s_DayAbbreviation == 'Mon') {
            dayOffset = 1;
        }
        
        if(s_DayAbbreviation == 'Tue') {
            dayOffset = 2;
        }
        
         if(s_DayAbbreviation == 'Wed') {
            dayOffset = 3;
        }
        
        if(s_DayAbbreviation == 'Thu') {
            dayOffset = 4;
        }
        
        if(s_DayAbbreviation == 'Fri') {
            dayOffset = 5;
        }
        
        Date baseDate = Date.today().toStartOfWeek().addDays(dayOffset);
        Datetime baseDateTime = Datetime.newInstance(baseDate.year(), baseDate.month(), baseDate.day());
        String dateString = baseDateTime.format('yyyy-MM-dd') + 'T';
        
        // Get Time Ranges        
        for(TimeAvailable times : a_times) {
            Map<String,String> timeRange = times.toTimeRange();
            
            Map<String,String> dateTimeRange = new Map<String,String>();
            dateTimeRange.put('Begin DateTime', dateString + times.getBeginScheduleTimeFormat());
            dateTimeRange.put('End DateTime', dateString + times.getEndScheduleTimeFormat());
            //dateTimeRange.put('Begin DateTime',dateString + ' ' + timeRange.get('Begin Time'));
            //dateTimeRange.put('End DateTime', dateString + ' ' + timeRange.get('End Time'));
			
			dateTimeRanges.add(dateTimeRange);
        }
        
        return dateTimeRanges;
    }
}