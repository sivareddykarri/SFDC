/**
@Author :  Jim Zheng
@Name   :  LegacyStipulationDataSync
@Created Date: 04/09/2019
@Description: This Class is used to sync AOP/STIPULATION related data from Legacy to New org
@Version:1.0`````````````````````````````````````````````           
@Reference: 
@Revision History:
Siva Karri - May 2nd 2019 : Added the Contract lookup field update logic
Siva Karri - May 9th 2019 : updated the filter logic with the custom variable
**/

public class LegacyStipulationDataSync implements Queueable {

        public void execute(QueueableContext context) {
            
           // string PAN= '52937-16844-02-LFD'; //SFR-001889 
                    
            Datetime LastSuccessfulRun = Datetime.Valueof(Batch_Class_Execution_Control__c.getValues('LastSuccessfulExecution').LegacyAOPBatch__c);

            list<Stipulation__c> lstSTIPs =  new list<Stipulation__c>();
                    

                    list<Stipulation_c__x > lstEXSTIPs =[SELECT id, Name__c , 
                                                         Active_c__c    ,
                                                         Approved_Datetime_c__c ,
                                                         Approved_c__c  ,
                                                         Approver_c__c ,
                                                         Brand_c__c ,
                                                         Center_Override_c__c   ,
                                                         Center_Latitude_s__c   ,
                                                         Center_Longitude_s__c  ,
                                                         Effective_Date_c__c    ,
                                                         Expiration_Date_c__c   ,
                                                         Geocode_Quality_c__c   ,
                                                         GeoCode_Latitude_s__c  ,
                                                         GeoCode_Longitude_s__c ,
                                                         Initial_Radius_Shape_Created_c__c  ,
                                                         In_Force_c__c  ,
                                                         Opening_Date_Change_c__c   ,
                                                         Oracle_Key_c__c    ,
                                                         Oracle_SR_Status_c__c  ,
                                                         Oracle_Stip_Status_c__c    ,
                                                         Oracle_Stip_Type_c__c  ,
                                                         Override_Reason_c__c   ,
                                                         Prior_Geocode_Latitude_s__c    ,
                                                         Prior_Geocode_Longitude_s__c   ,
                                                         Property_Account_Number_c__c   ,
                                                         Property_Address_Prior_c__c    ,
                                                         Property_Geocode_Latitude_s__c ,
                                                         Property_Geocode_Longitude_s__c    ,
                                                         Property_c__c  ,
                                                         Radius_Units_c__c  ,
                                                         Radius_c__c    ,
                                                         Shape1_Coordinates_c__c    ,
                                                         Shape2_Coordinates_c__c    ,
                                                         Shape2_c__c    ,
                                                         Shape3_Coordinates_c__c    ,
                                                         Shape3_c__c    ,
                                                         Shape4_Coordinates_c__c    ,
                                                         Shape4_c__c    ,
                                                         Shape5_Coordinates_c__c    ,
                                                         Shape5_c__c    ,
                                                         Shape_type_c__c    ,
                                                         Shape_c__c ,
                                                         Stipulation_Text_c__c  ,
                                                         Stipulation_Type_c__c  ,
                                                         Unapproved_c__c    ,
                                                         ExternalId 
                                                         FROM Stipulation_c__x 
                                                         where LastModifiedDate__c > :LastSuccessfulRun
                                                         ]; 
                                                          
                                                         // where Property_Account_Number_c__c =:PAN //SFR-001889 
                                                        
                   
                    
                    //  Link Shape from STIP to Shape
                      ID newShapeID,newShape2ID,newShape3ID,newShape4ID,newShape5ID,newContractID;
            
                    for(Stipulation_c__x stip1: lstEXSTIPs )
                    {
                        if (stip1.Property_Account_Number_c__c!=null)  //text data
                        {
                            list<Contract> lstContractIds=[select id  from Contract where Name=:stip1.Property_Account_Number_c__c] ;
                            if (lstContractIds.size()>0)
                            {
                                    newContractID=lstContractIds[0].id;
                            }
                        }
                        
                        
                        if (stip1.Shape_c__c!=null)  //text data
                        {
                           list<geopointe_Shape_c__x> lstEXShapes=[select name__c  from geopointe_Shape_c__x where ExternalId=:stip1.Shape_c__c] ;
                            if (lstEXShapes.size()>0)
                            {
                               list<geopointe__Shape__c> lstShapes=[select id  from geopointe__Shape__c where name=:lstEXShapes[0].name__c] ;
                                if (lstShapes.size()>0)
                                {
                                    newShapeID=lstShapes[0].id;
                                } 
                            }
                        }
                        
                        if (stip1.Shape2_c__c!=null)  //text data
                        {
                            list<geopointe_Shape_c__x> lstEXShapes=[select name__c  from geopointe_Shape_c__x where ExternalId=:stip1.Shape2_c__c] ;
                            if (lstEXShapes.size()>0)
                            {
                                list<geopointe__Shape__c> lstShapes=[select id  from geopointe__Shape__c where name=:lstEXShapes[0].name__c] ;
                                if (lstShapes.size()>0)
                                {
                                   newShape2ID=lstShapes[0].id;
                               } 
                            }
                        }
                        
                        if (stip1.Shape3_c__c!=null)  //text data
                        {
                           list<geopointe_Shape_c__x> lstEXShapes=[select name__c  from geopointe_Shape_c__x where ExternalId=:stip1.Shape3_c__c] ;
                            if (lstEXShapes.size()>0)
                            {
                                list<geopointe__Shape__c> lstShapes=[select id  from geopointe__Shape__c where name=:lstEXShapes[0].name__c] ;
                                if (lstShapes.size()>0)
                                {
                                     newShape3ID=lstShapes[0].id;
                                } 
                           }
                        }
                        
                        if (stip1.Shape4_c__c!=null)  //text data
                        {
                           list<geopointe_Shape_c__x> lstEXShapes=[select name__c  from geopointe_Shape_c__x where ExternalId=:stip1.Shape4_c__c] ;
                            if (lstEXShapes.size()>0)
                            {
                                list<geopointe__Shape__c> lstShapes=[select id  from geopointe__Shape__c where name=:lstEXShapes[0].name__c] ;
                                if (lstShapes.size()>0)
                                {
                                    newShape4ID=lstShapes[0].id;
                                } 
                           }
                        }
                        
                        if (stip1.Shape5_c__c!=null)  //text data
                        {
                           list<geopointe_Shape_c__x> lstEXShapes=[select name__c  from geopointe_Shape_c__x where ExternalId=:stip1.Shape5_c__c] ;
                            if (lstEXShapes.size()>0)
                            {
                                list<geopointe__Shape__c> lstShapes=[select id  from geopointe__Shape__c where name=:lstEXShapes[0].name__c] ;
                                if (lstShapes.size()>0)
                                {
                                    newShape5ID=lstShapes[0].id;
                               } 
                           }
                        }
                        
                        Stipulation__c newSTIP = new Stipulation__c(
                            Legacy_Stipulation_Key__c = Stip1.Name__c,                            
                            Active__c = Stip1.Active_c__c,
                            Approved_Datetime__c = Stip1.Approved_Datetime_c__c,
                            Approved__c = Stip1.Approved_c__c,
                            Approver__c = Stip1.Approver_c__c,
                            Brand__c = Stip1.Brand_c__c,
                            Center__Latitude__s = Stip1.Center_Latitude_s__c,
                            Center__Longitude__s = Stip1.Center_Longitude_s__c,
                            Effective_Date__c = Stip1.Effective_Date_c__c,
                            Expiration_Date__c = Stip1.Expiration_Date_c__c,
                            Geocode_Quality__c = Stip1.Geocode_Quality_c__c,
                            GeoCode__Latitude__s = Stip1.GeoCode_Latitude_s__c,
                            GeoCode__Longitude__s = Stip1.GeoCode_Longitude_s__c,
                            In_Force__c = Stip1.In_Force_c__c,                       
                            Initial_Radius_Shape_Created__c = Stip1.Initial_Radius_Shape_Created_c__c,                       
                            Opening_Date_Change__c = Stip1.Opening_Date_Change_c__c,
                            Oracle_Key__c = Stip1.Oracle_Key_c__c,
                            Oracle_SR_Status__c = Stip1.Oracle_SR_Status_c__c,
                            Oracle_Stip_Status__c = Stip1.Oracle_Stip_Status_c__c,
                            Oracle_Stip_Type__c = Stip1.Oracle_Stip_Type_c__c,
                            Override_Reason__c = Stip1.Override_Reason_c__c,
                            Prior_Geocode__Latitude__s = Stip1.Prior_Geocode_Latitude_s__c,
                            Prior_Geocode__Longitude__s = Stip1.Prior_Geocode_Longitude_s__c,
                            Property_Account_Number__c = Stip1.Property_Account_Number_c__c,
                            Property_Address_Prior__c = Stip1.Property_Address_Prior_c__c,
                            Property_Geocode__Latitude__s = Stip1.Property_Geocode_Latitude_s__c,
                            Property_Geocode__Longitude__s = Stip1.Property_Geocode_Longitude_s__c,
                            Property__c = Stip1.Property_c__c,
                            Radius_Units__c = Stip1.Radius_Units_c__c,
                            Radius__c = Stip1.Radius_c__c,
                            Shape1_Coordinates__c = Stip1.Shape1_Coordinates_c__c,
                            Shape2_Coordinates__c = Stip1.Shape2_Coordinates_c__c,
                            Shape2__c = newShape2ID,
                            Shape3_Coordinates__c = Stip1.Shape3_Coordinates_c__c,
                            Shape3__c = newShape3ID,
                            Shape4_Coordinates__c = Stip1.Shape4_Coordinates_c__c,
                            Shape4__c = newShape4ID,
                            Shape5_Coordinates__c = Stip1.Shape5_Coordinates_c__c,
                            Shape5__c = newShape5ID,
                            Shape1__c = newShapeID,
                            Shape_Type__c = Stip1.Shape_Type_c__c,
                            Stipulation_Type__c = Stip1.Stipulation_Type_c__c,
                            Stipulation_Text__c = Stip1.Stipulation_Text_c__c,
                            Unapproved__c = Stip1.Unapproved_c__c,
                            Contract_Id__c = newContractID,
                            STIP_External_ID__c = Stip1.ExternalId
                        );
                        lstSTIPs.add(newSTIP );
                    }
                    
                    Schema.SObjectField f = Stipulation__c.Fields.STIP_External_ID__c;

                    Database.UpsertResult [] results = Database.upsert(lstSTIPs, f, false);
            
                    //update of the Successful Last execution run date and time
                    Batch_Class_Execution_Control__c UpdateLastRun = [SELECT id FROM Batch_Class_Execution_Control__c WHERE name = 'LastSuccessfulExecution'];
                    //SFR-001889  - block Batch_Class_Execution_Control__c update
                     upsert new Batch_Class_Execution_Control__c(
                        id = UpdateLastRun.id,
                        LegacyAOPBatch__c = Datetime.now()
                    ); 

                }
}