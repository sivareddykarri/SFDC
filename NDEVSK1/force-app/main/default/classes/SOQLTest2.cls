//Execution - SOQLTest2.TestMet('test');
public class SOQLTest2 
{
	public static void TestMet(String mstr)
    {
        //List<Contact> conList = [SELECT id,firstname,lastname,email from Contact where lastname = 'Patel' LIMIT 5];
        List<Contact> conList = [SELECT id,firstname,lastname,email from Contact where lastname = :mstr LIMIT 5];
        
        for (Contact cl:conList)
        {
            System.debug('Contact List # '+ cl.id + ' - FN :' + cl.firstname + ' - LN :' + cl.lastname + ' - Email :' + cl.email);
        }
    }
    

}