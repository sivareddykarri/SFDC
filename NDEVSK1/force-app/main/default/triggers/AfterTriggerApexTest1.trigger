trigger AfterTriggerApexTest1 on Contact (after insert, after update) 
{
    //BULKIFY
    For (Contact cnt: Trigger.new)
    {
        cnt.fax = '000-000-0000';
    }
}