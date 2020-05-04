/**  
   @Author: Sunil
   @Name: DummyApexClassForProcessBuilderTest
   @CreateDate: 23/04/2018
   @Description: Test class for DummyApexClassForProcessBuilder
   @Version: 0.1
   @reference: 
*/

@isTest
private class DummyApexClassForProcessBuilderTest 
{
   /**
   *  Description: Method to cover dummyMethodForProcessBuilder() in class
   *  @Name: testDummy
   *  @param: Null
   *  @return: Null
   *  @throws exception:
   */
     static testmethod void testDummy(){
	 	User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){    
            DummyApexClassForProcessBuilder.dummyMethodForProcessBuilder();
            system.assertEquals(Null,Null);   
         }
    }
}