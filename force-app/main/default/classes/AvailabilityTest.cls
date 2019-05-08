@isTest
private class AvailabilityTest {
	public static testMethod void Constructor() {
		Availability avail = new Availability();
		System.assert(avail != null);
	}
    
    
    public static testMethod void WalezmTest01(){
        String walzemAvailString = 'Mon 8:50a-9:50a;Tue 8:50a-9:50a;Wed 8:50a-9:50a;Thu 8:50a-9:50a;Fri 8:50a-9:50a';
        Availability wAvail = new Availability(walzemAvailString);     
        
        List<String> avStrings = new List<String>();
        
		Availability av01 = new Availability('Mon 12p-1:30p,1:30p-3p,4p-7p;Tue 1:30p-3p;Wed 7:30a-9:30a,9:30a-12p,12p-1:30p,1:30p-3p,4p-7p;Thu 1:30p-3p;Fri 7:30a-9:30a,9:30a-12p,12p-1:30p,1:30p-3p');
        Availability walzemA = Availability.GetIntersection(wAvail, av01);        
        
        
        avStrings.add('Tue 1:30p-3p;Thu 1:30p-3p');
        avStrings.add('Tue 1:30p-3p;Wed 1:30p-3p;Thu 1:30p-3p;Fri 1:30p-3p');
        avStrings.add('Tue 12p-1:30p');
        avStrings.add('Tue 12p-1:30p,1:30p-3p,4p-7p;Thu 12p-1:30p,4p-7p;Fri 7:30a-9:30a,1:30p-3p,4p-7p');
        avStrings.add('Tue 12p-1:30p,1:30p-3p;Thu 7:30a-9:30a');
        avStrings.add('Tue 12p-1:30p,1:30p-3p;Wed 12p-1:30p,1:30p-3p');
        avStrings.add('Tue 12p-1:30p,1:30p-3p;Wed 12p-1:30p,1:30p-3p;Thu 12p-1:30p,1:30p-3p');
        avStrings.add('Tue 12p-1:30p;Thu 12p-1:30p');
        avStrings.add('Tue 12p-1:30p;Wed 12p-1:30p;Thu 12p-1:30p');
        avStrings.add('Tue 12p-1:30p;Wed 12p-1:30p;Thu 12p-1:30p;Fri 12p-1:30p');
        avStrings.add('Tue 4p-7p;Thu 4p-7p');
        avStrings.add('Tue 4p-7p;Thu 4p-7p;Fri 9:30a-12p,12p-1:30p');
        avStrings.add('Tue 4p-7p;Wed 1:30p-3p;Thu 1:30p-3p;Fri 12p-1:30p,1:30p-3p');

        avStrings.add('Tue 7:30a-9:30a');
        avStrings.add('Tue 7:30a-9:30a,9:30a-12p');
        avStrings.add('Tue 7:30a-9:30a,9:30a-12p;Thu 7:30a-9:30a,9:30a-12p');
        avStrings.add('Tue 7:30a-9:30a;Thu 7:30a-9:30a');
        avStrings.add('Tue 7:30a-9:30a;Wed 7:30a-9:30a;Thu 7:30a-9:30a');
        avStrings.add('Tue 7:30a-9:30a;Wed 9:30a-12p;Thu 9:30a-12p;Fri 7:30a-9:30a');
        avStrings.add('Tue 9:15a-10:15a,1:30p-2:30p;Wed 9:15a-10:15a,1:30p-2:30p;Thu 9:15a-10:15a,1:30p-2:30p');
        avStrings.add('Tue 9:30a-12p');
        avStrings.add('Tue 9:30a-12p,12p-1:30p,1:30p-3p;Thu 9:30a-12p,12p-1:30p,1:30p-3p;Fri 9:30a-12p,12p-1:30p,1:30p-3p');
        avStrings.add('Tue 9:30a-12p,12p-1:30p;Wed 12p-1:30p;Thu 12p-1:30p;Fri 7:30a-9:30a');
        avStrings.add('Tue 9:30a-12p,12p-1:30p;Wed 9:30a-12p,12p-1:30p;Thu 9:30a-12p,12p-1:30p;Fri 9:30a-12p,12p-1:30p');
        avStrings.add('Tue 9:30a-12p;Thu 7:30a-9:30a,9:30a-12p,12p-1:30p');
        avStrings.add('Tue 9:30a-12p;Thu 9:30a-12p');
        avStrings.add('Tue 9:30a-12p;Wed 9:30a-12p');
        avStrings.add('Tue 9:30a-12p;Wed 9:30a-12p,12p-1:30p,1:30p-3p;Thu 9:30a-12p,12p-1:30p,1:30p-3p;Fri 9:30a-12p,12p-1:30p,1:30p-3p');
        avStrings.add('Wed 1:30p-3p,4p-7p');
        avStrings.add('Wed 12p-1:30p');
        avStrings.add('Wed 12p-1:30p,1:30p-3p');
        avStrings.add('Wed 12p-1:30p,1:30p-3p;Thu 12p-1:30p,1:30p-3p');
        avStrings.add('Wed 12p-1:30p;Fri 9:30a-12p');
        avStrings.add('Wed 12p-1:30p;Fri 9:30a-12p,12p-1:30p');
        avStrings.add('Wed 12p-1:30p;Thu 12p-1:30p,1:30p-3p');
        avStrings.add('Wed 4p-7p;Fri 1:30p-3p');		
        avStrings.add('Wed 7:30a-9:30a');        
		avStrings.add('Wed 7:30a-9:30a;Fri 7:30a-9:30a');
        avStrings.add('Wed 9:30a-12p');
        avStrings.add('Wed 9:30a-12p,12p-1:30p');
        
        for(String avString : avStrings){
        	Availability avTest = new Availability(avString);
            Availability miTest = Availability.GetIntersection(walzemA, avTest);
            if (miTest != null){
         	   List<webSchedulerEvent> intEvents = miTest.toSchedulerEventArray();
        	}
        }
        
        
    }
    
