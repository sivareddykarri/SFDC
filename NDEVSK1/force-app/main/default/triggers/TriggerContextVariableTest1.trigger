//Context varibles - Trigger Helper Class Design Pattern
// isInsert
// isUpdate
// isDelete
// isunDelete
// isBefore
// isAfter
// Size
// 
trigger TriggerContextVariableTest1 on Contact (before insert,before update,before delete,after insert,after update,after delete) 
{

    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
           system.debug('I am in before Insert'); 
        }
        else if(Trigger.isupdate)
        {
           system.debug('I am in before update'); 
        }
        else if(Trigger.isDelete)
        {
           system.debug('I am in before Delete'); 
        }
        
    }
    else if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
           system.debug('I am in After Insert'); 
        }
        else if(Trigger.isupdate)
        {
           system.debug('I am in After update'); 
        }
        else if(Trigger.isDelete)
        {
           system.debug('I am in After Delete'); 
        }
        else if(Trigger.isUnDelete)
        {
           system.debug('I am in After UnDelete'); 
        }
    }
}