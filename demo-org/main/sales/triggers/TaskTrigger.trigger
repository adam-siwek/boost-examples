trigger TaskTrigger on Task (after update, before insert) {
    forvendi.BoostApi.TRIGGERS.handle();
}