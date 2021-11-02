//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue
#include "x2_inc_spellhook"
#include "x0_i0_spells"
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
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    int nCasterLvl = nDuration/2;
    if(nCasterLvl > 6)
    {
        nCasterLvl = 6;
    }


    float altFactor = 1.0;
    int alteredType = DAMAGE_TYPE_FIRE;

    if (nMetaMagic == METAMAGIC_SILENT  )
    {
        object componentbag = GetItemPossessedBy(OBJECT_SELF, "componentbag");
        if( GetIsObjectValid(componentbag)){
            object component = GetFirstItemInInventory(componentbag);
            if(GetIsObjectValid(component)){
                altFactor = getAlteredDamageShieldFactor( component, altFactor  );
                alteredType = getAlteredDamageShieldType( component, alteredType  );
                nCasterLvl = FloatToInt(nCasterLvl *  altFactor);
            }
        }
    }


    effect eShield = EffectDamageShield(nCasterLvl, DAMAGE_BONUS_1d8, alteredType );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImmune;
    if(alteredType == DAMAGE_TYPE_COLD )   {
        eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
    }
    if(alteredType == DAMAGE_TYPE_FIRE )   {
        eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
    }
    if(alteredType == DAMAGE_TYPE_ACID )   {
        eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 50);
    }
    if(alteredType == DAMAGE_TYPE_ELECTRICAL )   {
        eImmune = EffectDamageImmunityIncrease(  DAMAGE_TYPE_ELECTRICAL, 50);
    }
    if(alteredType == DAMAGE_TYPE_NEGATIVE )   {
        eImmune = EffectDamageImmunityIncrease(   DAMAGE_TYPE_NEGATIVE, 50);
    }
    if(alteredType == DAMAGE_TYPE_MAGICAL )   {
        eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_MAGICAL, 50);
    }


    //Link effects
    effect eLink = EffectLinkEffects(eShield, eImmune);
    //eLink = EffectLinkEffects(eLink, eFire);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    //  *GZ: No longer stack this spell
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
         RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

