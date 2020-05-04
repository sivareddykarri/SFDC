/** 
@Author : Vazeer Mohammed
@Name   : PhotoshootTriggerHandler
@Created Date: 06/06/2018
@Description: Handler Class for the PhotoShoot trigger.
@Version:0.1
@Reference: 
**/
public without sharing class PhotoshootTriggerHandler extends TriggerHandler {
    
    private Map<Id, Photo_Shoot__c> oldMap;
    private List<Photo_Shoot__c> newList;
    
    /**
    * Description: Constructor of the class, which will intialize oldMap, newMap variables with Tigger.oldMap, Trigger.newMap respectively 
    * @MethodName: PhotoshootTriggerMainHandler
    * @Created by: Vazeer
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public PhotoshootTriggerHandler() {
        this.oldMap = (Map<Id, Photo_Shoot__c>) Trigger.oldMap;
        this.newList = (List<Photo_Shoot__c>) Trigger.new;
    }
    
    /**
    * Description: Override method of TriggerHandler class, which will call autoShareToConnection and createCaseAutomatically from PhotoShootTriggerHandler 
    * @MethodName: beforeInsert
    * @Created by: prathyusha
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void beforeInsert(){
       // PhotoShootTriggerHelper.populateAccountNameatVendor(this.newList,this.oldMap);  
    }
    /**
    * Description: Override method of TriggerHandler class, which will call autoShareToConnection and createCaseAutomatically from PhotoShootTriggerHandler 
    * @MethodName: afterUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterUpdate(){
        PhotoShootTriggerHelper.autoShareToConnection(this.newList);
        PhotoShootTriggerHelper.createCaseAutomatically(this.newList,this.oldMap);
    }
}