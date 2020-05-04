/**
@Author :  Narsimhulu 
@Name   :  ContentVersionTriggerHelper
@Created Date: 25/06/2018
@Description: To handle all ContentVersion operations on Trigger
@Version:0.2
@Reference: 
**/
public with sharing class ContentVersionTriggerHelper {
    /**
    * Description: used to restrict .exe files in live agent
    * @MethodName:restrictExeFiles
    * @Created by:Narsimhulu
    * @parameters:List<ContentVersion>
    * @return:Void
    * @throws exception:throws exception if the ContentVersion list is empty
    */
    public static void restrictExeFiles(List<ContentVersion> cvList){
        String strFilename;
        for (ContentVersion ObjConver :cvList){
            strFilename = ObjConver.PathOnClient;
            if(strFilename.contains('.exe')){
                ObjConver.addError('Sorry - APEX Blocked File with this extension - could not be attached!!');
            }
        } 
    }
}