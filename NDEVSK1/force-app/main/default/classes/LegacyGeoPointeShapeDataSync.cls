/**
@Author :  Jim Zheng
@Name   :  LegacyGeoPointeShapeDataSync
@Created Date: 04/09/2019
@Description: This Class is used to sync AOP/Shape related data from Legacy to New org
@Version:1.0`````````````````````````````````````````````           
@Reference: 
@Revision History:
Siva Karri - May 1st 2019 : Removed and updated all the fields to be retrive.
Siva Karri - May 10th 2019 : Added the custom setting variable to filter the modified ones from last succsees run.
**/

public class LegacyGeoPointeShapeDataSync  implements Queueable {

    private static Boolean doChainJob = true;
    private static Datetime LastSuccessfulRun = Datetime.Valueof(Batch_Class_Execution_Control__c.getValues('LastSuccessfulExecution').LegacyAOPBatch__c);

    public void execute(QueueableContext context) {
        List<geopointe_Shape_c__x > exGshapes = [Select Id, ExternalId, Name__c, geopointe_Center_Label_c__c, geopointe_Center_Latitude_s__c, geopointe_Center_Longitude_s__c, geopointe_Color_c__c, geopointe_Description_c__c, geopointe_Dissolve_c__c, geopointe_Geometry_Last_Modified_c__c, geopointe_Invalid_Reason_c__c, geopointe_Invalid_c__c, geopointe_Label_Point_Latitude_s__c, geopointe_Label_Point_Longitude_s__c, geopointe_Lat_Lng_10_c__c, geopointe_Lat_Lng_1_c__c, geopointe_Lat_Lng_2_c__c, geopointe_Lat_Lng_3_c__c, geopointe_Lat_Lng_4_c__c, geopointe_Lat_Lng_5_c__c, geopointe_Lat_Lng_6_c__c, geopointe_Lat_Lng_7_c__c, geopointe_Lat_Lng_8_c__c, geopointe_Lat_Lng_9_c__c, geopointe_Lat_Max_c__c, geopointe_Lat_Min_c__c, geopointe_Lng_Max_c__c, geopointe_Lng_Min_c__c, geopointe_Opacity_c__c, geopointe_Personal_c__c, geopointe_Radius_c__c, geopointe_Show_Label_c__c, geopointe_Straddles_180_c__c, geopointe_Type_c__c, geopointe_Units_c__c, geopointe_Usage_Type_c__c 
                                                 FROM geopointe_Shape_c__x  
                                                 WHERE LastModifiedDate__c > :LastSuccessfulRun
                                                 ];
        
        list<geopointe__Shape__c > lstShapes = new list<geopointe__Shape__c>();
        
        for(geopointe_Shape_c__x exGshape: exGshapes){geopointe__Shape__c gShape = new geopointe__Shape__c(Name = exGshape.Name__c ,geopointe__Center_Label__c = exGshape.geopointe_Center_Label_c__c ,geopointe__Center__Latitude__s = exGshape.geopointe_Center_Latitude_s__c ,geopointe__Center__Longitude__s = exGshape.geopointe_Center_Longitude_s__c ,geopointe__Color__c = exGshape.geopointe_Color_c__c ,geopointe__Description__c = exGshape.geopointe_Description_c__c ,geopointe__Dissolve__c = exGshape.geopointe_Dissolve_c__c ,geopointe__Geometry_Last_Modified__c = exGshape.geopointe_Geometry_Last_Modified_c__c ,geopointe__Invalid_Reason__c = exGshape.geopointe_Invalid_Reason_c__c ,geopointe__Invalid__c = exGshape.geopointe_Invalid_c__c ,geopointe__Label_Point__Latitude__s = exGshape.geopointe_Label_Point_Latitude_s__c ,geopointe__Label_Point__Longitude__s = exGshape.geopointe_Label_Point_Longitude_s__c ,geopointe__Lat_Lng_1__c = exGshape.geopointe_Lat_Lng_1_c__c ,geopointe__Lat_Lng_2__c = exGshape.geopointe_Lat_Lng_2_c__c ,geopointe__Lat_Lng_3__c = exGshape.geopointe_Lat_Lng_3_c__c ,geopointe__Lat_Lng_4__c = exGshape.geopointe_Lat_Lng_4_c__c ,geopointe__Lat_Lng_5__c = exGshape.geopointe_Lat_Lng_5_c__c ,geopointe__Lat_Lng_6__c = exGshape.geopointe_Lat_Lng_6_c__c ,geopointe__Lat_Lng_7__c = exGshape.geopointe_Lat_Lng_7_c__c ,geopointe__Lat_Lng_8__c = exGshape.geopointe_Lat_Lng_8_c__c ,geopointe__Lat_Lng_9__c = exGshape.geopointe_Lat_Lng_9_c__c ,geopointe__Lat_Lng_10__c = exGshape.geopointe_Lat_Lng_10_c__c ,geopointe__Lat_Max__c = exGshape.geopointe_Lat_Max_c__c ,geopointe__Lat_Min__c = exGshape.geopointe_Lat_Min_c__c ,geopointe__Lng_Max__c = exGshape.geopointe_Lng_Max_c__c ,geopointe__Lng_Min__c = exGshape.geopointe_Lng_Min_c__c ,geopointe__Opacity__c = exGshape.geopointe_Opacity_c__c ,geopointe__Personal__c = exGshape.geopointe_Personal_c__c ,geopointe__Radius__c = exGshape.geopointe_Radius_c__c ,geopointe__Show_Label__c = exGshape.geopointe_Show_Label_c__c ,geopointe__Straddles_180__c = exGshape.geopointe_Straddles_180_c__c ,geopointe__Type__c = exGshape.geopointe_Type_c__c ,geopointe__Units__c = exGshape.geopointe_Units_c__c ,geopointe__Usage_Type__c = exGshape.geopointe_Usage_Type_c__c,Shape_External_ID__c= exGshape.ExternalId
                                                                                                           
                                                                                                          );
                                                      
                                                      lstShapes.add(gShape);
                                                      
                                                     }
       
        Schema.SObjectField fShapeEXID = geopointe__Shape__c.Fields.Shape_External_ID__c;
        
        Database.UpsertResult [] results = Database.upsert(lstShapes, fShapeEXID , false);

        ID jobID = System.enqueueJob(new LegacyStipulationDataSync());
         
    }
    
}