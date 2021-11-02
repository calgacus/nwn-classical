//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a stream of fiery arrows at the selected
    target that do 4d6 damage per arrow.  1 Arrow
    per 4 levels is created.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:: Updated By: Georg Zoeller, Aug 18 2003: Uncapped
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
    effect eMissedMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME, TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    int nMissiles = (nCasterLvl+1)/3;  // rounds nMissiles up
    //if(nCasterLvl % 3 != 0) nMissiles++;  // round back up  no at level 5 get 2 missiles, at level 6 3, at 9 4, at 12 5
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);

    // a round up
    if(nMissiles < 1)
    {
        nMissiles = 1;
    }
    // capped because other 3rd level spells are also capped, it is the norm
    if (nMissiles > 5)
    {
        nMissiles = 5;
    }
    SpeakString("missiles == " +IntToString(nMissiles), TALKVOLUME_SHOUT);
    //SpeakString("targ dex AC  "+ IntToString(GetAC(oTarget))+" dex mod " + IntToString( GetAbilityModifier(ABILITY_DEXTERITY, oTarget)), TALKVOLUME_SHOUT);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_ARROW));
        //Apply a single damage hit for each missile instead of as a single mass
        //Make SR Check
        for (nCnt = 1; nCnt <= nMissiles; nCnt++)
        {
            //Roll damage
            int nDam = d6(3);
            int aDam = d8(1); //piercing damage from the arrow part
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                  nDam = 24;//Damage is at max
            }
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                  nDam = nDam + nDam/2; //Damage/Healing is +50%
            }
            int hit = TouchAttackRanged(oTarget, TRUE);
            if( hit > 0){
                if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    //since the target is already hit a reflex save makes no sense
                    //nDam = GetReflexAdjustedDamage(nDam, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                    //Set damage effect
                    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
                    // since we are using a touch attack (which ignores armor)
                    // the arrow is still a magical object effect when it hits
                    // the target and not a real arrow (otherwise a regular
                    // to-hit roll would be called for,
                    // therefore the resist spell should still block the arrow.
                    if(hit == 2 && GetIsImmune( oTarget, IMMUNITY_TYPE_CRITICAL_HIT) == FALSE){
                        aDam = aDam * 3;  // this makes the spell more interesting
                        // now the base spell can do as much as 42 damage per arrow.
                        // So a 5th level caster with 2 arrows could do
                        // 84 damage to a single target.  On average it will do
                        // alot less but the spell is now a worthy pick.
                    }
                    effect eADam = EffectDamage(aDam, DAMAGE_TYPE_PIERCING);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eADam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
                    //Apply the MIRV and damage effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }else{// * May 2003: Make it so the arrow always appears, even if resisted
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissedMissile, oTarget);
                // SpeakString("missed object " +IntToString(nTh), TALKVOLUME_SHOUT);
            }
        } //end for loop
    }
}

