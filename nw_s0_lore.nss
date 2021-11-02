//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of 10
    plus 1 / 2 caster levels.  Lasts for 1 Turn per
    caster level.
    Will also search the casters crafting bag and set
    up to 100 unidentified items to be identified.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: 2003-10-29: GZ: Corrected spell target object
//::             so potions work wit henchmen now

#include "x2_inc_spellhook"
#include "alter_effects"

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
    int nLevel = GetCasterLevel(oTarget);
    int nBonus = 10 + (nLevel / 2);
    effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eLore, eDur);

    int nMetaMagic = GetMetaMagicFeat();
    //Meta-Magic checks
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nLevel *= 2;
    }
    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) || !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget))
    {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));
         //Apply linked and VFX effects
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }


    ////////////   customized //////////
    identifyItemsInCraftingBag(OBJECT_SELF, 100);
    //////////// Customized if cast on an item
    if(GetIsObjectValid(oTarget)){
        SetIdentified(oTarget, TRUE);

        itemproperty ip_uselimitwiz = ItemPropertyLimitUseByClass( IP_CONST_CLASS_WIZARD );
        itemproperty ip_uselimitsorc = ItemPropertyLimitUseByClass( IP_CONST_CLASS_SORCERER );
        itemproperty ip_uselimitbard = ItemPropertyLimitUseByClass( IP_CONST_CLASS_BARD );
        //Get the first itemproperty on the helmet
        itemproperty ipLoop = GetFirstItemProperty(oTarget);
        int ipfound = FALSE;
        //Loop for as long as the ipLoop variable is valid
        while (GetIsItemPropertyValid(ipLoop))
        {
            //If ipLoop is a class us limit property, remove it
            if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_USE_LIMITATION_CLASS) {
                // if subtype is wiz, sorc or bard
                if(GetItemPropertySubType(ip_uselimitbard) ||
                    GetItemPropertySubType(ip_uselimitsorc) ||
                    GetItemPropertySubType(ip_uselimitwiz)){
                    ipfound = TRUE;
                }
                //once found remove all class use limitations from scrolls
                //as a spell on an arcane spell list should be made usable
                if(ipfound){
                    int itype =  GetObjectType(oTarget);
                    if( itype == BASE_ITEM_BLANK_SCROLL ||
                        itype == BASE_ITEM_ENCHANTED_SCROLL ||
                        itype == BASE_ITEM_SCROLL ||
                        itype == BASE_ITEM_SPELLSCROLL){

                        RemoveItemProperty(oTarget, ipLoop);
                    }
                }
         }
         //Next itemproperty on the list...
         ipLoop=GetNextItemProperty(oTarget);
       }
    }


}

