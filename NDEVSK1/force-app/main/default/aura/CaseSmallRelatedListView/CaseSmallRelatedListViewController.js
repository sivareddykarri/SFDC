/* @Author :     Prathyusha
   @Name	 :     CaseSmallRelatedListViewController.Js
   @Created Date: FEb/15/2018
   @Description: controlls all the functions on the component  CaseSmallRelatedListViewController
   @Version:0.2
   @Reference:*/
({
    doInit: function(component, event, helper) {
        helper.getCases(component);
        helper.setFlag(component);
    },
    showFilt:function(component, event, helper) {
        helper.showFilter(component,event);
    },
    createCase:function(component, event, helper) {
        helper.crtCase(component, event);
    },
    gotoCase : function (component, event, helper) {
        helper.dispCase(component,event);
    },
 })