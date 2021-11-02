void main()
{
SpeakString("click!", TALKVOLUME_SHOUT);
           object oPC = GetLastUsedBy();
   // PlayAnimation(  ANIMATION_PLACEABLE_ACTIVATE);
  //   ANIMATION_PLACEABLE_DEACTIVATE

   DoPlaceableObjectAction(oPC, PLACEABLE_ACTION_USE);
   ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
   ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
}
