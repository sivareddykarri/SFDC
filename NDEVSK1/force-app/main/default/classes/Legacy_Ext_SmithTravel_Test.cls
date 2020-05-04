@IsTest(SeeAllData=true)
public class Legacy_Ext_SmithTravel_Test {
    public static testMethod  void testCallout() {
        
        Test.startTest();
        
        
        Legacy_Ext_SmithTravel.fakeMethod();
        Test.stopTest();
        
    }
}