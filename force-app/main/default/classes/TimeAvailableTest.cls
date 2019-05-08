@isTest
private class TimeAvailableTest {
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
	private static final string ID_INVALID_TIME_RANGE_BEGINTIME  = 'Invalid Time Range: Begin Time';
	private static final string ID_INVALID_TIME_RANGE_ENDTIME = 'Invalid Time Range: End Time';
	private static final string ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN = 'Invalid Time Range: Begin Time must preceed End Time';
		
    
    public static testMethod void timeFormatTest(){
        DateTime testTime = Datetime.now();
        
        String testTimeFormat = testTime.format('yyyy/M/d H:mm a');
        
        String[] timeParts = testTimeFormat.split(' ');
        System.assert(timeParts.size() == 3,'Not Three Parts');
        String yearString = testTime.year().format().replace(',','');
        String monthString = testTime.month().format();
        String dayString = testTime.day().format();
        String datePartString = yearString + '/' + monthString + '/' + dayString;
        String hourString = testTime.hour().format();
        Integer minuteNumber = testTime.minute();
        String minuteString = '';
        if (minuteNumber < 10){
            minuteString = '0' + minuteNumber.format();
        } else {
            minuteString = minuteNumber.format();
        }
        String amPmString = testTimeFormat.substring(testTimeFormat.length() - 2, testTimeFormat.length());
        String timePartString = hourString + ':' + minuteString + ' ' + amPmString;
        String totalTimeString = datePartString  + ' ' + timePartString;
        
        System.assert(totalTimeString == testTimeFormat,'Time Format Expected: >' + totalTimeString + '< Actual >' + testTimeFormat + '<');

    }

	public static testMethod void constructorTest() {
		// null
		TimeAvailable test00 = new TimeAvailable(null);
		System.assert(test00.BeginTime == 0);
		System.assert(test00.EndTime == 0);
		System.assert(test00.getErrorMessage() == ID_INVALID_TIME_RANGE_NULL);
		
		// Less than 5
		TimeAvailable test01 = new TimeAvailable('Sun');
		System.assert(test01.BeginTime == 0);
		System.assert(test01.EndTime == 0);
		System.assert(test01.getErrorMessage() == ID_INVALID_TIME_RANGE_LENGTH);

	
		// Invalid Time Range Length
		TimeAvailable test02 = new TimeAvailable('6-9');
		System.assert(test02.BeginTime == 0);
		System.assert(test02.EndTime == 0);		
		System.assert(test02.getErrorMessage() == ID_INVALID_TIME_RANGE_LENGTH);

		// Too many -
		TimeAvailable test03 = new TimeAvailable('7a-8a-9a');
		System.assert(test03.BeginTime == 0);
		System.assert(test03.EndTime == 0);
		System.assert(test03.getErrorMessage() == ID_INVALID_TIME_RANGE_FORMAT);

		// Invalid Begin Time
		TimeAvailable test04 = new TimeAvailable('1-4:05p');
		System.assert(test04.BeginTime == 0);
		System.assert(test04.EndTime == 0);
		System.assert(test04.getErrorMessage() == ID_INVALID_TIME_RANGE_BEGINTIME);
		
		// Invalid End Time
		TimeAvailable test05 = new TimeAvailable('1:15p-2');
		System.assert(test05.BeginTime == 13 * 60 + 15);
		System.assert(test05.EndTime == 0);
		System.assert(test05.getErrorMessage() == ID_INVALID_TIME_RANGE_ENDTIME);

		// Too few
		TimeAvailable test06 = new TimeAvailable('4:30p');
		System.assert(test06.BeginTime == 0);
		System.assert(test06.EndTime == 0);
		System.assert(test06.getErrorMessage() == ID_INVALID_TIME_RANGE_FORMAT);		
		
		
	}
	
	public static testMethod void propertiesTest() {
		TimeAvailable timeAvail = new TimeAvailable();
		Integer beginTime = 350;
		Integer endTime = 900;
		
		timeAvail.BeginTime = beginTime;
		System.assert(timeAvail.BeginTime == beginTime);
		
		timeAvail.EndTime = endTime;
		System.assert(timeAvail.EndTime == endTime);
		
	}
	
	public static testMethod void getOverlapTest() {
		Integer beginTime = 0;
		Integer endTime = 0;
		Integer overlap = 0; 
		
		// 60 minutes of overlap
		TimeAvailable timeAvail = new TimeAvailable('7a-9a');
		beginTime = 8 * 60;
		endTime = 10 * 60;
		overlap = timeAvail.getOverlap(beginTime, endTime);
		System.assert(overlap == 60);
		
		// ends before
		TimeAvailable test02 = new TimeAvailable('7a-9a');
		beginTime = 6 * 60;
		endTime = 7 * 60;
		overlap = test02.getOverlap(beginTime, endTime);
		System.assert(overlap == 0);
		
		// ends after
		TimeAvailable test03 = new TimeAvailable('7a-9a');
		beginTime = 9 * 60;
		endTime = 10 * 60;
		overlap = test03.getOverlap(beginTime, endTime);
		System.assert(overlap == 0);

		// starts after base start time
		TimeAvailable test04 = new TimeAvailable('7a-9a');
		beginTime = 8 * 60;
		endTime = 10 * 60;
		overlap = test04.getOverlap(beginTime, endTime);
		System.assert(overlap == 60);

		// ends before base end time
		TimeAvailable test05 = new TimeAvailable('7a-9a');
		beginTime = 6 * 60;
		endTime = 8 * 60;
		overlap = test05.getOverlap(beginTime, endTime);
		System.assert(overlap == 60);
		
	}
	
