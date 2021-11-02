void main()
{
    // on enter
    object oActor;
    SpeakString("on enter 1", TALKVOLUME_SHOUT)  ;
    // Get the creature who triggered this event.
    object oPC = GetEnteringObject();
    SpeakString("on enter 2", TALKVOLUME_SHOUT)  ;
    // Only fire for (real) PCs.
    if ( !GetIsPC(oPC)  ||  GetIsDMPossessed(oPC) )
        return;
    SpeakString("on enter 3", TALKVOLUME_SHOUT)  ;
    // Have "" cast Creeping Doom.
    //oActor = GetObjectByTag("CreepingDoom");
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY , EffectAreaOfEffect(AOE_PER_CREEPING_DOOM ),  GetLocation(oPC), RoundsToSeconds(13));
    SpeakString("on enter 4", TALKVOLUME_SHOUT)  ;
   // AssignCommand(oActor, ActionCastSpellAtLocation(SPELL_CREEPING_DOOM, GetLocation(oPC), METAMAGIC_ANY, TRUE));
}
