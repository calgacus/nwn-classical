//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Afflicted creature must save or suffer a -2 penalty
    to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

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
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(2, 2, 2, 2, 2, 2);

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);
    //if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will Save
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
            {
                // effect dsave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
                // effect dskill = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
                // effect dspell = EffectSpellFailure(10, SPELL_SCHOOL_GENERAL);


                int nMetaMagic = GetMetaMagicFeat();
                if (nMetaMagic == METAMAGIC_SILENT)
                {
                    // if has item in component pouch
                    // only check first item in pouch
                    // - player should only have one item in there at a time

                    object bag = GetItemPossessedBy(OBJECT_SELF, "componentbag");

                    object item = GetFirstItemInInventory(bag);

                    //should loop over items in component pouch
                    if( GetTag(item) == "NW_IT_MSMLMISC17" ){ //dragon blood
                        eCurse = EffectCurse(6, 0, 2, 2, 0, 2);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(10, SPELL_SCHOOL_GENERAL);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "nw_it_msmlmisc07" ){ //ettercap silk gland
                        eCurse = EffectCurse(2, 4, 2, 2, 0, 2);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(10, SPELL_SCHOOL_TRANSMUTATION );
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC10" ){  // Slaad's Tongue
                        eCurse = EffectCurse(3, 4, 5, 0, 0, 0);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(20, SPELL_SCHOOL_CONJURATION);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC14" ){ // Gargoyle Skull
                        eCurse = EffectCurse(0, 2, 2, 4, 2, 2);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(15, SPELL_SCHOOL_DIVINATION );
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC19" ){ //fiary dust
                        eCurse = EffectCurse(1, 1, 2, 2, 4, 2);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(15, SPELL_SCHOOL_ENCHANTMENT);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC06" ){ //bodaks tooth
                        eCurse = EffectCurse(0, 2, 2, 2, 2, 4);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(20, SPELL_SCHOOL_ABJURATION);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC08" ){ // Fire Beetle's Belly
                        eCurse = EffectCurse(1, 3, 1, 3, 1, 3);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(7, SPELL_SCHOOL_EVOCATION );
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    }  else if( GetTag(item) == "nw_it_msmlmisc25" ){  // ichor
                        eCurse = EffectCurse(1, 1, 4, 2, 2, 2);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(7, SPELL_SCHOOL_CONJURATION);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    } else if( GetTag(item) == "NW_IT_MSMLMISC09" ){  // Rakshasa's Eye
                        eCurse = EffectCurse(1, 1, 1, 3, 3, 3);
                        //Make sure that curse is of type supernatural not magical
                        eCurse = SupernaturalEffect(eCurse);
                        effect extra = EffectSpellFailure(20, SPELL_SCHOOL_ILLUSION);
                        eCurse = EffectLinkEffects(extra, eCurse);
                        DestroyObject(item);
                    }

                }
                //Apply Effect and VFX
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            }
        }
    }
}
