public class TimeAvailable {
	private static final string ID_INVALID_TIME_NULL          = 'Invalid Time: null';
	private static final string ID_INVALID_TIME_EMPTY         = 'Invalid Time: empty';
	private static final string ID_INVALID_TIME_LENGTH        = 'Invalid Time: Length';
	private static final string ID_INVALID_TIME_HOUR_NUMERIC  = 'Invalid Time: Hour is not numeric';
	private static final string ID_INVALID_TIME_HOUR_VALUE    = 'Invalid Time: Hour value must be 1-12';
	private static final string ID_INVALID_TIME_MINUTE_NUMERIC = 'Invalid Time: Minute is not numeric';
	private static final string ID_INVALID_TIME_MINUTE_VALUE  = 'Invalid Time: Minute value must be 00-59';	
	private static final string ID_INVALID_TIME_AMPMINDICATOR = 'Invalid Time: AM/PM Indicator';
	
	private static final string ID_INVALID_TIME_RANGE_NULL    = 'Invalid Time Range: null';
	private static final string ID_INVALID_TIME_RANGE_EMPTY   = 'Invalid Time Range: empty';
	private static final string ID_INVALID_TIME_RANGE_LENGTH  = 'Invalid Time Range: Length';
	private static final string ID_INVALID_TIME_RANGE_FORMAT  = 'Invalid Time Range: Format';
	private static final string ID_INVALID_TIME_RANGE_BEGINTIME = 'Invalid Time Range: Begin Time';
	private static final string ID_INVALID_TIME_RANGE_ENDTIME = 'Invalid Time Range: End Time';
	private static final string ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN = 'Invalid Time Range: Begin Time must preceed End Time';	

	Integer i_beginTime = 0;
	Integer i_endTime = 0;
	string s_errorMessage = '';
	
	public TimeAvailable() {}
	
	public TimeAvailable(string timeRangeString) {
		// Time Range Format is as follows:
		// HH:mmA-HH:mmA
		// H one digit hour number,  a number from 1-9.   for example  9 as in  9a
		// HH two digit hour number, a number from 10-12. for example 12 as in 12p
		// : single digit colon,     can only be :.       for example  : as in 12:15a 
		// A am/pm indicator,        either a or p.       for example  p as in  8p
		// mm two digit minute number, a number from 01-50. for example 05 as in 10:05a
		// 1a-2a         =  5 length
		// 10a-1p        =  6 length
		// 12p-10p       =  7 length
		// 1:01a-2a      =  8 len  
		// 10:01a-1p     =  9 len
		// 10:01a-12p    = 10 len
		// 7:30a-9:30a   = 11 len
		// 10:01a-1:00p  = 12 len
		// 10:01a-11:00a = 13 len
		
		if (timeRangeString == null) {
			s_errorMessage = ID_INVALID_TIME_RANGE_NULL;
			return;
		}
		
		if (timeRangeString.length() < 5 || timeRangeString.length() > 13) {
			s_errorMessage = ID_INVALID_TIME_RANGE_LENGTH;
			return;
		}
		
		string[] times = timeRangeString.split('-');
		if (times.size() != 2) {
			s_errorMessage = ID_INVALID_TIME_RANGE_FORMAT;
			return;		
		}			 
		
		string beginTime = times[0]; 
		string endTime = times[1];
		if (IsValidTime(beginTime)) {
			i_beginTime = GetTimeNumber(beginTime);
		} else {
			s_errorMessage = ID_INVALID_TIME_RANGE_BEGINTIME;
			return;
		}
		 
		if (IsValidTime(endTime)) {
			i_endTime = GetTimeNumber(endTime);				
		} else {
			s_errorMessage = ID_INVALID_TIME_RANGE_ENDTIME;
			return;
		}
		
		if (!IsValidTimeRange()) {
			s_errorMessage = ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN;
		}
	}
	
	public Integer BeginTime {
		get { return i_beginTime; }
		set { i_beginTime = value; }
	}
	
	public Integer EndTime {
		get { return i_endTime; }
		set { i_endTime = value; }
	}		

