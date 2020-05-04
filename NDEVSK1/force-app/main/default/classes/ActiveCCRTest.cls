/** 
 @Author: Siva Karri
 @Name: ActiveCCRTest
 @Created Date: 2/4/2020
 @Description: To cover the Test scenarios on Active CCR Contacts Component.
 @Version: 0.1
 @reference:
**/

@isTest
public class ActiveCCRTest { 

        static testmethod void ActiveCCRTest()
        {
                Test.startTest();
                    ActiveCCR.getActiveCCRs('0031I00000aIcn9QAC');
                    ActiveCCR.getActiveCCRs('8001I000000YvbwQAC');
                Test.stopTest();

        }
       
}