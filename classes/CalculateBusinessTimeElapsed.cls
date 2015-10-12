global class CalculateBusinessTimeElapsed 
{                            
    global static Long calculateBusinessSeconds(DateTime StartDate, DateTime EndDate)
    {
        //*** Create variables ***//
        Long lDateDiff;
        Long output = 0;
        Long tNewStatusState;   
        
        //*** Retrieve Business Hour Values from Default Schedule ***//
        //*** NOTE: Could update this later to select specific schedule in specific circumstances ***//    
        BusinessHours bh = [Select Id, SundayStartTime, MondayStartTime, TuesdayStartTime, WednesdayStartTime, ThursdayStartTime, 
                                FridayStartTime, SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime, WednesdayEndTime, 
                                ThursdayEndTime, FridayEndTime,SaturdayEndTime
                            from BusinessHours 
                            where IsDefault=true];
                        
        //Populate StartDate if it is null
        if(StartDate == null || EndDate == null)
        {
            output = 0;   
        }
        
        //both StartDate and EndDate are not null
        if(StartDate != null && EndDate != null)
        {
            if (!BusinessHours.isWithin(bh.Id,StartDate))
            {
                StartDate = BusinessHours.nextStartDate(bh.Id,StartDate);
            }                    
        
            //*** Calculate Business Hours Elapsed ***//
            lDateDiff = BusinessHours.diff(bh.Id, StartDate, EndDate);
            if(lDateDiff/1000 > 0){output = lDateDiff/1000;}else{output = 0;}            
        }
        return output;           
    }
    
    global static Long calculateBusinessHours(DateTime StartDate, DateTime EndDate)
    {
        //*** Create variables ***//
        Long lDateDiff;
        Long output = 0;
        Long tNewStatusState;   
        
        //*** Retrieve Business Hour Values from Default Schedule ***//
        //*** NOTE: Could update this later to select specific schedule in specific circumstances ***//    
        BusinessHours bh = [Select Id, SundayStartTime, MondayStartTime, TuesdayStartTime, WednesdayStartTime, ThursdayStartTime, 
                                FridayStartTime, SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime, WednesdayEndTime, 
                                ThursdayEndTime, FridayEndTime,SaturdayEndTime
                            from BusinessHours 
                            where IsDefault=true];
                        
        //Populate StartDate if it is null
        if(StartDate == null || EndDate == null)
        {
            output = 0;   
        }
        
        //both StartDate and EndDate are not null
        if(StartDate != null && EndDate != null)
        {
            if (!BusinessHours.isWithin(bh.Id,StartDate))
            {
                StartDate = BusinessHours.nextStartDate(bh.Id,StartDate);
            }                    
        
            //*** Calculate Business Hours Elapsed ***//
            lDateDiff = BusinessHours.diff(bh.Id, StartDate, EndDate);
            if(lDateDiff/1000 > 0){output = lDateDiff/1000;output = output/3600;}else{output = 0;}            
        }
        return output;           
    }
    
    global static String calculateBusinessHMS(DateTime StartDate, DateTime EndDate)
    {
        //*** Create variables ***//
        Long lDateDiff;
        Long output = 0;
        String string_output;
        Long tNewStatusState;   
        
        //*** Retrieve Business Hour Values from Default Schedule ***//
        //*** NOTE: Could update this later to select specific schedule in specific circumstances ***//    
        BusinessHours bh = [Select Id, SundayStartTime, MondayStartTime, TuesdayStartTime, WednesdayStartTime, ThursdayStartTime, 
                                FridayStartTime, SaturdayStartTime, SundayEndTime, MondayEndTime,TuesdayEndTime, WednesdayEndTime, 
                                ThursdayEndTime, FridayEndTime,SaturdayEndTime
                            from BusinessHours 
                            where IsDefault=true];
                        
        //Populate StartDate if it is null
        if(StartDate == null || EndDate == null)
        {
            output = 0;
            string_output = '0:0:0';   
        }
        
        //both StartDate and EndDate are not null
        if(StartDate != null && EndDate != null)
        {
            if (!BusinessHours.isWithin(bh.Id,StartDate))
            {
                StartDate = BusinessHours.nextStartDate(bh.Id,StartDate);
            }                    
        
            //*** Calculate Business Hours Elapsed ***//
            lDateDiff = BusinessHours.diff(bh.Id, StartDate, EndDate);
            if(lDateDiff/1000 > 0){output = lDateDiff/1000;string_output = String.valueOf(Math.roundToLong(Math.floor(output/3600))) + ':' + String.valueOf(Math.roundToLong(Math.floor(Math.mod(output,3600)/60))) + ':' + String.valueOf(Math.mod(Math.mod(output,3600),60));}else{output = 0;string_output = '0:0:0';}            
        }
        return string_output;           
    }
}