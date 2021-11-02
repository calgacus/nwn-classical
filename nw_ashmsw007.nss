#include "x2_inc_switches"
#include "x2_inc_itemprop"




void main()
{

    int nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;
    SpeakString("aquired mithril shield", TALKVOLUME_SHOUT);
    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACQUIRE)
    {
        object oPC =  GetModuleItemAcquiredBy();

        object shield =  GetModuleItemAcquired();
        SpeakString("found mithril shield", TALKVOLUME_SHOUT);

        if(GetLocalInt(shield, "hardness") > 0){
            SpeakString("Mithril shield already hardened!"  , TALKVOLUME_SHOUT);
            return;  //assume this stuff has already been done.
        }

        //remove freedom property, add wieght, arcane and dex/skill penalty
        itemproperty ipLoop = GetFirstItemProperty(shield);
        int ipfound = FALSE;
        while (GetIsItemPropertyValid(ipLoop))
        {
            //If ipLoop is a class us limit property, remove it
            if (GetItemPropertyType(ipLoop) ==  ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) {
              SpeakString("Sorry, no Freedom property allowed on craft, but it is automatically hardened to a hardness rating of 2!"  , TALKVOLUME_SHOUT);
              RemoveItemProperty(shield, ipLoop);
              return;
            }
            //Next itemproperty on the list...
            ipLoop=GetNextItemProperty(shield);
        }  // end while
        //now add weight reduction and hardness +1

        itemproperty ip = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_40_PERCENT);
        IPSafeAddItemProperty(shield, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        SetLocalInt(shield, "hardness", 3);
        string desc = GetDescription(shield );
        SetDescription(shield, desc + "  Hardened with Mithral." );


    }// end if

}// end main