    public String getScheduleTimeFormat(Integer timeNumber) {
        //'HH:mm:ss.000'
        String hourString = '';
        String minuteString = '';
        
        Integer hourNumber = timeNumber / 60;
        Integer minuteNumber = timeNumber - (hourNumber * 60);

		hourString = hourNumber.format();
        if (hourString.length() == 1) {
            hourString = '0' + hourString;
        }
        minuteString = minuteNumber.format();
        if (minuteString.length() == 1) {
            minuteString = '0' + minuteString;
        }
        
        return hourString + ':' + minuteString + ':00.000';
    }
    
    public String getBeginScheduleTimeFormat(){
        return getScheduleTimeFormat(i_beginTime);
    }
    
    public String getEndScheduleTimeFormat(){
        return getScheduleTimeFormat(i_endTime);
    }
    
	public Integer getOverlap(Integer beginTime, Integer endTime) {
		Integer adjustedBeginTime = 0;
		Integer adjustedEndTime = 0;
		
		if (endTime <= i_beginTime || beginTime >= i_endTime) {
			return 0;
		} 
		
		// Get Adjusted Start Time
		if (i_beginTime > beginTime ) {
			adjustedBeginTime = i_beginTime;
		} else {
			adjustedBeginTime = beginTime;
		}
		
		// Get Adjusted End Time
		if (i_endTime < endTime) {
			adjustedEndTime = i_endTime;
		} else {
			adjustedEndTime = endTime;
		}
		
		return adjustedEndTime - adjustedBeginTime;
	}
	
	public TimeAvailable GetOverlapTimeAvailable(TimeAvailable compTime){
		TimeAvailable interTime;
		Integer adjustedBeginTime = 0;
		Integer adjustedEndTime = 0;

		if (compTime.EndTime <= i_beginTime || compTime.BeginTime >= i_endTime){
			return null;
		}
		
		// Begin Time
		if (i_beginTime > compTime.BeginTime){
			adjustedBeginTime = i_beginTime;
		} else {
			adjustedBeginTime = compTime.BeginTime;
		}
		
		// End Time
		if(i_endTime < compTime.EndTime){
			adjustedEndTime = i_endTime;
		} else {
			adjustedEndTime = compTime.EndTime;
		}
		
		if (adjustedEndTime - adjustedBeginTime > 0){
			interTime = new TimeAvailable();
			interTime.BeginTime = adjustedBeginTime;
			interTime.EndTime = adjustedEndTime;
		}
		return interTime;
	}
	
	public Integer getTimeNumber(string timeString) {
		// Time Format is as follows:
		// HH:mmA (Additional Notes Above, colon and minutes are optional)
		// 1a      =  2 length
		// 10a     =  3 length
		// 1:01p   =  5 length
		// 11:01p  =  6 length
		
		Integer timeStringLength = timeString.length();
		
		string hourString = '';
		string minuteString = '';
		string amPmString = '';
		
		Integer hourNumber = 0;
		Integer minuteNumber = 0;
		Integer timeNumber = 0;
		
		
		// Validate the time string
		if (!isValidTime(timeString)) {
			// error message is set in the isValidTime function
			return 0;
		}		

		// string has been validated so 'a', 'A', 'p', or 'P' 
		// is GUARANTEED to be the last character of the timeString
		amPmString = timeString.substring(timeStringLength - 1);
	
		if (timeStringLength == 2 || timeStringLength == 5) {
			// HA
			hourString = timeString.substring(0, 1);
			if (timeStringLength == 5) {
				// H:mmA
				minuteString = timeString.substring(2, 4);
				minuteNumber = integer.valueOf(minuteString);
			}
		}
		
		if (timeStringLength == 3 || timeStringLength == 6) {
			// HHA
			hourString = timeString.substring(0, 2);
			if (timeStringLength == 6) {
				// HH:mmA
				minuteString = timeString.substring(3, 5);
				minuteNumber = integer.valueOf(minuteString);
			}
		}			
		
		hourNumber = integer.valueOf(hourString);
		
		// hour and minutes have been validated
		// hours are GUARANTEED to be between 1-12
		// minutes are GUARANTEED to be between 00-59

		if (amPmString.toUpperCase() == 'A') {
			if (hourNumber == 12) {						
				timeNumber = minuteNumber;
			}
			else {						
				timeNumber = hourNumber * 60 + minuteNumber;
			}										
		} else {
			if (hourNumber != 12) {
				hourNumber += 12;	
			}
			timeNumber = hourNumber * 60 + minuteNumber;
		}				
		
		return timeNumber;
	}
	
