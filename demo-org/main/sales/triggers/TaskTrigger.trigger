trigger TaskTrigger on Task (after update, before insert) {
    forvendi.BreezzApi.TRIGGERS.handle();
}