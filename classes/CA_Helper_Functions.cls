global class CA_Helper_Functions 
{                            
    global static String returnstaffname(Id staffid)
    {
        //*** Create variables ***//
        
        String output = '';
        
        if(staffid != null)
        {
            List<User> bh = [Select Id, name, firstname, lastname from User where Id =: staffid limit 1];
            for(User us : bh) 
            {  
                output = ' - ' + us.firstname + ' ' + us.lastname;
            }
        }                
        
        return output;           
    }
}