	public Boolean IsValidTimeRange() {
		Boolean isValid = true;
		
		if (i_beginTime == i_endTime) {
			isValid = false;
		}
		
		if (i_endTime <= i_beginTime ) {
			isValid = false;
		}
		
		if (s_errorMessage != '') {
			isValid = false;
		}
		
		return isValid;
	}
	
	public string getErrorMessage() {
		return s_errorMessage;
	}
	
	public Boolean IsValidTime(string timeString) {
		// Valid Time Formats are as follows:  (Additional Notes Above, colon and minutes are optional)
		// HA       1a      =  2 length
		// HHA      10a     =  3 length
		// H:mmA    1:01p   =  5 length
		// HH:mmA   11:01p  =  6 length
		string hourString = '';
		string minuteString = '';
		string amPmString = '';
		Integer hourValue = 0;
		Integer minuteValue = 0;
		Integer colonPosition = 0;
		Boolean isValid = true;
		
		s_errorMessage = '';
	
		if (timeString == null) {
			s_errorMessage = ID_INVALID_TIME_NULL;
			return false;
		}

		if (timeString == '') {
			s_errorMessage = ID_INVALID_TIME_EMPTY;
			return false;
		}
	
		if (timeString.length() < 2 || timeString.length() == 4 || timeString.length() > 6) {
			s_errorMessage = ID_INVALID_TIME_LENGTH;
			return false;
		}
		
		
		amPmString = timeString.substring(timeString.length() - 1,timeString.length());
		if (amPmString.toUpperCase() != 'A' && amPmString.toUpperCase() != 'P') {
			s_errorMessage = ID_INVALID_TIME_AMPMINDICATOR;
			return false;			
		}
		
		colonPosition = timeString.indexOf(':');
		
		if (colonPosition == -1) {
			hourString = timeString.substring(0, timeString.length() - 1);
			minuteString = '0';
		} else {
			hourString = timeString.substring(0, colonPosition);
			minuteString = timeString.substring(colonPosition + 1, timeString.length() - 1);
		}		
		
		try {
			hourValue = integer.valueOf(hourString);
		} catch (Exception hourEx) {
			s_errorMessage = ID_INVALID_TIME_HOUR_NUMERIC;
			return false;
		}
		
		try {
			minuteValue = integer.valueOf(minuteString);
		} catch (Exception minuteEx) {
			s_errorMessage = ID_INVALID_TIME_MINUTE_NUMERIC;
			return false;
		}
		
		if (hourValue < 1 || hourValue > 12) {
			s_errorMessage = ID_INVALID_TIME_HOUR_VALUE; 
			return false;
		}  
		
		if (minuteValue < 0 || minuteValue > 59) {
			s_errorMessage = ID_INVALID_TIME_MINUTE_VALUE;
			return false;		
		}
	
		return true;
	}
    
    public static String getTimeString(Integer timeNumber) {        
        String hourString = '';
        String minuteString = '';
        
        Integer hourNumber = timeNumber / 60;
        Integer minuteNumber = timeNumber - (hourNumber * 60);
        String amPmString = 'AM';        
                
		String timeString = '';
        
        
        if(hourNumber > 12) {
            hourString = (hourNumber - 12).format();
            amPmString = 'PM';
        } else {
            if (hourNumber == 12) {
                amPmString = 'PM';
            }
            
            if (hourNumber == 0) {
            	hourNumber = 12;    
            }
            
			hourString = hourNumber.format();
        }
        if (hourString.length() == 1) {
            hourString = '0' + hourString;
        }        
        
        minuteString = minuteNumber.format();
        if (minuteString.length() == 1) {
            minuteString = '0' + minuteString;
        }
        
        timeString = hourString + ':' + minuteString + ' ' + amPmString;
        
        return timeString;
    }
	
	public static Time getTime(Integer timeNumber){
		Integer hourNumber = timeNumber / 60;
        Integer minuteNumber = timeNumber - (hourNumber * 60);
		Time timeValue = Time.newInstance(hourNumber, minuteNumber, 0, 0);
		
		return timeValue;
	}
    
    public Map<String,String> toTimeRange() {
        Map<String,String> times = new Map<String,String>();
        
        times.put('Begin Time', getTimeString(i_beginTime));
        times.put('End Time', getTimeString(i_endTime));
        
        return times;
    }
		 
}