/** 
@Author : Vazeer Mohammed
@Name   : CaseTriggerHandler
@Created Date: 06/06/2018
@Description: Handler Class for the Case trigger.
@Version:0.1
@Reference: 
**/
public without sharing class CaseTriggerHandler extends TriggerHandler {
    
    private Map<Id,Case> oldMap;
    private Map<Id,Case> newMap;
    private List<Case> newList;
    private List<Case> oldList;
    
    /**
    * Description: Constructor of the class, which will intialize oldMap, newMap variables with Tigger.oldMap, Trigger.newMap respectively 
    * @MethodName: CaseTriggerMainHandler
    * @Created by: Vazeer
    * @parameters: NA
    * @return: NA
    * @throws: NA
    */
    public CaseTriggerHandler() {
        this.oldMap = (Map<Id,Case>) Trigger.oldMap;
        this.newMap = (Map<Id,Case>) Trigger.newMap;
        this.newList = (List<Case>) Trigger.new;
        this.oldList = (List<Case>) Trigger.old;
    }

    /**
    * Description: Override method of TriggerHandler class, which will call updateSLAFieldOnCase, updateAccount from CaseTriggerHandler
    * @MethodName: beforeInsert
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */   
    public override void beforeInsert(){
        if(ConstantClass.isBeforeInsertFirstTime){
            ConstantClass.isBeforeInsertFirstTime=false;
            CaseTriggerHelper.updateLegacyFieldsNull(this.newList);//Using this for Defect D-1164
            CaseTriggerHelper.updateSLAFieldOnCase(this.newList); //Using  This for Request 058
            CaseTriggerHelper.updateAccount(this.newList); // Using for Request 198
            CaseTriggerHelper.updateContactOnCase(this.newList);
        }
    }
    
    /**
    * Description: Override method of TriggerHandler class, which will call updatePMSystemField from CaseTriggerHandler
    * @MethodName: afterInsert
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterInsert(){
        if(ConstantClass.isAfterInsertFirstTime){
            ConstantClass.isAfterInsertFirstTime=false;
            CaseTriggerHelper.updatePMSystemField(this.newList);//Using for Request 072
        }
    }
    
    /**
    * Description: Override method of TriggerHandler class, which will call updateSLAFieldOnCase, displayErrorOnParentCase from CaseTriggerHandler
    * @MethodName: beforeUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void beforeUpdate(){
        if(ConstantClass.isBeforeUpdateFirstTime){
            ConstantClass.isBeforeUpdateFirstTime=false;
            CaseTriggerHelper.updateSLAFieldOnCase(this.newList);  //Using  This for Request 058
            CaseTriggerHelper.displayErrorOnParentCase(this.newList); //Using  This for Request 034
        }
    }
    
    /**
    * Description: Override method of TriggerHandler class, which will call sendPushNotificationtoCaseOwner from CaseTriggerHandler
    * @MethodName: afterUpdate
    * @Created by: Vazeer
    * @parameters: NA
    * @return: void
    * @throws: NA
    */
    public override void afterUpdate(){
        if(ConstantClass.isAfterUpdateFirstTime){
            ConstantClass.isAfterUpdateFirstTime=false;
            CaseTriggerHelper.sendPushNotificationtoCaseOwnerWhenClosed(this.newList,this.oldMap); //Using  This for Request 080   
            CaseTriggerHelper.updateChildRecordsToAbortedWhenParentAborted(this.newList);
        }        
    }
}