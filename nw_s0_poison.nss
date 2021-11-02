//::///////////////////////////////////////////////
//:: Poison
//:: NW_S0_Poison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Must make a touch attack. If successful the target
    is struck down with wyvern poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

int getSpecialPoisonType(string tag){
    //should loop over items incomponent pouch
    if( tag == "NW_IT_MSMLMISC17" ){ //dragon blood
        return POISON_DRAGON_BILE;
    } else if( tag == "nw_it_msmlmisc07" ){ //ettercap silk gland
        return  POISON_ETTERCAP_VENOM;
    } else if( tag == "NW_IT_MSMLMISC06" ){ //bodaks tooth
        return POISON_IRON_GOLEM;
    } else if( tag == "NW_IT_MSMLMISC19" ){ //fiary dust
        return POISON_OIL_OF_TAGGIT;
    } else if( tag == "NW_IT_MSMLMISC08" ){ // Fire Beetle's Belly
        return POISON_SASSONE_LEAF_RESIDUE;
    } else if( tag == "NW_IT_MSMLMISC14" ){ // Gargoyle Skull
        return  POISON_BEBILITH_VENOM;
    } else if( tag == "NW_IT_MSMLMISC09" ){  // Rakshasa's Eye
        return  POISON_CHAOS_MIST;
    } else if( tag == "NW_IT_MSMLMISC10" ){  // Slaad's Tongue
        return POISON_BLACK_LOTUS_EXTRACT ;
    } else if( tag == "nw_it_msmlmisc25" ){  // ichor
        return POISON_PURPLE_WORM_POISON; //higher DC anyway
    }
    return 0;


}

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
    effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
    int nTouch = 1;//
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_SILENT)
    {
        // if has item in component pouch
        // only check first item in pouch
        // - player should only have one item in there at a time

        object bag = GetItemPossessedBy(OBJECT_SELF, "craftingbag");
        object item = GetFirstItemInInventory(bag);
        //should loop over items incomponent pouch
        int pt = getSpecialPoisonType(GetTag(item));
        if(pt > 0){
            ePoison = EffectPoison( pt );
            DestroyObject(item);
        }

    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POISON));
        //Make touch attack
        if (nTouch > 0)
        {
            //Make SR Check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Apply the poison effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
            }
        }
    }
}

