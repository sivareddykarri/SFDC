/**
@Author :  Prathyusha 
@Name   :  PhotoShootTriggerHelper
@Created Date: 26/2/2018
@Description: To handle all Photoshoot operations on Trigger
@Version:0.2
@Reference: 
**/
public with sharing class PhotoShootTriggerHelper {
    /**
    * Description: Used in the NewCaseQuickActionAccount controller to check whether the current user having access on cases.
    * @MethodName:autoShareToConnection
    * @Created by:Prathyusha
    * @parameters:List<Photo_Shoot__c>
    * @return:Void
    * @throws exception:throws exception if the photoShootList list is empty
    */
    public static void autoShareToConnection(List<Photo_Shoot__c> photoShootList){
        String connectionId1=Wyndham_Constants_List__c.getInstance('ConnectionId1').Value__c;
        String connectionId2=Wyndham_Constants_List__c.getInstance('ConnectionId2').Value__c;
        
        List<PartnerNetworkRecordConnection> pnrList=new List<PartnerNetworkRecordConnection>();
        List<Photo_Shoot__c> photoShootFilteredList = new List<Photo_Shoot__c>();
        Set<Id> connSet = new Set<Id>();
        PartnerNetworkRecordConnection pnr;
        Map<String,String> connMap=new Map<String,String>();
        Map<Id, PartnerNetworkConnection> PartnerNetworkConnectionMap = new Map<Id, PartnerNetworkConnection>([SELECT Id, ConnectionStatus, ConnectionName
                                                                                                               FROM PartnerNetworkConnection
                                                                                                               WHERE ConnectionStatus = :ConstantClass.ACCEPTED
                                                                                                               LIMIT 5]);
        try{
            for(Photo_Shoot__c objPst: photoShootList){
                if(objPst.Sharing_Status__c==ConstantClass.SHAREDTOPW || objPst.Sharing_Status__c==ConstantClass.SHAREDTOVRX){
                    photoShootFilteredList.add(objPst);
                }
            }
            for(Photo_Shoot__c objPS: photoShootFilteredList){
                if(objPS.Sharing_Status__c==ConstantClass.SHAREDTOPW){
                    if(PartnerNetworkConnectionMap.keySet().Contains(connectionId1)){
                        pnr=new PartnerNetworkRecordConnection();
                        pnr.ConnectionId=connectionId1;
                        pnr.LocalRecordId=objPS.Id;
                        pnr.SendClosedTasks = true;
                        pnr.SendOpenTasks = true;
                        pnr.SendEmails = true;
                        pnrList.add(pnr);
                    }
                }
                else if(objPS.Sharing_Status__c==ConstantClass.SHAREDTOVRX){
                    if(PartnerNetworkConnectionMap.keySet().contains(connectionId2)){
                        pnr=new PartnerNetworkRecordConnection();
                        pnr.ConnectionId=connectionId2;
                        pnr.LocalRecordId=objPS.Id;
                        pnr.SendClosedTasks = true;
                        pnr.SendOpenTasks = true;
                        pnr.SendEmails = true;
                        pnrList.add(pnr);
                    }
                }
            }
            Database.insert(pnrList,False);
        }
        catch(exception exc){                   
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.PHOTOSHOOTHANDLER,ConstantClass.AUTOSHARETOCONNECTION,ConstantClass.PHOTOWEB_APPLICATION);
        }
    }
    
    /**
    * Description: this is used in S2S Integration on the component PhotoshootconnectionRelatedList to display connections related list used in method getPhotoRecords.
    * @Name:PartnerNetworkWrapper
    * @Created by:Prathyusha
    */
    public with sharing class PartnerNetworkWrapper {
        String ConnectionId {get;set;}
        String Status {get;set;}
        String StartDate {get;set;}
        String EndDate {get;set;}
        String ConnectionName {get;set;}
    }
    
    /**
    * Description: Used in the PhotoshootConnectionRelatedList component controller to check whether the current user having access on cases.
    * @MethodName:getPhotoRecords
    * @Created by:Prathyusha
    * @parameters:Photoshoot Id
    * @return:Connection Name related to Photoshoot
    * @throws exception:throws exception if the PID value null
    */
    @AuraEnabled
    public static string getPhotoRecords(Id PID) {
        
        list<PartnerNetworkWrapper> output = new list<PartnerNetworkWrapper>();
        try{
            PartnerNetworkWrapper prec;
            set<Id> connIDs = new set<Id>();
            for(PartnerNetworkRecordConnection partnerNet:[SELECT ConnectionId,Status,StartDate,EndDate  FROM PartnerNetworkRecordConnection where LocalRecordId=:PID limit 5]){
                prec= new PartnerNetworkWrapper();
                prec.ConnectionId=string.valueOf(partnerNet.get(ConstantClass.CONNECTIONID));
                prec.Status=string.valueOf(partnerNet.get(ConstantClass.STATUS)); 
                prec.StartDate=string.valueOf(partnerNet.get(ConstantClass.STARTDATE)); 
                prec.EndDate=string.valueOf(partnerNet.get(ConstantClass.ENDDATE));
                connIDs.add(prec.ConnectionId);
                output.add(prec);
            }
            map<Id,PartnerNetworkConnection> pNetworkMap = new map<Id,PartnerNetworkConnection>([select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where Id in: connIDs limit 5]);
            for(PartnerNetworkWrapper partnerWrapper:output){
                if(pNetworkMap.get(partnerWrapper.ConnectionId)!=Null){
                    partnerWrapper.ConnectionName=pNetworkMap.get(partnerWrapper.ConnectionId).ConnectionName;
                }
            }
        }
        catch(exception exc) {
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.PHOTOSHOOTHANDLER,ConstantClass.GETPHOTORECORDS,ConstantClass.PHOTOWEB_APPLICATION); 
        }
        return JSON.serialize(output); 
    }   
    /**
    * Description: used to create a case under a photoshoot record where Photo shoot status is UPLOAD FINAL
    * @MethodName:createCaseAutomatically
    * @Created by:Prathyusha
    * @parameters:List<Photo_Shoot__c>
    * @return:Void
    * @throws exception:throws exception if the list is empty
    */
    public static void createCaseAutomatically(List<photo_shoot__c> psList,Map<Id,photo_shoot__c> psOldMap){
        List<Photo_Shoot__c> photoShootFilteredList = new List<Photo_Shoot__c>();
        List<Case> caseList=new List<Case>();
       
        Set<Id> psAccId = new Set<Id>();
        Case objCas;
        try{
            for(Photo_Shoot__c objPSLi:psList){
                if(objPSLi.PhotoShoot_Status__c!=null && objPSLi.PhotoShoot_Status__c.equals(ConstantClass.UPLOADFINAL) && !psOldMap.get(objPSLi.Id).PhotoShoot_Status__c.equals(ConstantClass.UPLOADFINAL)){
                    photoShootFilteredList.add(objPSLi);
                    psAccId.add(objPSLi.Account__c);
                }
            }
            Group  objGroup=[SELECT Id,Name FROM Group 
                             WHERE Name=:ConstantClass.MRCONTENT2QUEUE 
                             AND Type =:ConstantClass.QUEUE
                             LIMIT 1];
            for(Photo_shoot__c objPS:photoShootFilteredList){
                objCas=new Case();
                objCas.AccountId=objPS.Account__c;
                objCas.ContactId=objPS.Contact_Name__c;
                objCas.Status=ConstantClass.NEWSTATUS;
                objCas.Origin=ConstantClass.AUTOGENERATED;
                objCas.Priority=ConstantClass.MEDIUMPRIORITY;
                objCas.RecordTypeId=ConstantClass.CASEDISTRECTYPEID;
                objCas.Case_Type__c=ConstantClass.CASETYPERATESOTA;
                objCas.Case_Sub_Type__c=ConstantClass.CONTENTTYPE;
                objCas.Case_Subject__c=ConstantClass.PHOTOSPERFROMVENDOR;
                objCas.Photo_Shoot__c=objPS.Id;
                if(objGroup.Id!=NULL){
                    objCas.OwnerId=objGroup.Id;
                }
                caseList.add(objCas);
            }
            if(!caseList.isEmpty()){
                Database.insert(caseList,False);
            }
        }
        catch(exception exc) {
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.PHOTOSHOOTHANDLER,ConstantClass.CREATECASEAUTOMATICALLY,ConstantClass.PHOTOWEB_APPLICATION); 
        }
    }
}