    public static testMethod void walzemTest03(){
        String walzemAvailString = 'Mon 8:50a-9:50a;Tue 8:50a-9:50a;Wed 8:50a-9:50a;Thu 8:50a-9:50a;Fri 8:50a-9:50a';
        Availability wAvail = new Availability(walzemAvailString);
        System.assert(wAvail != null);
        System.assert(wAvail.DaysAvailable.size() == 5,'Incorrect Number of Days');        
        List<webSchedulerEvent> wEvents = wAvail.toSchedulerEventArray();
        System.assert(wEvents.size() == 5,'Incorrect Number of Events');
        
        Availability avTest = new Availability('Wed 4p-7p;Fri 1:30p-3p');
        System.assert(avTest != null);
        System.assert(avTest.DaysAvailable.size() == 2,'Incorrect Number of Days');
        System.assert(avTest.DaysAvailable[0].TimesAvailable.size() == 1, 'Test Availablitiy Wed Times is incorrect');
        System.assert(avTest.DaysAvailable[1].TimesAvailable.size() == 1, 'Test Availablitiy Fri Times is incorrect');
        List<webSchedulerEvent> aEvents = avTest.toSchedulerEventArray();
        System.assert(aEvents.size() == 2,'Incorrect Number of Events');
        
        Availability miTest = Availability.GetIntersection(wAvail, avTest);
        System.assert(miTest == null, 'miTest is not null, but should be');
    }
    
