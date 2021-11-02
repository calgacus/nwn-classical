#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    SpeakString("aquired adamantine plate ", TALKVOLUME_SHOUT);
    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent == X2_ITEM_EVENT_ACQUIRE)
    {
        object armor = GetModuleItemAcquired();
        if(GetLocalInt(armor, "hardness") > 0){
            SpeakString("Adamantine plate already hardened!"  , TALKVOLUME_SHOUT);
            return;  //assume this stuff has already been done.
        }
        SetLocalInt(armor, "hardness", 4);
        string desc = GetDescription(armor );
        SetDescription(armor, desc + "  Hardness of four." );
    }// end if
}// end main
