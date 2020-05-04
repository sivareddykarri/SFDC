//Execute seperate chunks of lines...
//Execute in Anonymous window - DMLTest1.UpdateDML();
public class DMLTest1 
{

    Public static void InsertDML()
    {
        // Insert
        List<Account> accList = new List<Account>();
        
        for (integer i=1;i<3;i++)
        {
            Account a = new Account (Name= 'Siva 2 : ' + i);
            accList.add(a);
        }
        
        insert accList;
    }
    
    Public static void UpdateDML()
    {
        // Update
        List<Account> accList = [select name,EXT_Site_Id__c from Account where Name Like '%Test%' order by Name];
        
        for (Account a:accList)
        {
            a.Name = 'Update ' + a.Name;
        }
        
        Update accList;
    }
        
    Public static void UpsertDML()
    {
        // Upsert
        List<Account> accList = [select name,EXT_Site_Id__c from Account where Name Like 'Update%' order by Name];
        integer num1=0;
        
        for (Account a1:accList)
        {
            a1.EXT_Site_Id__c = '000'+num1;
            num1++;
        }
        
        for (integer i=1;i<10;i++)
        {
            Account a = new Account (Name= 'Siva Test Account 2 : ' + i);
            accList.add(a);
        }
        
        Upsert accList;
    }
    
    Public static void DeleteDML()
    {
        // Delete
        List<Account> accList = [select name,EXT_Site_Id__c from Account where Name Like 'Update%' or Name Like 'Siva%' order by Name];
        
        Delete accList;
    }

    Public static void UnDeleteDML()
    {
        // UnDelete - Key word ALL ROWS need to be added at the end of SOQL
        List<Account> accList = [select name,EXT_Site_Id__c from Account where Name Like 'Update%' or Name Like 'Siva%' order by Name ALL ROWS];
        
        UnDelete accList;
    }    
    
    Public static void MergeDML()
    {
        // Merge - The destination sObject chile recrods would be moved to the first one and 2nd one would be deleted.
        Account a1 = [select name from Account where Name = 'Siva 2 : 1'];
        Account a2 = [select name from Account where Name = 'Siva 2 : 2'];
        
        Merge a1 a2;
    }    
    
}