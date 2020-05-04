//Execution - SOSLTest1.MyMethod();
//Execution - SOSLTest1.MyMethodVar('Patel');
public class SOSLTest1 
{

    public static void MyMethod()
    {
    	List<List<sObject>> L1 = [FIND 'John' Returning Account(Name),Contact(FirstName,LastName),Contract(Name)];
        
        List<Account> Acclist = L1[0];
        List<Contact> Contlist = L1[1];
        List<Contract> Cntlist = L1[2];
        
        for (Account acc : Acclist)
        {
            system.debug('For Account Name : '+ acc.Name);
        }
        
        for (Contact cont : Contlist)
        {
            system.debug('For Contact First Name : '+ cont.FirstName + ' ---> Last Name :' + cont.LastName );
        }
        
        for (Contract cnt : cntlist)
        {
            system.debug('For Contract Name : '+ cnt.Name);
        }
    }
    
    public static void MyMethodVar(String mstr)
    {
    	List<List<sObject>> L1 = [FIND :mstr Returning Contact(FirstName,LastName),Contract(Name)];
        
        List<Contact> Contlist = L1[0];
        List<Contract> Cntlist = L1[1];
        
        for (Contact cont : Contlist)
        {
            system.debug('For Contact First Name : '+ cont.FirstName + ' ---> Last Name :' + cont.LastName );
        }
        
        for (Contract cnt : cntlist)
        {
            system.debug('For Contract Name : '+ cnt.Name);
        }
    }
    
}