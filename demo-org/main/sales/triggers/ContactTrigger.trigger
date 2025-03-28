trigger ContactTrigger on Contact (after insert, after update, after delete) {
    forvendi.BreezzApi.TRIGGERS.handle();
}