	public static testMethod void IsValidTimeRangeTest() {
		TimeAvailable test01 = new TimeAvailable('7a-7a');
		System.assert(test01.IsValidTimeRange() == false);
		System.assert(test01.getErrorMessage() == ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN);
				
		TimeAvailable test02 = new TimeAvailable('7a-6a');
		System.assert(test02.IsValidTimeRange() == false);
		System.assert(test02.getErrorMessage() == ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN);

		TimeAvailable test03 = new TimeAvailable('7a-8a');
		System.assert(test03.IsValidTimeRange());
		System.assert(test03.getErrorMessage() == '');
		
		TimeAvailable test04 = new TimeAvailable('7:30a-9:30a');
		System.assert(test04.IsValidTimeRange());
		System.assert(test04.getErrorMessage() == '');
	}	
	
	public static testMethod void getTimeNumberTest() {
		Integer timeNumber = 0;
		TimeAvailable timeAvail = new TimeAvailable();
		 
		// len less than 2
		timeNumber = timeAvail.getTimeNumber('1');
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_LENGTH);
		 
		// hour greater than 12
		timeNumber = timeAvail.getTimeNumber('13:14p');
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_HOUR_VALUE);
	
		timeNumber = timeAvail.getTimeNumber('13a');
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_HOUR_VALUE);
	
		// minute greater than 59
		timeNumber = timeAvail.getTimeNumber('2:76p');
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_MINUTE_VALUE);
		
		timeNumber = timeAvail.getTimeNumber('7:60a');
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_MINUTE_VALUE);
		 
		// am/pm indicator other than am/pm
		timeNumber = timeAvail.getTimeNumber('11c');
		System.assert(timeNumber == 0);
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_AMPMINDICATOR);
		
		// len 2
		timeNumber = timeAvail.getTimeNumber('2p');
		System.assert(timeNumber == 14 * 60);
		 
		// len 5
		timeNumber = timeAvail.getTimeNumber('7:15a');
		System.assert(timeNumber == 7 * 60 + 15);		 

		// len 4
		timeNumber = timeAvail.getTimeNumber('7:2a');
		System.assert(timeNumber == 0);
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_LENGTH);		 

		 
		 // len 3
		 timeNumber = timeAvail.getTimeNumber('12a');
		 System.assert(timeNumber == 0);		

		 timeNumber = timeAvail.getTimeNumber('12p');
		 System.assert(timeNumber == 12 * 60);
		 
		 // len 6
		 timeNumber = timeAvail.getTimeNumber('11:41p');
		 System.assert(timeNumber == 23 * 60 + 41);	 
		 			
	}
		
	public static testMethod void IsValidTimeTest() {
		// Valid Time Formats are as follows:  (Additional Notes Above, colon and minutes are optional)
		// HA       1a      =  2 length
		// HHA      10a     =  3 length
		// H:mmA    1:01p   =  5 length
		// HH:mmA   11:01p  =  6 length		
		TimeAvailable timeAvail = new TimeAvailable();		
		Boolean isValidTime; 

		// TEST FOR ERROR HANDLING - INVALID VALUES
		// null
		isValidTime = timeAvail.IsValidTime(null);
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_NULL);
		
		// empty '''
		isValidTime = timeAvail.IsValidTime('');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_EMPTY);		
		
		// invalid length < 2
		isValidTime = timeAvail.IsValidTime('4');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_LENGTH);

		// invalid length == 4
		isValidTime = timeAvail.IsValidTime('4:11');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_LENGTH);		

		// invalid length > 6
		isValidTime = timeAvail.IsValidTime('11:11pm');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_LENGTH);


		// invalid hour - not numeric
		isValidTime = timeAvail.IsValidTime('HH:11p');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_HOUR_NUMERIC);		
		
		// invalid hour - less than 1
		isValidTime = timeAvail.IsValidTime('0:11a');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_HOUR_VALUE);
		
		// invalid hour - greater than 12
		isValidTime = timeAvail.IsValidTime('13:13a');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_HOUR_VALUE);		

		// invalid minute - not numeric
		isValidTime = timeAvail.IsValidTime('12:mmp');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() ==  ID_INVALID_TIME_MINUTE_NUMERIC);		

		// invalid minute - greater than 59
		isValidTime = timeAvail.IsValidTime('1:60a');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_MINUTE_VALUE);


		// invalid am/pm indicator
		isValidTime = timeAvail.IsValidTime('1:25c');
		System.assert(isValidTime == false);
		System.assert(timeAvail.getErrorMessage() == ID_INVALID_TIME_AMPMINDICATOR);

		
		// TEST FOR VALID VALUES
		isValidTime = timeAvail.IsValidTime('12a');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('12A');
		System.assert(isValidTime);		
		System.assert(timeAvail.getErrorMessage() == '');		

		isValidTime = timeAvail.IsValidTime('1a');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('1:00a');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('11:59a');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('12p');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('12:01p');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('1p');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');

		isValidTime = timeAvail.IsValidTime('11:59p');
		System.assert(isValidTime);
		System.assert(timeAvail.getErrorMessage() == '');
	}
    
    public static testMethod void GetTimeStringTest() {
 		TimeAvailable timeAvail = new TimeAvailable();
        String timeString = '';
        
        // AM Scenarios
        timeString = TimeAvailable.getTimeString(0);
        System.assert(timeString == '12:00 AM');
        
        timeString = TimeAvailable.getTimeString(1);
        System.assert(timeString == '12:01 AM');
        
        timeString = TimeAvailable.getTimeString(59);
        System.assert(timeString == '12:59 AM');        
        
        timeString = TimeAvailable.getTimeString(60);
        System.assert(timeString == '01:00 AM');
        
        timeString = TimeAvailable.getTimeString(61);
        System.assert(timeString == '01:01 AM');

        timeString = TimeAvailable.getTimeString(119);
        System.assert(timeString == '01:59 AM', timeString);
        
        timeString = TimeAvailable.getTimeString(719);
        System.assert(timeString == '11:59 AM', timeString);
        
        // PM Scenarios
        timeString = TimeAvailable.getTimeString(720);
        System.assert(timeString == '12:00 PM', timeString);        
        
        timeString = TimeAvailable.getTimeString(721);
        System.assert(timeString == '12:01 PM', timeString);
        
        timeString = TimeAvailable.getTimeString(779);
        System.assert(timeString == '12:59 PM', timeString);
        
        timeString = TimeAvailable.getTimeString(780);
        System.assert(timeString == '01:00 PM', timeString);        
        
        timeString = TimeAvailable.getTimeString(781);
        System.assert(timeString == '01:01 PM', timeString);
        
        timeString = TimeAvailable.getTimeString(795);
        System.assert(timeString == '01:15 PM', timeString);

        timeString = TimeAvailable.getTimeString(1320);
        System.assert(timeString == '10:00 PM', timeString);
        
        timeString = TimeAvailable.getTimeString(1439);
        System.assert(timeString == '11:59 PM', timeString);
    }
    
    public static testMethod void GetTimeTest() {
        Integer nineThirty = 9 * 60 + 30;
     	Time expectedTime = Time.newInstance(9, 30, 0, 0);
        Time actualTime = TimeAvailable.getTime(nineThirty);
        System.assertEquals(expectedTime, actualTime,'Did not work');
    }
    
    public static testMethod void toTimeRangeTest() {
        String BeginTimeExpected = '';
        String EndTimeExpected = '';
        String BeginTimeActual = '';
        String EndTimeActual = '';
        
        BeginTimeExpected = '07:00 AM';
        EndTimeExpected = '05:00 PM';
 		TimeAvailable timeAvail = new TimeAvailable('7a-5p');
        Map<String,String> timesA = timeAvail.toTimeRange();
        BeginTimeActual = timesA.get('Begin Time');
        EndTimeActual = timesA.get('End Time');
        System.assertEquals(BeginTimeExpected,BeginTimeActual);
        System.assertEquals(EndTimeExpected,EndTimeActual);        
        
        Map<String,String> timesB = new Map<String,String>();
        timesB.put('Begin Time',BeginTimeExpected);
        timesB.put('End Time',EndTimeExpected);
		System.assertEquals(timesB, timesA);
        
        
        BeginTimeExpected = '12:00 AM';
        EndTimeExpected = '12:00 PM';
        timeAvail = new TimeAvailable('12a-12p');
        timesA = timeAvail.toTimeRange();
        BeginTimeActual = timesA.get('Begin Time');
        EndTimeActual = timesA.get('End Time');
        System.assertEquals(BeginTimeExpected,BeginTimeActual);
        System.assertEquals(EndTimeExpected,EndTimeActual);        
        
        timesB = new Map<String,String>();
        timesB.put('Begin Time',BeginTimeExpected);
        timesB.put('End Time',EndTimeExpected);
		System.assertEquals(timesB, timesA);
        

        BeginTimeExpected = '12:05 AM';
        EndTimeExpected = '12:45 PM';        
        timeAvail = new TimeAvailable('12:05a-12:45p');
        timesA = timeAvail.toTimeRange();
        BeginTimeActual = timesA.get('Begin Time');
        EndTimeActual = timesA.get('End Time');
        System.assertEquals(BeginTimeExpected,BeginTimeActual);
        System.assertEquals(EndTimeExpected,EndTimeActual);        
        
        timesB = new Map<String,String>();
        timesB.put('Begin Time',BeginTimeExpected);
        timesB.put('End Time',EndTimeExpected);
		System.assertEquals(timesB, timesA);
    }
	
}