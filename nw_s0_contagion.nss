//::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target must save or be struck down with
    Blidning Sickness, Cackle Fever, Filth Fever
    Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 6, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    int nDisease =   DISEASE_DEMON_FEVER; //default d6 con

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_SILENT)
    {
        // if has item in component pouch
        // only check first item in pouch
        // - player should only have one item in there at a time

        object bag = GetItemPossessedBy(OBJECT_SELF, "componentbag");
        object item = GetFirstItemInInventory(bag);
        object item2 = GetNextItemInInventory(bag);

        //should loop over items incomponent pouch
         if( GetTag(item) == "nw_it_msmlmisc07" ){ // ettercap silk gland d4 dex
            nDisease = DISEASE_SLIMY_DOOM;
            DestroyObject(item);
        } else if( GetTag(item) == "NW_IT_MSMLMISC06" ){ // bodaks tooth  d4 dex con
            nDisease =  DISEASE_ZOMBIE_CREEP;
            DestroyObject(item);
        } else if( GetTag(item) == "NW_IT_MSMLMISC19" ){ // fiary dust d6 wis
            nDisease =   DISEASE_CACKLE_FEVER;
            DestroyObject(item);
        } else if( GetTag(item) == "NW_IT_MSMLMISC08" ){ // Fire Beetle's Belly 1 int, wis, chr
            nDisease =  DISEASE_VERMIN_MADNESS;
            DestroyObject(item);
        } else if( GetTag(item) == "NW_IT_MSMLMISC09" ){ // Rakshasa's Eye d4 str blindness
            nDisease = DISEASE_BLINDING_SICKNESS;
            DestroyObject(item);
        } else if( GetTag(item) == "nw_it_msmlmisc25" ){ // ichor d3 dex con
            nDisease =  DISEASE_FILTH_FEVER;
            DestroyObject(item);
        } else if( GetTag(item) == "NW_IT_MSMLMISC10" && GetTag(item2) == "NW_IT_MSMLMISC17"  ){  // Slaad's Tongue MEGA DAMAGE
            //this requires 1 slaad tongue in bag, and 1 dragons blood out
            nDisease = DISEASE_RED_SLAAD_EGGS;
            DestroyObject(item);
            DestroyObject(item2);
            TakeNumItems( OBJECT_SELF,"NW_IT_MSMLMISC17", 1);
        } else if( GetTag(item) == "NW_IT_MSMLMISC17" && GetTag(item2) == "NW_IT_MSMLMISC10"  ){  // Slaad's Tongue MEGA DAMAGE
            //this requires 1 slaad tongue in bag, and 1 dragons blood out
            nDisease = DISEASE_RED_SLAAD_EGGS;
            DestroyObject(item);
            DestroyObject(item2);
            TakeNumItems( OBJECT_SELF,"NW_IT_MSMLMISC17", 1);
        } else if( GetTag(item) == "NW_IT_MSMLMISC17" ){ //dragon blood
           nDisease = DISEASE_DREAD_BLISTERS; //d4 con,chr
           DestroyObject(item);
        }
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
        effect eDisease = EffectDisease(nDisease);
        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //The effect is permament because the disease subsystem has its own internal resolution
            //system in place.
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
        }
    }
}