    public static testMethod void walzemTest02(){
        String walzemAvailString = 'Mon 8:50a-9:50a;Tue 8:50a-9:50a;Wed 8:50a-9:50a;Thu 8:50a-9:50a;Fri 8:50a-9:50a';
        Availability wAvail = new Availability(walzemAvailString);
        
        String maggieAllen = null;        
        Availability maggieAllenAvail = new Availability(maggieAllen);
        system.assert(maggieAllenAvail != null);
        Availability mi01Avail = Availability.GetIntersection(wAvail, maggieAllenAvail);
        
        
        //003U0000007By5VIAS
		String michelleValedez = 'T&TH 10-11';
        Availability michelleValedezAvail = new Availability(michelleValedez);
        system.assert(michelleValedezAvail != null);
        List<webSchedulerEvent> michelleValedezEvents = michelleValedezAvail.toSchedulerEventArray();
        System.assert(michelleValedezEvents.size() == 0,'Has Values but shouldnt');
        
        //003U0000007By2fIAC
        String allisonMitchell = 'F 9-10';
        Availability allisonMitchellAvail = new Availability(allisonMitchell);
        system.assert(allisonMitchellAvail != null);
        List<webSchedulerEvent> allisonMitchellEvents = allisonMitchellAvail.toSchedulerEventArray();
        System.assert(allisonMitchellEvents.size() == 0,'Has Values but shouldnt');        
        
        // 003U0000007By5rIAC
        String emilyWeiss = 'T&TH 730-3';
        Availability emilyWeissAvail = new Availability(emilyWeiss);
        system.assert(emilyWeissAvail != null);
        List<webSchedulerEvent> emilyWeissEvents = emilyWeissAvail.toSchedulerEventArray();
        System.assert(emilyWeissEvents.size() == 0,'Has Values but shouldnt');

        // 003U0000007BxysIAC
        String jenniferGottardy = 'M 8-12 T 10-12';
        Availability jenniferGottardyAvail = new Availability(jenniferGottardy);
        system.assert(jenniferGottardyAvail != null);
        List<webSchedulerEvent> jenniferGottardyEvents = jenniferGottardyAvail.toSchedulerEventArray();
        System.assert(jenniferGottardyEvents.size() == 0,'Has Values but shouldnt');
        
        Availability av01 = new Availability('M&T&F 730-3');
        System.assert(av01.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av02 = new Availability('M,T,F: 7:30 a.m.-9:30');
        System.assert(av02.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av03 = new Availability('M-F 830-2');
        System.assert(av03.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av04 = new Availability('M-F 930-3');
        System.assert(av04.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av05 = new Availability('MF afterschool 4-7');
        System.assert(av05.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av06 = new Availability('MTW 730-12');
        System.assert(av06.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av07 = new Availability('MW 7:30-12');
        System.assert(av07.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av08 = new Availability('MWF 12-3');
        System.assert(av08.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av09 = new Availability('MWF 7:30- 12');
        System.assert(av09.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av10 = new Availability('T 1-3');
        System.assert(av10.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av11 = new Availability('T&TH 10-11');
        System.assert(av11.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av12 = new Availability('T&TH&F 730-12');
        System.assert(av12.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av13 = new Availability('T&TH 12-3');
        System.assert(av13.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av14 = new Availability('T&TH 730-3');
        System.assert(av14.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
        Availability av15 = new Availability('T&TH&F 730-930');
        System.assert(av15.toSchedulerEventArray().size() == 0,'Has Values but shouldnt');
        
    }
    
    
    public static testMethod void contactTest(){
        string timeRangeString = 'Tue 12:19p-2p,2a-4a;Wed 9a-4p;Thu 10a-12p;Fri 12:15p-2:30p,9p-11p';
        Availability ta = new Availability(timeRangeString);
       
		System.assert(ta != null);
		System.assert(ta.DaysAvailable.size() == 4,'Actual was ' + ta.DaysAvailable.size().format());
		System.assert(ta.DaysAvailable[0].TimesAvailable.size() == 2);
		System.assert(ta.DaysAvailable[1].TimesAvailable.size() == 1);
        System.assert(ta.DaysAvailable[2].TimesAvailable.size() == 1);
        System.assert(ta.DaysAvailable[3].TimesAvailable.size() == 2);
    }
    
    public static testMethod void toSiteScheduleTest(){
        Account acct = new Account(Name='Test Acct');
        insert acct;
        
        String schoolYear = '2015-2016';        
        
        string timeRangeString = 'Mon 1p-3p;Tue 1p-3p;Wed 1p-3p;Thu 1p-3p;Fri 1p-3p';
        
        Availability siteAvail = new Availability(timeRangeString);
        List<Site_Schedule__c> siteSchedule = siteAvail.toSiteSchedule(schoolYear, acct.Id, 5);
        
        System.assert(siteSchedule != null, 'Is null, but shouldnt be');
    }

    public static testMethod void researchAndDevelopmentTest(){
    	// test
    	string timeRangeString = 'Mon 1p-3p;Tue 1p-3p;Wed 1p-3p;Thu 1p-3p;Fri 1p-3p';
        Availability siteAvail = new Availability(timeRangeString);
        
        System.assert(siteAvail.DaysAvailable.size() == 5,'Number of Days available not as expected');
        

        Integer tempBeginTimeValue;
        Integer tempEndTimeValue;
        
        Integer expectedNumberOfRecords = 10;
        Integer actualNumberOfRecords = 0;
        
        for(DayAvailable da : siteAvail.DaysAvailable){

            for(TimeAvailable ta : da.TimesAvailable){
                tempBeginTimeValue = ta.BeginTime;
                tempEndTimeValue = tempBeginTimeValue + 60;
                while (tempEndTimeValue <= ta.EndTime){
                    if(ta.getOverlap(tempBeginTimeValue, tempEndTimeValue) >= 60){
                        // Create Schedule Record
                        	actualNumberOfRecords++;
                    	// 
                    } // end if getOverlap
					tempBeginTimeValue = tempEndTimeValue;
                    tempEndTimeValue = tempBeginTimeValue + 60;                     
                } // end while
            } // end for time
        } // end for days
        
        System.assert(expectedNumberOfRecords == actualNumberOfRecords,'Expected: 5, Actual:' + actualNumberOfRecords.format());
        
    }
    
	public static testMethod void appTest() {
		
		string timeRangeString = 'Mon 1:30p-3p,4p-7p;Tue 1:30p-3p,4p-7p;Wed 1:30p-3p,4p-7p;Thu 1:30p-3p,4p-7p;Fri 1:30p-3p,4p-7p';
		Availability test1 = new Availability(timeRangeString);
		System.assert(test1 != null);
		System.assert(test1.DaysAvailable.size() == 5);
		System.assert(test1.DaysAvailable[0].TimesAvailable.size() == 2);
		System.assert(test1.DaysAvailable[1].TimesAvailable.size() == 2);
	}
	
	
	public static testMethod void IsAvailableTest() {
		Boolean isAvailable = false;
		
		// base before, compare after
		isAvailable = Availability.IsAvailable('Mon 8a-9a','Mon 9a-11a',30);
		System.assert(!isAvailable);
		 
		 // base after, compare before
		isAvailable = Availability.IsAvailable('Mon 8a-9a','Mon 7a-8a',30);
		System.assert(!isAvailable);

		// before overlap
		String baseString = 'Mon 8a-10a';
		String compString = 'Mon 7a-9a';
		Availability base = new Availability(baseString);
		System.assert(base.DaysAvailable.size() == 1);
		System.assert(base.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(base.DaysAvailable[0].TimesAvailable[0].BeginTime == 480);
		System.assert(base.DaysAvailable[0].TimesAvailable[0].EndTime == 600);
		
		Availability comp = new Availability(compString);
		System.assert(comp.DaysAvailable.size() == 1);
		System.assert(comp.DaysAvailable[0].DayAbbreviation == 'Mon');		
		System.assert(comp.DaysAvailable[0].TimesAvailable[0].BeginTime == 420); // 7a 420
		System.assert(comp.DaysAvailable[0].TimesAvailable[0].EndTime == 540);   // 9a 540
		
		isAvailable = Availability.IsAvailable(baseString, compString, 30);
		System.assert(isAvailable);


		// after overlap
		baseString = 'Mon 8a-10a';
		compString = 'Mon 9a-11a';
		base = new Availability(baseString);
		System.assert(base.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(base.DaysAvailable[0].TimesAvailable[0].BeginTime == 480);
		System.assert(base.DaysAvailable[0].TimesAvailable[0].EndTime == 600);
				
		comp = new Availability(compString);
		System.assert(comp.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(comp.DaysAvailable[0].TimesAvailable[0].BeginTime == 540);
		System.assert(comp.DaysAvailable[0].TimesAvailable[0].EndTime == 660);
		
		System.assert(base.DaysAvailable[0].DayAbbreviation == comp.DaysAvailable[0].DayAbbreviation);
		
		isAvailable = Availability.IsAvailable(baseString, compString, 30);
		System.assert(isAvailable);
						 
		isAvailable = Availability.IsAvailable('Mon 8a-9a','Mon 8a-9a',30);
		System.assert(isAvailable);
	}
	
	public static testMethod void ConstructorsTest() {
		// No Parameters
		Availability test1 = new Availability();		
		System.assert(test1 != null);
		System.assert(!test1.IsValid());
		
		test1 = new Availability('Mon 2p-1a');
		System.assert(!test1.IsValid());
		
		// One Day One Time 12a
		Availability test2 = new Availability('Mon 12a-1a');
		System.assert(test2 != null);
		System.assert(test2.IsValid());
		System.assert(test2.DaysAvailable.size() == 1);
		System.assert(test2.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(test2.DaysAvailable[0].TimesAvailable.size() == 1);		
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].BeginTime == 0);
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].EndTime == 60);
		
		// One Day One Time Invalid Day
		Availability test3 = new Availability('Sun 12a-1a');
		System.assert(test3 != null);
		System.assert(!test3.IsValid());
		System.assert(test3.DaysAvailable.size() == 0);
		

	}
	
	public static testMethod void AvailabilityConstructorTest() {		
		// One Day One Time 12a
		Availability test2 = new Availability('Mon 12a-1a');
		System.assert(test2 != null);
		System.assert(test2.DaysAvailable.size() == 1);
		System.assert(test2.DaysAvailable[0].TimesAvailable.size() == 1);
		System.assert(test2.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].BeginTime == 0);
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].EndTime == 60);
		
		// One Day One Time 
		test2 = new Availability('Mon 8a-9a');
		System.assert(test2 != null);
		System.assert(test2.DaysAvailable.size() == 1);
		System.assert(test2.DaysAvailable[0].TimesAvailable.size() == 1);
		System.assert(test2.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].BeginTime == 480);
		System.assert(test2.DaysAvailable[0].TimesAvailable[0].EndTime == 540);
		
		// One Day One Time with minutes 12:01a
		Availability t3 = new Availability('Mon 7a-1:01p');
		System.assert(t3 != null);
		System.assert(t3.DaysAvailable.size() == 1);
		//System.assert(t3.DaysAvailable[0].TimesAvailable.size() == 1);
		//System.assert(t3.DaysAvailable[0].DayAbbreviation == 'Mon');
		//System.assert(t3.DaysAvailable[0].TimesAvailable[0].BeginTime == 1);
		//System.assert(t3.DaysAvailable[0].TimesAvailable[0].EndTime == 60);
		
		// One Day One Time with minutes 12:01a
		t3 = new Availability('Mon 12:01a-1:06a');
		System.assert(t3 != null);
		System.assert(t3.DaysAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(t3.DaysAvailable[0].TimesAvailable[0].BeginTime == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable[0].EndTime == 66);

		// One Day One Time with minutes 12:01a
		t3 = new Availability('Mon 12:01a-1:06a');
		System.assert(t3 != null);
		System.assert(t3.DaysAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].DayAbbreviation == 'Mon');
		System.assert(t3.DaysAvailable[0].TimesAvailable[0].BeginTime == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable[0].EndTime == 66);
		
		// One Day Two Time
		t3 = new Availability('Mon 12a-1a,1p-4p');
		System.assert(t3 != null);
		System.assert(t3.DaysAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable.size() == 2);
		
		
		// One Day Three Time
		t3 = new Availability('Fri 12a-1a, 10a-11a,1p-4p');
		System.assert(t3 != null);
		System.assert(t3.DaysAvailable.size() == 1);
		System.assert(t3.DaysAvailable[0].TimesAvailable.size() == 3);


		// Two Day Multiple Times
		Availability test4 = new Availability('Thu 12:19p-1p,2a-4a;Fri 12p-2p,3:15p-7p,9p-11p');
		System.assert(test4 != null);
		System.assert(test4.DaysAvailable.size() == 2);
		System.assert(test4.DaysAvailable[0].TimesAvailable.size() == 2);
		System.assert(test4.DaysAvailable[1].TimesAvailable.size() == 3);
		System.assert(test4.DaysAvailable[0].TimesAvailable[0].BeginTime == 739);
		System.assert(test4.DaysAvailable[0].TimesAvailable[0].EndTime == 780);
						
	}

	public static testMethod void toSchedulerEventArrayTest() {
		Availability test4 = new Availability('Thu 12:19p-1p,2a-4a;Fri 12p-2p,3:15p-7p,9p-11p');
		List<webSchedulerEvent> events = test4.toSchedulerEventArray();
		
		System.assert(events.size() > 0);
	}
	
}