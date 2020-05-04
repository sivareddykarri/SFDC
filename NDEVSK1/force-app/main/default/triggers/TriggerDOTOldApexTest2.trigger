//Trigger.old - can be used for only update and Delete events...
trigger TriggerDOTOldApexTest2 on Contact (before update) 
{

    for(Contact oldCont:Trigger.old)
    {
        for(Contact newCont:Trigger.new)
        {
            if(oldCont.id == newCont.id && oldCont.fax != null)
            {
                newCont.addError('Fax can not be updated, as we already have it....!!!');
            }
            
        }
    }
    
}