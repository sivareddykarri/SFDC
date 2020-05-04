@IsTest(SeeAllData=true)
public class Legacy_Ext_CSR_Report_Test {
    public static testMethod  void testCallout() {
        
        Test.startTest();
        
        
        Legacy_Ext_CSR_Report.fakeMethod();
        Test.stopTest();
        
    }
}