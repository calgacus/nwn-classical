#include "classical_craft"

void main()
{
    SpeakString("USED Crafting wand!", TALKVOLUME_SHOUT);
    object oPC = GetItemActivator();
    //    object bag = GetItemPossessedBy(oPC, "bagofcrafting");
    tryRecipeFromComponents(oPC);
}
