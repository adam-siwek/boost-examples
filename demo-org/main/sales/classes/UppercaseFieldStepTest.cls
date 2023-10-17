@IsTest
private class UppercaseFieldStepTest {

    @IsTest
    static void when_UppercaseNameStepIsExecutedForMultipleRecord_expect_UppercasedNameValue() {
        Account[] newAccounts = new Account[] {new Account(Name = 'test 1'), new Account(Name = 'test 2')};
        Account[] oldAccounts = new Account[] {new Account(Name = 'ACCOUNT'), new Account(Name = 'ACCOUNT')};

        Test.startTest();
        forvendi.BoostApi.STEPS.build()
                .addStep(new UppercaseFieldStep())
                .execute(newAccounts, oldAccounts);
        Test.stopTest();

        forvendi.BoostAPI.TESTS.assertErrorLogs();
        Assert.areEqual('Test 1', newAccounts[0].Name);
        Assert.areEqual('Test 2', newAccounts[1].Name);
    }

    @IsTest
    static void when_UppercaseNameStepIsExecutedForSingleRecord_expect_UppercasedNameValue() {
        Account[] newAccounts = new Account[] {new Account(Name = 'test 1')};
        Test.startTest();

        forvendi.BoostApi.STEPS.build()
                .addStep(new UppercaseFieldStep())
                .execute(newAccounts);
        Test.stopTest();

        forvendi.BoostAPI.TESTS.assertErrorLogs();
        Assert.areEqual('Test 1', newAccounts[0].Name);
    }
}