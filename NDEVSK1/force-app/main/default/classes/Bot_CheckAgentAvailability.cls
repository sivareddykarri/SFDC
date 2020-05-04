/***
@Author : Vazeer
@Name   : Bot_CheckAgentAvailability
@Created Date: 8/27/2019
@Description: Class to check Agent Availability on omni-channel for Bot related queues.
@Version:0.3
@Reference: @InvocableVariable
**/
public with sharing class Bot_CheckAgentAvailability {
    private static final String BOTTRANSFERCBID = Wyndham_Constants_List__c.getInstance('BotTransferChatButtonId').Value__c;
    public class AgentAvailabilityOutput{
        @InvocableVariable(required=true)
        public Boolean bAgentTransferAvailability;
    }
    /***
    @Author : Vazeer
    @Name   : AgentAvailabilityInput
    @Created Date: 8/27/2019
    @Description: Wrapper Class that Stores all the input Parameters
    @Version:0.3
    @Reference: @InvocableVariable
    **/     
    public class AgentAvailabilityInput{
        @InvocableVariable(required=true)
        public String sOrgId;
        @InvocableVariable(required=false)
        public String sLiveChatDeploymentId;
        @InvocableVariable(required=false)
        public String sLiveChatButtonForTransferId;
    }
    /**
    * Description: gets input param from bot and fetches and assigns agentavailability boolean as output param
    * @MethodName:Check Agent Availablity(InvocableMethod)
    * @Created by:Vazeer
    * @parameters:List<AgentAvailabilityOutput>, List<AgentAvailabilityInput>
    * @return:outputParameters
    * @throws exception:
    */
    @InvocableMethod(label='Check Agent Availablity')
    public static List<AgentAvailabilityOutput> checkAgentAvailability(List<AgentAvailabilityInput> inputParameters){
        List<AgentAvailabilityOutput> outputParameters = new List<AgentAvailabilityOutput>();
        AgentAvailabilityOutput outputParameter = new AgentAvailabilityOutput();
        //by default, set agent transfer availablity to true if the transfer button 
        outputParameter.bAgentTransferAvailability = true;
        outputParameters.add(outputParameter);
        String sOrgId = inputParameters[0].sOrgId;
        String sLiveChatDeploymentId = inputParameters[0].sLiveChatDeploymentId;
        String sLiveChatButtonForTransferId = BOTTRANSFERCBID;

        if (sOrgId!=null && sOrgId!='' && sLiveChatDeploymentId!=null && sLiveChatDeploymentId!='' && sLiveChatButtonForTransferId!=null && sLiveChatButtonForTransferId!=''){
            outputParameter.bAgentTransferAvailability = Bot_REST_Utils.getButtonAvailablityForTransfer(sOrgId,sLiveChatButtonForTransferId,sLiveChatDeploymentId);
        }
        return outputParameters;
    }
}