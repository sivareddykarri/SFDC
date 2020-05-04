/**
@Author :  Siva Karri
@Name   :  LegacyGeoPointeShapeDataSyncTest
@Created Date: 05/11/2019
@Description: Test class for LegacyGeoPointeShapeDataSync Class
@Version:0.1
@Reference: 

**/
@isTest
public class LegacyGeoPointeShapeDataSyncTest {
   @TestSetup 
    public static void initData(){
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
        
        geopointe_Shape_c__x  ExGeoShape = new geopointe_Shape_c__x();
                ExGeoShape.Name__c = 'STIP-16378-shape5';
                ExGeoShape.geopointe_Color_c__c = '#EFFF79';
                ExGeoShape.geopointe_Description_c__c = 'Testing....5-STIP-1678';
                ExGeoShape.geopointe_Dissolve_c__c = false ;
                ExGeoShape.geopointe_Geometry_Last_Modified_c__c = Datetime.now();
                ExGeoShape.geopointe_Invalid_c__c = false;
                ExGeoShape.geopointe_Label_Point_Latitude_s__c = 37.291182;
                ExGeoShape.geopointe_Label_Point_Longitude_s__c = -85.9016895;
                ExGeoShape.geopointe_Lat_Lng_1_c__c = '[[[-85.931559,37.295691],[-85.930529,37.276297],[-85.905809,37.271243],[-85.87182,37.28299],[-85.874567,37.299242],[-85.928125,37.311121],[-85.931559,37.295691]]]';
                ExGeoShape.geopointe_Lat_Max_c__c = 37.311121;
                ExGeoShape.geopointe_Lat_Min_c__c = 37.271243;
                ExGeoShape.geopointe_Lng_Max_c__c = -85.87182;
                ExGeoShape.geopointe_Lng_Min_c__c = -85.931559;
                ExGeoShape.geopointe_Opacity_c__c = 0.2;
                ExGeoShape.geopointe_Personal_c__c = false;
                ExGeoShape.geopointe_Show_Label_c__c = true;
                ExGeoShape.geopointe_Straddles_180_c__c = false;
                ExGeoShape.geopointe_Type_c__c = 'Polygon';
                ExGeoShape.geopointe_Usage_Type_c__c = 'Standard';
                database.insertAsync(ExGeoShape);

        

    }
    /**
    * Description: This test method covers the External GeoPointe Shape data pull to Lightning GeoPointe Shape object
    * @MethodName: LegacyGeoPointeShapeDataSyncMethod1
    * @Created by: Siva Karri
    * @parameters: Null
    * @return:Void
    */
    public static testMethod void LegacyGeoPointeShapeDataSyncMethod1() {
        User curUser =[Select id,UserName from User Where UserName='TestLSDT1234@TestLSDT.com' LIMIT 1];
        System.runAs(curUser){
            try{      
               Batch_Class_Execution_Control__c objwcl = [SELECT Id,Name FROM Batch_Class_Execution_Control__c WHERE Name='LastSuccessfulExecution' LIMIT 1];
 
               list<geopointe__Shape__c > lstShapes = new list<geopointe__Shape__c>();
              
              geopointe__Shape__c gShape = new geopointe__Shape__c(Name = 'Test Key');
                //,shape_External_ID__c= ExGeoShape.ExternalId );
                //ExGeoShape.Name__c,geopointe__Center_Label__c = ExGeoShape.geopointe_Center_Label_c__c ,geopointe__Center__Latitude__s = ExGeoShape.geopointe_Center_Latitude_s__c ,geopointe__Center__Longitude__s = ExGeoShape.geopointe_Center_Longitude_s__c ,geopointe__Color__c = ExGeoShape.geopointe_Color_c__c ,geopointe__Description__c = ExGeoShape.geopointe_Description_c__c ,geopointe__Dissolve__c = ExGeoShape.geopointe_Dissolve_c__c ,geopointe__Geometry_Last_Modified__c = ExGeoShape.geopointe_Geometry_Last_Modified_c__c ,geopointe__Invalid_Reason__c = ExGeoShape.geopointe_Invalid_Reason_c__c ,geopointe__Invalid__c = ExGeoShape.geopointe_Invalid_c__c ,geopointe__Label_Point__Latitude__s = ExGeoShape.geopointe_Label_Point_Latitude_s__c ,geopointe__Label_Point__Longitude__s = ExGeoShape.geopointe_Label_Point_Longitude_s__c ,geopointe__Lat_Lng_1__c = ExGeoShape.geopointe_Lat_Lng_1_c__c ,geopointe__Lat_Lng_2__c = ExGeoShape.geopointe_Lat_Lng_2_c__c ,geopointe__Lat_Lng_3__c = ExGeoShape.geopointe_Lat_Lng_3_c__c ,geopointe__Lat_Lng_4__c = ExGeoShape.geopointe_Lat_Lng_4_c__c ,geopointe__Lat_Lng_5__c = ExGeoShape.geopointe_Lat_Lng_5_c__c ,geopointe__Lat_Lng_6__c = ExGeoShape.geopointe_Lat_Lng_6_c__c ,geopointe__Lat_Lng_7__c = ExGeoShape.geopointe_Lat_Lng_7_c__c ,geopointe__Lat_Lng_8__c = ExGeoShape.geopointe_Lat_Lng_8_c__c ,geopointe__Lat_Lng_9__c = ExGeoShape.geopointe_Lat_Lng_9_c__c ,geopointe__Lat_Lng_10__c = ExGeoShape.geopointe_Lat_Lng_10_c__c ,geopointe__Lat_Max__c = ExGeoShape.geopointe_Lat_Max_c__c ,geopointe__Lat_Min__c = ExGeoShape.geopointe_Lat_Min_c__c ,geopointe__Lng_Max__c = ExGeoShape.geopointe_Lng_Max_c__c ,geopointe__Lng_Min__c = ExGeoShape.geopointe_Lng_Min_c__c ,geopointe__Opacity__c = ExGeoShape.geopointe_Opacity_c__c ,geopointe__Personal__c = ExGeoShape.geopointe_Personal_c__c ,geopointe__Radius__c = ExGeoShape.geopointe_Radius_c__c ,geopointe__Show_Label__c = ExGeoShape.geopointe_Show_Label_c__c ,geopointe__Straddles_180__c = ExGeoShape.geopointe_Straddles_180_c__c ,geopointe__Type__c = ExGeoShape.geopointe_Type_c__c ,geopointe__Units__c = ExGeoShape.geopointe_Units_c__c ,geopointe__Usage_Type__c = ExGeoShape.geopointe_Usage_Type_c__c,Shape_External_ID__c= ExGeoShape.ExternalId   );
                                                 
                                                      lstShapes.add(gShape);
                  

             
                Test.startTest();
                LegacyGeoPointeShapeDataSync ExGeoPntSync  = new LegacyGeoPointeShapeDataSync();
                System.enqueueJob(ExGeoPntSync);
                Test.stopTest();
/*                
                Test.startTest();
Test.stopTest(); // So no chains will execute...
Queueable q1 = new LegacyGeoPointeShapeDataSync();
q1.execute(null);
Queueable q2 = new LegacyStipulationDataSync();
q2.execute(null);
*/
                
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LegacyGeoPointeShapeDataSync','LegacyGeoPointeShapeDataSyncMethod1','External GeoPointe shape Data Sync'); 
            }
        }
    }
     /**
    * Description: This test method covers the Legacy Stipulation Data Sync Batch job
    * @MethodName: LegacyStipulationDataSyncSchedulerBatchMethod1
    * @Created by: Siva Karri
    * @parameters: Null
    * @return:Void
    */
    public static testMethod void LegacyStipulationDataSyncSchedulerBatchMethod1() {
        User curUser =[Select id,UserName from User Where UserName='TestLSDT1234@TestLSDT.com' LIMIT 1];
        System.runAs(curUser){
            try{ 
                Test.startTest();
                LegacyStipulationDataSyncScheduler LStipDataSyncBatch = new LegacyStipulationDataSyncScheduler(); 
                LStipDataSyncBatch.execute(null);
                Test.stopTest();
            }
            catch(exception ex){
                ExceptionHandler.logHandledExceptions(ex,'LegacyStipulationDataSyncScheduler','LegacyStipulationDataSyncSchedulerBatchMethod1','Legacy Stipulation Data Sync Scheduler Batch'); 
            }
        }
    }
    
    
}