global without sharing class Ca_Utilities{
    global List<Cloudaction_Settings__c> caSettings = new List<Cloudaction_Settings__c>();  
  public static List<Cloudaction_Settings__c> pCaSettings = new List<Cloudaction_Settings__c>();  
    public static String sDebugMessage = '';

    //Cloudaction general settings handlers
    public Ca_Utilities()
    {
        //Load settings
        //caSettings = new List<Cloudaction_Settings__c>([Select Id, Description__c, Detail__c, Name, Setting_Name__c, Setting_Value__c from Cloudaction_Settings__c]);
    setup();
    }
    
    private static void setup()
  {
    if(pCaSettings.size() == 0)
    {
      pCaSettings = Cloudaction_Settings__c.getall().values();
      
    }
  }
    public static String getSettingValueByName(String SettingName)
    {
    setup();
        String sRet = '';
        for(Cloudaction_Settings__c setting : pCaSettings)
        {
            if(setting.Setting_Name__c == SettingName)
            {
                sRet = setting.Setting_Value__c;
                break;
            }
        }
        return sRet;
    }
}