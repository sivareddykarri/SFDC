/* @Author: Vazeer Mohammed
   @Name: Opportunity_IntegrationController.Js
   @Created Date: May/15/2019
   @Description: Controller class for Opportunity_Integration Lightning Component
   @Version: 0.2
   @Reference:
*/
({
    doInit: function(component, event, helper){
        helper.getOppBrandDetailsValidation(component);
        helper.getOppDetailsValidation(component);        
    },
    sendToLegacyRequest : function(component, event, helper) {
        helper.sendToLegacyRes(component);
    },
})