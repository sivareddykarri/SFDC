/**
 @Author :  Vazeer Mohammed
 @Name   :  ConnectApiHelperTest
 @Created Date: 06-Apr-2018
 @Description: 
 @Version:0.1
 @Reference: 
**/
@isTest(SeeAllData=true)
private class ConnectApiHelperTest{
    /**
    * Description: Test for when mentioned input is not a group or user id
    * @MethodName: testInvalidMentionType
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testInvalidMentionType() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        Boolean exceptionThrown = false;
        try {
            ConnectApiHelper.postFeedItemWithMentions(null, 'me', '{001x00000000D7m}'); // not a group or user id
        }
        catch (ConnectApi.ConnectApiException e) {
            System.assertEquals('Only user and group IDs may be used in inline mentions.', e.getMessage());
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
        }
    }    
    /**
    * Description: Test for when mentioned input is null
    * @MethodName: testNullString
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testNullString() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        Boolean exceptionThrown = false;
        try {
            List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(null);
        }
        catch (ConnectApiHelper.InvalidParameterException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown);
        }
    }
    /**
    * Description: Test for when mentioned input is empty string 
    * @MethodName: testEmptyString
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testEmptyString() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs('');
        System.assertEquals(0, segments.size());
        }
    }
    /**
    * Description: Test for when input string has no mentions
    * @MethodName: testNoMentions
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testNoMentions() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String text = 'hey there';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);
        
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(text, textSegment.text);
        }
    }
    /**
    * Description: Test for when input string has only mentions 
    * @MethodName: testMentionOnly
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testMentionOnly() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String mentionId = '005x0000000URNP';
        String text = '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);
        
        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);
        }
    }
    /**
    * Description: Test for when input string has leading mention followed by a string
    * @MethodName: testLeadingMention
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testLeadingMention() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String mentionId = '005x0000000URNPzzz';
        String restOfMessage = ' - how are you?';
        String text = '{' + mentionId + '}' + restOfMessage;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(restOfMessage, textSegment.text);
        }
    }
    /**
    * Description: Test for when input has trailing mention that followes a string
    * @MethodName: testTrailingMention
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testTrailingMention() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String restOfMessage = 'Here we go: ';
        String mentionId = '005x0000000URNPzzz';
        String text = restOfMessage + '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(1);
        System.assertEquals(mentionId, mentionSegment.id);
        }
    }
    /**
    * Description: Test for when input has two adjacent mentions
    * @MethodName: testAdjacentMentions
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testAdjacentMentions() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String mentionId  = '005x0000000URNPzzz';
        String mentionId2 = '0F9x00000000D7m';
        String text = '{' + mentionId + '}' + '{' + mentionId2 + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        System.assertEquals(mentionId, mentionSegment.id);
        
        ConnectApi.MentionSegmentInput mentionSegment2 = (ConnectApi.MentionSegmentInput) segments.get(1);
        System.assertEquals(mentionId2, mentionSegment2.id);
        }
    }
    /**
    * Description: Test for when input has Unsupported Markups
    * @MethodName: testUnsupportedMarkup
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testUnsupportedMarkup() {
        // <span>a</span>, <h1><a>b</a> <br> <b>Does this work?</b></h1>
        // [0                               ][1][2            ][3 ][4  ]
        // 0 = text1
        // 1 = markup begin
        // 2 = text2
        // 3 = markup end
        // 4 = text3
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String text1 = '<span>a</span>, <h1><a>b</a> <br> ';
        String text2 = 'Does this work?';
        String text3 = '</h1>';
        String text = text1 + '<b>' + text2 + '</b>' + text3;

        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(5, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        System.assertEquals(text2, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        System.assertEquals(text3, textSegment.text);
        }
    }
    /**
    * Description: Test for when input has simple Markups
    * @MethodName: testSimpleMarkup
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testSimpleMarkup() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String restOfMessage = 'blah';
        String text = '<u>' + restOfMessage + '</u>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(3, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);
        }
    }
    /**
    * Description: test for when input has markups with casing
    * @MethodName: testMarkupCasing
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testMarkupCasing() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String text1 = 'foo';
        String text2 = 'bar';
        String text3 = 'baz';
        String text = '<U>' + text1 + '</U><b>' + text2 + '</B><oL><li>' + text3 + '</li></oL>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(11, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(5) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(8) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        System.assertEquals(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(5);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        System.assertEquals(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);
        
        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);
        }
    }
    /**
    * Description: Test for when input has only inline image
    * @MethodName: testInlineImage
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testInlineImage() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String restOfMessage = 'Check out this image!';
        String imageId = '069B0000000q7hi';
        String altText = 'Some alt text.';
        String text = restOfMessage + '{img:' + imageId + ':' + altText + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(2, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        System.assertEquals(restOfMessage, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(altText, inlineImageSegment.altText);
        }
    }
    /**
    * Description: test for when input has inline image but no alt text
    * @MethodName: testInlineImageNoAltText
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testInlineImageNoAltText() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String imageId = '069B0000000q7hi';
        String text = '{img:' + imageId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(1, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(null, inlineImageSegment.altText);
        }
    }
    /**
    * Description: test for when input has inline image and alt text
    * @MethodName: testInlineImageAltTextSyntax
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @IsTest(SeeAllData=true)
    static void testInlineImageAltTextSyntax() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String imageId15 = '069B0000000q7hi';
        String imageId18 = '069B0000000q7hixxx';
        String altText1 = 'Alt text with a colon : in the middle.';
        String badSyntax1 = 'Alt text with a closing brace ';
        String badSyntax2 = ' in the middle.}';
        String badSyntaxAltText = badSyntax1 + '}' + badSyntax2;
        String text = '{img:' + imageId15 + ':' + altText1 + '}{img:' + imageId18 + ':}{img:' + imageId15 + ':' + badSyntaxAltText;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(4, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.InlineImageSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.TextSegmentInput);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        System.assertEquals(imageId15, inlineImageSegment.fileId);
        System.assertEquals(altText1, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        System.assertEquals(imageId18, inlineImageSegment.fileId);
        System.assertEquals(null, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(2);
        System.assertEquals(imageId15, inlineImageSegment.fileId);
        System.assertEquals(badSyntax1, inlineImageSegment.altText);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(3);
        System.assertEquals(badSyntax2, textSegment.text);
        }
    }
    /**
    * Description: Test for when input has markup and mention
    * @MethodName: testMarkupAndMention
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @isTest(SeeAllData=true)
    static void testMarkupAndMention() {
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String mentionId = '005x0000000URNPzzz';
        String message = 'How are you';
        String questionMark = '?';
        String text = '<b>' + message + '<i>{' + mentionId + '}</i>' + questionMark + '</b>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(7, segments.size());
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MentionSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(5) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupEndSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        System.assertEquals(message, textSegment.text);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(2);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(3);
        System.assertEquals(mentionId, mentionSegment.id);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(5);
        System.assertEquals(questionMark, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);
        }
    }
    /**
    * Description: test for when input has markup, inline image, mention and alt text
    * @MethodName: testAllMarkupAndInlineImage
    * @Created by: Vazeer Mohammed
    * @parameters: Null
    * @return:Void
    */
    @isTest(SeeAllData=true)
    static void testAllMarkupAndInlineImage() {
        // <p><i>This is an italicized paragraph.</i></p>
        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        User curUser=new User(Id=UserInfo.getUserId());
        System.runAs(curUser){            
        String text1 = 'This is an italicized paragraph.';
        String text2 = 'A completed item in an unordered list.';
        String text3 = 'An underlined item in an ordered list.';
        String text4 = 'And, of course, an image for you: ';
        String text5 = ' ';
        String imageId = '069B0000000q7hi';
        String altText = 'An image of something nice.';
        String text = '<p><i>' + text1 + '</i></p><ul><li><s>' + text2 + '</s></li></ul><ol><li><u>' 
                        + text3 + '</u></li></ol><b>' + text4 + '</b> {img:' + imageId + ':' + altText + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        System.assertEquals(24, segments.size());
        // <p><i>This is an italicized paragraph.</i></p>
        System.assert(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(2) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);
        
        // <ul><li><s>A completed item in an unordered list.</s></li></ul>        
        System.assert(segments.get(5) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(8) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(11) instanceof ConnectApi.MarkupEndSegmentInput);
        
        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        System.assert(segments.get(12) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(13) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(14) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(15) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(16) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(17) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(18) instanceof ConnectApi.MarkupEndSegmentInput);
        
        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        System.assert(segments.get(19) instanceof ConnectApi.MarkupBeginSegmentInput);
        System.assert(segments.get(20) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(21) instanceof ConnectApi.MarkupEndSegmentInput);
        System.assert(segments.get(22) instanceof ConnectApi.TextSegmentInput);
        System.assert(segments.get(23) instanceof ConnectApi.InlineImageSegmentInput);

        // <p><i>This is an italicized paragraph.</i></p>
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        System.assertEquals(ConnectApi.MarkupType.Paragraph, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        System.assertEquals(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        System.assertEquals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        System.assertEquals(ConnectApi.MarkupType.Paragraph, markupEndSegment.markupType);

        // <ul><li><s>A completed item in an unordered list.</s></li></ul>        
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(5);
        System.assertEquals(ConnectApi.MarkupType.UnorderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        System.assertEquals(ConnectApi.MarkupType.Strikethrough, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        System.assertEquals(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        System.assertEquals(ConnectApi.MarkupType.Strikethrough, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(11);
        System.assertEquals(ConnectApi.MarkupType.UnorderedList, markupEndSegment.markupType);

        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(12);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(13);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(14);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(15);
        System.assertEquals(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(16);
        System.assertEquals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(17);
        System.assertEquals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(18);
        System.assertEquals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);
        
        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(19);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(20);
        System.assertEquals(text4, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(21);
        System.assertEquals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(22);
        System.assertEquals(text5, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(23);
        System.assertEquals(imageId, inlineImageSegment.fileId);
        System.assertEquals(altText, inlineImageSegment.altText);
        }
    }
}