#include "x2_inc_switches"
#include "x2_inc_itemprop"


void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    SpeakString("ironwod qs ", TALKVOLUME_SHOUT);
    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent == X2_ITEM_EVENT_ACQUIRE)
    {
        object item =  GetModuleItemAcquired();
        if(GetLocalInt(item, "removedip") > 0){
            SpeakString("iqs already hardened!"  , TALKVOLUME_SHOUT);
            return;  //assume this stuff has already been done.
        }

        itemproperty ipLoop = GetFirstItemProperty(item);
        int ipfound = FALSE;
        while (GetIsItemPropertyValid(ipLoop))
        {
            if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ATTACK_BONUS) {
              SpeakString("Sorry, no AB to crafted items!", TALKVOLUME_SHOUT);
              RemoveItemProperty(item, ipLoop);
              return;
            }
            //Next itemproperty on the list...
            ipLoop=GetNextItemProperty(item);
        }  // end while
        SetLocalInt(item, "removedip", 1);
        itemproperty ip = ItemPropertyDamageBonus(DAMAGE_TYPE_BLUDGEONING,1);
        IPSafeAddItemProperty(item, ip, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
    }// end if
}// end main
