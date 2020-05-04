/**
 @Author :  Vazeer Mohammed
 @Name   :  ConnectApiHelper
 @Created Date: 06-Apr-2018
 @Description: Helper class that makes it easier to do common operations with the classes in the ConnectApi namespace.
 @Version:0.1
 @Reference: 
**/
global class ConnectApiHelper {
	/**
	 @Author :  Vazeer Mohammed
 	@Name   :  InvalidParameterException
 	@Created Date: 06-Apr-2018
 	@Description: Helper class
 	@Version:0.1
 	@Reference: 
	**/
    public class InvalidParameterException extends Exception {}
    
    private Static Final Map<String, ConnectApi.MarkupType> supportedMarkup = new Map<String, ConnectApi.MarkupType> {
        'b' => ConnectApi.MarkupType.Bold, 
        'i' => ConnectApi.MarkupType.Italic, 
        'li' => ConnectApi.MarkupType.ListItem, 
        'ol' => ConnectApi.MarkupType.OrderedList, 
        'p' => ConnectApi.MarkupType.Paragraph, 
        's' => ConnectApi.MarkupType.Strikethrough, 
        'u' => ConnectApi.MarkupType.Underline, 
        'ul' => ConnectApi.MarkupType.UnorderedList
    };
    
    /**
    * Description: Posts a feed item with @-mentions using an @-mention formatting syntax.
    * @MethodName:postFeedItemWithMentions
    * @Created by:Vazeer
    * @parameters:communityId, subjectId, textWithMentions
    * @return:ConnectApi.FeedElement
    */
    public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){        
        return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentions, ConstantClass.TEXTWITHMENTIONS);
    }
    
    /**
    * Description: Posts a feed item with Special Formatting.
    * @MethodName:postFeedItemWithMentions
    * @Created by:Vazeer
    * @parameters:communityId, subjectId, formattedText, textParameterName
    * @return:ConnectApi.FeedElement
    */
    private static ConnectApi.FeedElement postFeedItemWithSpecialFormatting(String communityId, String subjectId, String formattedText, String textParameterName) {
        if (formattedText == null || formattedText.trim().length() == 0) {
            throw new InvalidParameterException(ConstantClass.THE + textParameterName + ConstantClass.PARAMETER_NON_EMPTY);
        }
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = getMessageSegmentInputs(formattedText);

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.body = messageInput;
        input.subjectId = subjectId;
        
        return ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
    }

    /**
    * Description: 
    * @MethodName:messageSegmentInputs
    * @Created by:Vazeer
    * @parameters:inputText
    * @return:List<ConnectApi.MessageSegmentInput>
    */
    public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) {
       
        if (inputText == null) {
            throw new InvalidParameterException(ConstantClass.INPUT_TEXT_PARAMETER_NOT_NULL);
        }

        List<ConnectApi.MessageSegmentInput> messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
        Integer strPos = 0;
        Pattern globalPattern = Pattern.compile(ConstantClass.PATTERN);
        Matcher globalMatcher = globalPattern.matcher(inputText);
       try{
        while (globalMatcher.find()) {
            String textSegment = inputText.substring(strPos, globalMatcher.start());
            String matchingText = globalMatcher.group();
            if (matchingText.startsWith(ConstantClass.LEFT_BRACE)) {
                addTextSegment(messageSegmentInputs, textSegment); 
                String innerMatchedText = matchingText.substring(1, matchingText.length() - 1);
                if (innerMatchedText.startsWith(ConstantClass.IMG)) {
                    String[] imageInfo = innerMatchedText.split(ConstantClass.COLON, 3);
                    String altText = imageInfo.size() == 3 ? imageInfo[2] : null;
                    ConnectApi.InlineImageSegmentInput inlineImageSegmentInput = makeInlineImageSegmentInput(imageInfo[1], altText);
                    messageSegmentInputs.add(inlineImageSegmentInput);
                    strPos = globalMatcher.end();
                }
                else {
                    ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(innerMatchedText);
                    messageSegmentInputs.add(mentionSegmentInput);
                    strPos = globalMatcher.end();
                }
            }
            else {
                boolean isBeginTag = !matchingText.startsWith(ConstantClass.BEGINTAG);
                if (isBeginTag) {
                    String tag = matchingText.substring(1, matchingText.indexOf(ConstantClass.TAG));
                    if (supportedMarkup.containsKey(tag.toLowerCase())) {
                        addTextSegment(messageSegmentInputs, textSegment); 
                        ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = makeMarkupBeginSegmentInput(tag);
                        messageSegmentInputs.add(markupBeginSegmentInput);
                        strPos = globalMatcher.end();
                    }
                }
                else {
                    String tag = matchingText.substring(2, matchingText.indexOf(ConstantClass.TAG));
                    if (supportedMarkup.containsKey(tag.toLowerCase())) {
                        addTextSegment(messageSegmentInputs, textSegment);
                        ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = makeMarkupEndSegmentInput(tag);
                        messageSegmentInputs.add(markupEndSegmentInput);
                        strPos = globalMatcher.end();
                    }
                }
            }
        }

        // Take care of any text that comes after the last match.
        if (strPos < inputText.length()) {
            String trailingText = inputText.substring(strPos, inputText.length());
            addTextSegment(messageSegmentInputs, trailingText);
        }
        }
         catch(exception exc){
            ExceptionHandler.logHandledExceptions(exc,ConstantClass.CONNECTAPIHELPER, ConstantClass.GETMESSAGESEGMENTINPUTS, ConstantClass.PUSHNOTIFICATIONFUNCTIONALITY);
        }
        return messageSegmentInputs;
    }
    /**
    * Description: 
    * @MethodName:addTextSegment
    * @Created by:Vazeer
    * @parameters:Text
    * @return:List<ConnectApi.MessageSegmentInput>
    */
    private static void addTextSegment(List<ConnectApi.MessageSegmentInput> messageSegmentInputs, String text) {
        if (text != null && text.length() > 0) {
            ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(text);
            messageSegmentInputs.add(textSegmentInput);
        }
    }
    /**
    * Description: 
    * @MethodName:makeTextSegmentInput
    * @Created by:Vazeer
    * @parameters:Text
    * @return:List<ConnectApi.MessageSegmentInput>
    */
    private static ConnectApi.TextSegmentInput makeTextSegmentInput(String text) {
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = text;
        return textSegment;
    }
    /**
    * Description: 
    * @MethodName:makeMentionSegmentInput
    * @Created by:Vazeer
    * @parameters:mentionId
    * @return:ConnectApi.MentionSegmentInput
    */    
    private static ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) {
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = mentionId;
        return mentionSegment;
    }
    /**
    * Description: Create a MarkupBeginSegmentInput corresponding to the tag.  Checking whether the tag is
                   supported markup should happen before calling this method.
    * @MethodName:makeMarkupBeginSegmentInput
    * @Created by:Vazeer
    * @parameters:tag
    * @return:ConnectApi.MarkupBeginSegmentInput
    */    
    private static ConnectApi.MarkupBeginSegmentInput makeMarkupBeginSegmentInput(String tag) {
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegment.markupType = supportedMarkup.get(tag.toLowerCase());
        return markupBeginSegment;
    }
    /**
    * Description: Create a MarkupEndSegmentInput corresponding to the tag.  Checking whether the tag is
                   supported markup should happen before calling this method.
    * @MethodName:makeMarkupEndSegmentInput
    * @Created by:Vazeer
    * @parameters:tag
    * @return:ConnectApi.MarkupEndSegmentInput
    */     
    private static ConnectApi.MarkupEndSegmentInput makeMarkupEndSegmentInput(String tag) {
        ConnectApi.MarkupEndSegmentInput markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegment.markupType = supportedMarkup.get(tag.toLowerCase());
        return markupEndSegment;
    }
     /**
    * Description: 
    * @MethodName:makeMarkupEndSegmentInput
    * @Created by:Vazeer
    * @parameters:fileId, altText
    * @return:ConnectApi.InlineImageSegmentInput
    */    
    private static ConnectApi.InlineImageSegmentInput makeInlineImageSegmentInput(String fileId, String altText) {
        ConnectApi.InlineImageSegmentInput inlineImageSegment = new ConnectApi.InlineImageSegmentInput();
        inlineImageSegment.fileId = fileId;
        if (String.isNotBlank(altText)) {
            inlineImageSegment.altText = altText;
        }
        return inlineImageSegment;
    }
}