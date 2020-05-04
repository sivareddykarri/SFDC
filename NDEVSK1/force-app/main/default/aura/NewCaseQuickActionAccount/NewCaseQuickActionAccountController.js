/* @Author: Prathyusha
   @Name: NewCaseQuickcActionAccountController.Js
   @Created Date: Feb/15/2018
   @Description: Controlls all the functions on the component NewCaseQuickcActionAccountController
   @Version: 0.2
   @Reference: Null
*/
({
    getRecType: function(component, event, helper) {
        helper.getRecTyp(component, event);
    },
    createRec: function(component, event, helper) {
       helper.createRecT(component, event);
    },
    cancelWin : function(component, event, helper) {
       helper.cancelWinH(component, event);
    },
    cancelTab:function(component, event, helper) {
        helper.cancelTabT(component, event);
    }
})