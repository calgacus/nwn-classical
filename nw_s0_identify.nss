//::///////////////////////////////////////////////
//:: Identify
//:: NW_S0_Identify.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of +10.
    Lasts for 10 rounds.
    Will also search the casters crafting bag and set 1
    unidentified item to be identified
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


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

    ////////////   customized //////////
    identifyItemsInCraftingBag(OBJECT_SELF, 1);
    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, OBJECT_SELF) || !GetHasSpellEffect(SPELL_LEGEND_LORE, OBJECT_SELF)) //Use Legend Lore constant later
    {
        //Declare major variables
        int nLevel = GetCasterLevel(OBJECT_SELF);
        int nBonus = 10;
        effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
        effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);
        eLink = EffectLinkEffects(eLink, eLore);

        int nMetaMagic = GetMetaMagicFeat();
        int nDuration = nBonus;

        //Meta-Magic checks
        if(nMetaMagic == METAMAGIC_EXTEND)
        {
            nBonus = nBonus*2;
        }
        //Fire cast spell at event for the specified target
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_IDENTIFY, FALSE));

        //Apply linked and VFX effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }

}

