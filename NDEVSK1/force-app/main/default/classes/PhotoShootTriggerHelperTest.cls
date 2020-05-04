/**
@Author :     Prathyusha
@Name   :     PhotoShootTriggerHelperTest
@Created Date: 2/2/2018
@Description: To cover the Test scenarios on PhotoShootTriggerHandler.
@Version:0.2
@Reference: 
**/
@isTest
Private class PhotoShootTriggerHelperTest{
    /**
    * Description:
    * @MethodName:photoshootAutoShareConnectionTest
    * @Created by:Prathyusha
    * @parameters:Null
    * @return:Void
    */
    private static testMethod void photoshootAutoShareConnectionTest(){   
        User curUser=new User(Id=UserInfo.getUserId());
        List<Photo_Shoot__c> photoShootList = new List<Photo_Shoot__c>();
        Test.loadData(Wyndham_Constants_List__c.sObjectType, 'WyndhamConstantsList');
        System.runAs(curUser){
            try{
                Account objAcc = ApexDataUtil.createSiteRecTypeRecord();
                Contact objCon = ApexDataUtil.createContactRecord(objAcc);
                objAcc.General_Manager__c=objCon.Id;
                Database.update(objAcc);               
                
                Photo_Shoot__c objPS=new Photo_Shoot__c(Onboarding_Fee_Amount_Paid__c =10.0);
                photoShootList.add(objPS);
                Photo_Shoot__c objPS2=new Photo_Shoot__c(Onboarding_Fee_Amount_Paid__c =9.0);
                photoShootList.add(objPS2);
                Database.insert(photoShootList);
                
                Test.startTest();
                objPS.Sharing_Status__c='Shared To PW';
                objPS.Account__c=objAcc.Id;
                objPS.Bypass_VR_PS_002__c=true;
                Database.update(objPS);
                
                objPS2.Sharing_Status__c='Shared To VRX';
                objPS2.Bypass_VR_PS_002__c=true;
                Database.update(objPS2);
                
                objPS.PhotoShoot_Status__c='Upload Final';
                objPS.Bypass_VR_PS_002__c=true;
                Database.update(objPS);
                Test.stopTest();                
                
                PhotoShootTriggerHelper.getPhotoRecords(objPS.Id);
                System.assertEquals(objPS.PhotoShoot_Status__c,'Upload Final');
            }
            catch(exception exc) {
                ExceptionHandler.logHandledExceptions(exc,'PhotoShootTriggerHandler','photoshootAutoShareConnectionTest','PhotoShoot Web Application'); 
            }
        }
    }
}