@IsTest
private class ConvertLeadTest {
    @IsTest
    static void when_QualificationTaskIsClosed_expect_LeadConversion() {
        Lead testLead = new Lead(
                FirstName = 'Adam',
                LastName = 'Test',
                Company = 'Test Company');
        insert testLead;
        Task[] qualifiedTasks = [SELECT Id, IsClosed, Status FROM Task WHERE WhoId=:testLead.Id LIMIT 1];

        Test.startTest();
        qualifiedTasks[0].Status = 'Completed';
        update qualifiedTasks;
        forvendi.BreezzApi.TESTS.deliverAsyncQueueEvents();
        Test.stopTest();

        forvendi.BreezzApi.TESTS.assertErrorLogs();
        testLead = (Lead)forvendi.BreezzApi.TESTS.loadRecordById(testLead.Id);
        Assert.areEqual(true, testLead.IsConverted);
    }
}