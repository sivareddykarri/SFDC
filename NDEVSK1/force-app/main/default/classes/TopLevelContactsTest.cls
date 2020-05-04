/** 
 @Author: Siva Karri
 @Name: TopLevelContactsTest
 @Created Date: 10/1/2019
 @Description: To cover the Test scenarios on Top Level Contacts Componenet.
 @Version: 0.1
 @reference:
**/

@isTest
public class TopLevelContactsTest { 

        static testmethod void TopLevelContactsTest()
        {
                Test.startTest();
                    TopLevelContacts.getTopLevelContacts('0011I00000gQkPAQA0');
                    TopLevelContacts.getTopLevelContacts('8001I000000YvbwQAC');
                    //TopLevelContacts.getTopLevelContacts('0060g00000y6vB3AAI');
                Test.stopTest();

        }
       
}