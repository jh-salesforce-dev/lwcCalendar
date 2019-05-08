@isTest
private class DayAvailableTest {
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

    public static testMethod void WalzemTest(){
        List<String> daStrings = new List<String>();
        
        daStrings.add('TF 7:30-9:30');
        daStrings.add('TH 130-3');
        daStrings.add('THF 9:30-3');
        daStrings.add('TH 130-3');
        daStrings.add('THF 9:30-3');
        daStrings.add('TTH 9:30 -3');
        daStrings.add('Tue 2:00p-3p; 4p-7pp');
        daStrings.add('Thu1:30p-3p');
        //daStrings.add('Tue 9:30a-3p; ');
        //daStrings.add(' Thu 9:30a-3p');
        //daStrings.add(' Thu 9:30a-3p ');
        daStrings.add('');

        
        for(String daString : daStrings){
            DayAvailable da = new DayAvailable(daString);
            System.debug(daString + ': ' + da.getErrorMessage());
            System.assert(da != null);
            System.assert(da.TimesAvailable.size() ==0);
            
        }
    }
    
    public static testMethod void ContactTest() {
		// sun
		string tueString = 'Tue 12:19p-2p,2a-4a';
        string wedString = 'Wed 9a-4p';
        string thuString = 'Thu 10a-12p';
        string friString = 'Fri 12:15p-2:30p,9p-11p';
        
		DayAvailable tueD = new DayAvailable(tueString);
		System.assert('Tue' == tueD.DayAbbreviation, 'Tue Abbrev doesnt match');
		System.assert(tueD.TimesAvailable.size() ==2,'Tuesday times available is not 2');
        
        DayAvailable wedD = new DayAvailable(wedString);
        System.assert('Wed' == wedD.DayAbbreviation, 'Wed Abbrev doesnt match');
        System.assert(wedD.TimesAvailable.size() == 1,'Wed times available is not 1');
        TimeAvailable wedTime1 = wedD.TimesAvailable[0];
        System.assert(wedTime1.BeginTime == 9*60,'incorrect begin time');
        System.assert(wedTime1.EndTime == 16*60,'incorrect end time' );
        
    }
    
	public static testMethod void GetDateTest() {
		// sun
		DayAvailable sunD = new DayAvailable('Sun 1a-2a');
		System.assert('Sun' == sunD.DayAbbreviation, 'Sun Abbrev doesnt match');
		Date expectedDateSun = Date.today().toStartOfWeek();
		Date actualDateSun = sunD.GetDate();
		System.assertEquals(expectedDateSun, actualDateSun, 'Sun Date doesn Equal');
		
		// mon
		DayAvailable monD = new DayAvailable('Mon 8a-1p');
		System.assert('Mon' == monD.DayAbbreviation, 'Mon Abbrev doesnt match');
		Date expectedDateMon = Date.today().toStartOfWeek().addDays(1);
		Date actualDateMon = monD.GetDate();
		System.assertEquals(expectedDateMon, actualDateMon, 'Mon Date doesn Equal');
		
		// tue
		DayAvailable tueD = new DayAvailable('Tue 12p-3p');
		System.assert('Tue' == tueD.DayAbbreviation, 'Tue Abbrev doesnt match');
		Date expectedDateTue = Date.today().toStartOfWeek().addDays(2);
		Date actualDateTue = tueD.GetDate();
		System.assertEquals(expectedDateTue, actualDateTue, 'Tue Date doesn Equal');
		
		// wed
		DayAvailable wedD = new DayAvailable('Wed 8a-9a');
		System.assert('Wed' == wedD.DayAbbreviation, 'Wed Abbrev doesnt match');
		Date expectedDateWed = Date.today().toStartOfWeek().addDays(3);
		Date actualDateWed = wedD.GetDate();
		System.assertEquals(expectedDateWed, actualDateWed, 'Wed Date doesn Equal');		

		//thu
		DayAvailable thuD = new DayAvailable('Thu 1p-4p');
		System.assert('Thu' == thuD.DayAbbreviation, 'Thu Abbrev doesnt match');
		Date expectedDateThu = Date.today().toStartOfWeek().addDays(4);
		Date actualDateThu = thuD.GetDate();
		System.assertEquals(expectedDateThu, actualDateThu, 'Thu Date doesn Equal');		
		
		// fri
		DayAvailable friD = new DayAvailable('Fri 11-2p');
		System.assert('Fri' == friD.DayAbbreviation, 'Fri Abbrev doesnt match');
		Date expectedDateFri = Date.today().toStartOfWeek().addDays(5);
		Date actualDateFri = friD.GetDate();
		System.assertEquals(expectedDateFri, actualDateFri, 'Fri Date doesn Equal');
	}

	
    public static testMethod void GetDateTimeTest() {
        Integer timeNumber = 9 * 60 + 15;
        Date dToday = Date.today().toStartOfWeek();
        DayAvailable daSun = new DayAvailable('Sun 7a-1p');
        
        System.assertEquals('Sun', daSun.DayAbbreviation, 'Day Abbreviation');
        Integer iYear = dToday.year();
        Integer iMonth = dToday.month();
        Integer iDay = dToday.day();
        
        DateTime expected = DateTime.newInstance(iYear, iMonth, iDay, 9, 15, 0);
        DateTime actual = daSun.GetDateTime(timeNumber);
        
        System.assertEquals(expected, actual,'Sun date time does not equal');
		
		// Monday
		DayAvailable daMon = new DayAvailable('Mon 8a-12p');		
		timeNumber = 13 * 60 + 26;
		
		dToday = Date.today().toStartOfWeek().addDays(0);
		iYear = dToday.year();
        iMonth = dToday.month();
        iDay = dToday.day();
		
		expected = DateTime.newInstance(iYear, iMonth, iDay, 13, 26, 0);
		actual = daSun.GetDateTime(timeNumber);
		System.assertEquals(expected, actual,'Mon date time does not equal');
    }

	
	public static testMethod void constructorTest() {
		DayAvailable test01 = new DayAvailable(null);
		System.assert(test01.DayAbbreviation == '');
		System.assert(test01.getErrorMessage() == ID_INVALID_DAY_NULL);
		
		DayAvailable test02 = new DayAvailable('');
		System.assert(test02.DayAbbreviation == '');
		System.assert(test02.getErrorMessage() == ID_INVALID_DAY_EMPTY);

		DayAvailable test03 = new DayAvailable('Sun 7a-1');
		System.assert(test03.DayAbbreviation == '');
		System.assert(test03.getErrorMessage() == ID_INVALID_DAY_LENGTH);				


		DayAvailable test04 = new DayAvailable('Sun 7a-12p');
		System.assert(test04.DayAbbreviation == 'Sun');
		System.assert(test04.getErrorMessage() == ID_INVALID_DAY_VALUE);

		DayAvailable test05 = new DayAvailable('Wed 8a-7a');
		System.assert(test05.DayAbbreviation == 'Wed');
		System.assert(test05.getErrorMessage() == ID_INVALID_TIME_RANGE_ENDBEFOREBEGIN);
		System.assert(test05.TimesAvailable.size() == 0);

		DayAvailable test06 = new DayAvailable('Wed 8a-10p');
		System.assert(test06.DayAbbreviation == 'Wed');
		System.assert(test06.getErrorMessage() == '');
		System.assert(test06.TimesAvailable.size() == 1);
		
		System.debug('starting test 07');
		DayAvailable test07 = new DayAvailable('Fri 12a-1a, 10a-11a,1p-4p');
		System.assert(test07.DayAbbreviation == 'Fri');
		System.debug(test07.getErrorMessage());
		System.assert(test07.getErrorMessage() == '');
		System.assert(test07.TimesAvailable.size() == 3);
		
	}
	
