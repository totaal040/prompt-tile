@isTest
public class PromptTileControllerTest {
    private static final String PAR_NAME = 'Account Name';
    @TestSetup
    private static void makeData() {
        Account parentRec = new Account(Name = PAR_NAME);
        insert parentRec;
        Contact childRec = new Contact(LastName = 'Contact Lastname', AccountId = parentRec.Id);
        insert childRec;
    }

    @isTest
    private static void itShouldRetrieveRecordsForChildRel() {
        Account parentRec = [SELECT Id FROM Account WHERE Name = :PAR_NAME LIMIT 1];
        String paramStr = '{"labelFldName":"LastName","childRelApiName":"Contacts","parentIdStr":"'+parentRec.Id+'","parentRelLibApiName":null}';

        Test.startTest();
        List<SObject> childs = PromptTileController.getRecords(paramStr);
        Test.stopTest();

        Assert.isTrue(childs.size() == 1, 'it should return one child test record');
    }

    @isTest
    private static void itShouldReturnParamsNotValidatedError() {
        Account parentRec = [SELECT Id FROM Account WHERE Name = :PAR_NAME LIMIT 1];
        String paramStr = '{"labelFldName":"LastName","childRelApiName":"","parentIdStr":"'+parentRec.Id+'","parentRelLibApiName":null}';

        List<SObject> childs;
        Boolean isAuraExceptionCaught;
        Test.startTest();
        try {
            childs = PromptTileController.getRecords(paramStr);
        } catch (AuraHandledException ex) {
            isAuraExceptionCaught = true;
        }
        Test.stopTest();

        Assert.isTrue(isAuraExceptionCaught, 'it should throw AuraHandled exception');
        Assert.isNull(childs, 'it should return null for child test records');
    }

    @isTest
    private static void itShouldReturnChildRelationshipError() {
        Account parentRec = [SELECT Id FROM Account WHERE Name = :PAR_NAME LIMIT 1];
        String paramStr = '{"labelFldName":"LastName","childRelApiName":"_randomREL_","parentIdStr":"'+parentRec.Id+'","parentRelLibApiName":null}';

        List<SObject> childs;
        Boolean isAuraExceptionCaught;
        Test.startTest();
        try {
            childs = PromptTileController.getRecords(paramStr);
        } catch (AuraHandledException ex) {
            isAuraExceptionCaught = true;
        }
        Test.stopTest();

        Assert.isTrue(isAuraExceptionCaught, 'it should throw AuraHandled exception');
        Assert.isNull(childs, 'it should return null for child test records');
    }
}