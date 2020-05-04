//Syntax - trigger <TriggerName> on <SObject> (Trigger_Events)
//
trigger TriggerApexTest1 on Contact (before insert, before update) 
{
    //Contact c = Trigger.New[0];
    //c.fax = '546-000-0000';
    //BULKIFY
    For (Contact cnt: Trigger.new)
    {
        cnt.fax = '000-000-0000';
    }
    
    
}