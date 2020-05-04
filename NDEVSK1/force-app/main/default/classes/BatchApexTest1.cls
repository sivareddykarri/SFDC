Global class BatchApexTest1 implements Database.Batchable<sObject>, Schedulable
{
    //start - Initial the record or Data to perform the oprations will run only one time for the whole transaction.
    Global database.QueryLocator Start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([Select Fax from Contact where Fax = null LIMIT 10]);
    }
    
    // Execute - Used to define the Operation which the batch need to perfrom on the data will be exeucted N number fo time.
   Global Void execute(Database.BatchableContext BC,List<Contact> LCon)
   {
       for(Contact c:LCon)
       {
           if(c.fax == null)
           {
               c.fax = '123-456-789';
           }
       }
       update LCon;
    }
    
    // Finish - used gets executed at the end of the batch call execution and executes only one time.
	Global void Finish(Database.BatchableContext BC)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'skarrive@gmail.com','siva.karri@wyndham.com'};
        mail.setToAddresses(toAddress);
        mail.setSubject('NDEVSK1 Batch job completed....!!!');
        mail.setPlainTextBody('Hi, The Contact update batch job on NDEVSK1 is finished....!!!');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
    }
    
    //Schedulable - Is setting it to be scheduled thru Apex Batch class
    Global Void execute(SchedulableContext SC)
    {
        BatchApexTest1 BAT = new BatchApexTest1();
        Database.executeBatch(BAT);
    }
}