	public static testMethod void propertiesTest() {
		DayAvailable dayAvail = new DayAvailable('Mon 7a-9a');
		string dayAbbrev = 'Tue';
		List<TimeAvailable> times = new List<TimeAvailable>();
		times.add(new TimeAvailable('7a-9a'));
		
		dayAvail.DayAbbreviation = dayAbbrev;
		System.assert(dayAbbrev == dayAvail.DayAbbreviation);
	
		dayAvail.TimesAvailable = times;
		System.assert(times == dayAvail.TimesAvailable);
		
	}
	
	public static testMethod void IsValidDayAbbreviationTest(){
		DayAvailable dayAvail = new DayAvailable('Mon 7a-9a');
		Boolean isValid = false;
	
		dayAvail.DayAbbreviation = null;
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_NULL);

		dayAvail.DayAbbreviation = '';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_EMPTY);

		dayAvail.DayAbbreviation = 'M';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_LENGTH);

		dayAvail.DayAbbreviation = 'Mo';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_LENGTH);

		dayAvail.DayAbbreviation = 'Thur';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_LENGTH);
		
		dayAvail.DayAbbreviation = 'Sat';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid == false);
		System.assert(dayAvail.getErrorMessage() == ID_INVALID_DAY_VALUE);
		
		
		dayAvail.DayAbbreviation = 'Mon';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid);
		System.assert(dayAvail.getErrorMessage() == '');
		
		dayAvail.DayAbbreviation = 'Tue';
		isValid = dayAvail.IsValidDayAbbreviation();
		System.assert(isValid);
		System.assert(dayAvail.getErrorMessage() == '');
				
	}
	
	public static testMethod void HasValidTimeRangesTest() {
		DayAvailable test01 = new DayAvailable('Mon 7a-9a');
		System.assert(test01.HasValidTimeRanges());
		
		DayAvailable test02 = new DayAvailable('Mon 7a-9:71a');
		System.assert(test02.HasValidTimeRanges() == false);		
	}
	
	public static testMethod void IsValidTest() {
		DayAvailable test01 = new DayAvailable('Sat 7a-9a');
		System.assert(test01.IsValid() == false);
		
		DayAvailable test02 = new DayAvailable('Mon 7a-9:71a');
		System.assert(test02.IsValid() == false);		
		
		DayAvailable test03 = new DayAvailable('Mon 7a-9:01a');
		System.assert(test03.IsValid());		
	}
	
	public static testMethod void IsAvailableTest() {
		DayAvailable baseAvail = new DayAvailable('Mon 7a-9a');
		DayAvailable compAvail = new DayAvailable('Tue 7a-9a');
		
		Boolean isAvail = baseAvail.IsAvailable(compAvail, 60);
		System.assert(isAvail == false);
		
		baseAvail = new DayAvailable('Mon 7a-9a');
		compAvail = new DayAvailable('Mon 7a-8a');
		
		isAvail = baseAvail.IsAvailable(compAvail, 60);
		System.assert(isAvail == true);
	}
	
	public static testMethod void toDateTimeArrayTest() {
		DayAvailable baseAvail = new DayAvailable('Mon 7a-9a');
		List<Map<String,String>> listOfMaps = baseAvail.toDateTimeArray();
		
		System.assert(listOfMaps.size() > 0);
		Map<String,String> singleMap = listOfMaps[0];
		
		String beginTime = singleMap.get('Begin Datetime');
		String endTime = singleMap.get('End Datetime');
		
		//System.assert(beginTime.endsWith('07:00 AM'));
		//System.assert(endTime.endsWith('09:00 AM'));
	}
	
}