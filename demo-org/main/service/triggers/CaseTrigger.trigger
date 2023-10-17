trigger CaseTrigger on Case (after delete, before update, after update) {
    forvendi.BoostApi.TRIGGERS.handle();
}