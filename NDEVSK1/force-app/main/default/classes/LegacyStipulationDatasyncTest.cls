/**
@Author :  Siva Karri
@Name   :  LegacyStipulationDatasyncTest
@Created Date: 05/11/2019
@Description: Test class for LegacyStipulationDatasync Class
@Version:0.1
@Reference: 

**/
@isTest
Public class LegacyStipulationDatasyncTest {
    @TestSetup 
    Public static void initData(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='Franchise Sales']; 
        User curUser = new User(Alias = 'TestLSDT', Email='TestLSDT@TestLSDT.com', 
                                EmailEncodingKey='UTF-8', LastName='TestingLSDT', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = pro.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='TestLSDT1234@TestLSDT.com');
        Database.insert(curUser,False);
        
        Batch_Class_Execution_Control__c bcec = new Batch_Class_Execution_Control__c();
        bcec.Name = 'LastSuccessfulExecution';
        bcec.LegacyAOPBatch__c = Datetime.now();
        Database.insert(bcec);
        

                Stipulation_c__x  ExSTIPs = new Stipulation_c__x();
                                                        //ExSTIPs.Name__c = 'STIP-16378' ; 
                                                         //ExSTIPs.Active_c__c = true   ;
                                                         ExSTIPs.Approved_Datetime_c__c  = DateTime.now();
                                                         ExSTIPs.Approved_c__c = false  ;
                                                         //ExSTIPs.Brand_c__c = 'SUPER 8'   ;
                                                         //ExSTIPs.Center_Override_c__c = true  ;
                                                         ExSTIPs.Center_Latitude_s__c = 37.2885200284   ;
                                                         ExSTIPs.Center_Longitude_s__c = -85.9005737074 ;
                                                         //ExSTIPs.Effective_Date_c__c = Date.toStartOfMonth()  ;
                                                         //ExSTIPs.Expiration_Date_c__c = Date.toStartOfWeek()  ;
                                                         ExSTIPs.Geocode_Quality_c__c = 'CUSTOM'    ;
                                                         ExSTIPs.GeoCode_Latitude_s__c = 37.2885200284  ;
                                                         ExSTIPs.GeoCode_Longitude_s__c = -85.9005737074    ;
                                                         ExSTIPs.Initial_Radius_Shape_Created_c__c = true   ;
                                                         //ExSTIPs.In_Force_c__c = true ;
                                                         ExSTIPs.Opening_Date_Change_c__c = false   ;
                                                         ExSTIPs.Oracle_Key_c__c = '1212208'    ;
                                                         ExSTIPs.Oracle_SR_Status_c__c = 'WHG - Active' ;
                                                         ExSTIPs.Oracle_Stip_Status_c__c = 'WHG - Active'   ;
                                                         ExSTIPs.Oracle_Stip_Type_c__c = 'WHG STP Area Of Protection'   ;
                                                         //ExSTIPs.Override_Reason_c__c = ''    ;
                                                         ExSTIPs.Prior_Geocode_Latitude_s__c = 37.2885200284    ;
                                                         ExSTIPs.Prior_Geocode_Longitude_s__c = -85.9005737074  ;
                                                         ExSTIPs.Property_Account_Number_c__c = '03257-09888-05-SUP'    ;
                                                         //ExSTIPs.Property_Address_Prior_c__c = '' ;
                                                         ExSTIPs.Property_Geocode_Latitude_s__c = 37.2885371    ;
                                                         ExSTIPs.Property_Geocode_Longitude_s__c = -85.9002733  ;
                                                         ExSTIPs.Property_c__c = 'a0D3900000MTIJpEAP';
                                                         ExSTIPs.Radius_Units_c__c = 'miles'    ;
                                                         ExSTIPs.Radius_c__c =  1.0 ;
                                                         //ExSTIPs.Shape1_Coordinates_c__c = '' ;
                                                         //ExSTIPs.Shape2_Coordinates_c__c = '' ;
                                                         ExSTIPs.Shape2_c__c = 'a2n2F000000C7rlQAC';
                                                         //ExSTIPs.Shape3_Coordinates_c__c = '' ;
                                                         ExSTIPs.Shape3_c__c = 'a2n2F000000C7rqQAC';
                                                         //ExSTIPs.Shape4_Coordinates_c__c = '' ;
                                                         ExSTIPs.Shape4_c__c = 'a2n2F000000C7rvQAC' ;
                                                         //ExSTIPs.Shape5_Coordinates_c__c = '' ;
                                                         ExSTIPs.Shape5_c__c = 'a2n2F000000C7s0QAC' ;
                                                         ExSTIPs.Shape_type_c__c = 'Radius' ;
                                                         ExSTIPs.Shape_c__c = 'a2n390000004h8tAAA'  ;
                                                         ExSTIPs.Stipulation_Text_c__c = 'Testing the Protected Territory...';
                                                         //ExSTIPs.Stipulation_Type_c__c = 'AOP'    ;
                                                         ExSTIPs.Unapproved_c__c = true ;
                                                         ExSTIPs.ExternalId = 'a4G39000000BGsGEAW' ;
            database.insertAsync(ExSTIPs);
     
        Account objAcct = new Account(Name = 'Test123');
               insert objAcct;
        
        //Stipulation_c__x  lSTIPs = new Stipulation_c__x(Property_Account_Number_c__c = '03257-09888-05-SUP');
        //database.insertAsync(lSTIPs);
        
        List<Contract> Cnt = new List<Contract>();
         Cnt.add(new Contract(Name = ExSTIPs.Property_Account_Number_c__c,AccountId = objAcct.Id));
        for (Integer i =0;i<100;i++){
            Cnt.add(new Contract(Name = 'Test Cnt'+i,AccountId = objAcct.Id));
        }
               insert cnt;
        
        
                 List<Stipulation_c__x> lSTIPs = new List<Stipulation_c__x>();
                lSTIPs.add(new Stipulation_c__x(Stipulation_Text_c__c = 'Testing..123',Property_Account_Number_c__c = '03257-09888-05-SUP'));
                
                for (Integer i =0;i<10;i++){
                    lSTIPs.add(new Stipulation_c__x(Stipulation_Text_c__c = 'Test Cnt'+i,Property_Account_Number_c__c = '03257-09888-05-S'+i));
                }
                       database.insertAsync(lSTIPs);
   
    }
    /**
    * Description: This test method covers the External Stipulation data pull to Lightning Stipulation object
    * @MethodName: LegacyStipulationDataSyncMethod1
    * @Created by: Siva Karri
    * @parameters: Null
    * @return:Void
    */
    public static testMethod void LegacyStipulationDataSyncMethod1() {
        User curUser =[Select id,UserName from User Where UserName='TestLSDT1234@TestLSDT.com' LIMIT 1];
        System.runAs(curUser){
            try{

                
                
                Test.startTest();
                LegacyStipulationDataSync ExStipSync  = new LegacyStipulationDataSync();
                System.enqueueJob(ExStipSync);
                Test.stopTest();

            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LegacyStipulationDataSync','LegacyStipulationDataSyncMethod1','External Stipulation Data Sync'); 
            }
        }
     
    }
   
}