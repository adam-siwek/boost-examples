trigger ContactTrigger on Contact (after insert, before insert) {
    forvendi.BreezzApi.TRIGGERS.handle();
}