//execution - SOQLTest1.TestMeth();
public class SOQLTest1 
{    
    public static void TestMeth()
    {
    	List<Account> acctList = [SELECT id,name from Account LIMIT 10];
        
        for (integer i=0;i<acctList.size();i++)
        {
            system.debug('For 1st Loop of '+ i + ' - Name :'+ acctList[i].name);
        }

        for (Account acc:acctList)
        {
            system.debug('For 2nd Loop id : '+ acc.id + ' with Name :'+ acc.name);
        }

    }

}