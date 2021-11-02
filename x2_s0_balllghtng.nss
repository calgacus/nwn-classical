//::///////////////////////////////////////////////
//:: Isaacs Lesser Missile Storm
//:: x0_s0_MissStorm1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


struct TrapInfo
{
    int type;
    int setDC;
};


// * returns true if int num is in the range beg..end inclusive
// * num int
// * beg int
// * end int
int inRange(int num, int beg, int end){
    return num >= beg && num <= end;
}


// * returns a TrapInfo struct containing the trap_base_type and setDC
// * of the trap created by a trap kit
// * resref string The resref of a trap kit
struct  TrapInfo getTrapType(object oTrapKit){

    string resref =  GetResRef(oTrapKit);
    struct TrapInfo retval;
    SpeakString("oTrapType try to set trap   "+  resref, TALKVOLUME_SHOUT);
    SpeakString("oTrapType try to set trap  2r "+ GetStringRight(resref, 2), TALKVOLUME_SHOUT);
    int tagnum = StringToInt(GetStringRight(resref, 2));
    SpeakString("try to set trap "+  resref, TALKVOLUME_SHOUT);
    SpeakString("try to set trap 2r "+ GetStringRight(resref, 2), TALKVOLUME_SHOUT);
    int rem = tagnum % 4;  //0 = deadly, 3= strong, 2= ave, 1= minor
    if( GetStringUpperCase(GetStringLeft(resref, 2)) ==  "NW"){
        if( inRange(tagnum, 1,4)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_SPIKE;
                retval.setDC =   35;// 20 25 35
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_SPIKE;
                retval.setDC =   5;// 20 25 35
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_SPIKE;
                retval.setDC =   20;// 20 25 35
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_SPIKE;
                retval.setDC =   25;// 20 25 35
                break;
            default:
                break;
            }
        } else if( inRange(tagnum, 5,8)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_HOLY;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_HOLY;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_HOLY;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_HOLY;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 9,12)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_TANGLE;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_TANGLE;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_TANGLE;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_TANGLE;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 13,16)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_ACID;
                retval.setDC =   35;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_ACID;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_ACID;
                retval.setDC =   25;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_ACID;
                retval.setDC =   30;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 17,20)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_FIRE;
                retval.setDC =   35;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_FIRE;
                retval.setDC =   20;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_FIRE;
                retval.setDC =   25;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_FIRE;
                retval.setDC =   30;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 21,24)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_ELECTRICAL;
                retval.setDC =   35;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_ELECTRICAL;
                retval.setDC =   20;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
                retval.setDC =   25;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_ELECTRICAL;
                retval.setDC =   30;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 25,28)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_GAS;
                retval.setDC =   45;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_GAS;
                retval.setDC =   30;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_GAS;
                retval.setDC =   35;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_GAS;
                retval.setDC =   45;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 29,32)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_FROST;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_FROST;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_FROST;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_FROST;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 33,36)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_ACID_SPLASH;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_ACID_SPLASH;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 37,40)){
            switch (rem)
            {
            case 0:
                retval.type =  TRAP_BASE_TYPE_DEADLY_SONIC;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_SONIC;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_SONIC;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_SONIC;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }else if( inRange(tagnum, 41,44)){
            switch (rem)
            {
            case 0:
                retval.type =   TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
                retval.setDC =   30;
                break;
            case 1:
                retval.type =  TRAP_BASE_TYPE_MINOR_NEGATIVE;
                retval.setDC =   15;
                break;
            case 2:
                retval.type =  TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
                retval.setDC =   20;
                break;
            case 3:
                retval.type =  TRAP_BASE_TYPE_STRONG_NEGATIVE;
                retval.setDC =   25;
                break;
            default:
                break;
            }
        }
    }else if(  GetStringUpperCase(GetStringLeft(resref, 2)) == "X2"){
        //int tagnum = StringToInt(GetStringRight(resref, 1));
        //int rem = tagnum % 4;
        switch (rem)
        {
        case 0:
            retval.type =    TRAP_BASE_TYPE_EPIC_SONIC;
            retval.setDC =   65;
            break;
        case 1:
            retval.type =   TRAP_BASE_TYPE_EPIC_ELECTRICAL;
            retval.setDC =   65;
            break;
        case 2:
            retval.type =   TRAP_BASE_TYPE_EPIC_FIRE;
            retval.setDC =   65;
            break;
        case 3:
            retval.type =   TRAP_BASE_TYPE_EPIC_FROST;
            retval.setDC =   65;
            break;
        default:
            break;
        }


    }
    return retval;
}


// get the first trap in the component bag
// * bag object - expected to be a container in a pc's inventory and have the tag "componentbag"
object GetFirstTrapInInventory(object bag){
    object oTrap = GetFirstItemInInventory(bag);
    while(GetIsObjectValid(oTrap)){
        if(GetBaseItemType(oTrap) == BASE_ITEM_TRAPKIT ){
            return oTrap;
        }
    }
    return oTrap;
}



// get the trapinfo of a trap kit
// * returns a TrapInfo struct
// * oTrapKit a trap kit object
struct TrapInfo xxoTrapType(object oTrapKit){
    struct TrapInfo retval;
     /*
    string resref =  GetResRef(oTrapKit);

    SpeakString("oTrapType try to set trap   "+  resref, TALKVOLUME_SHOUT);
    SpeakString("oTrapType try to set trap  2r "+ GetStringRight(resref, 2), TALKVOLUME_SHOUT);
    //for all but epic traps
    if( GetStringUpperCase(GetStringLeft(resref, 2)) ==  "NW"){

        retval = getTrapType(resref);

    }else if(  GetStringUpperCase(GetStringLeft(resref, 2)) == "X2"){
        int tagnum = StringToInt(GetStringRight(resref, 1));
        int rem = tagnum % 4;
        switch (rem)
        {
        case 0:
            retval.type =    TRAP_BASE_TYPE_EPIC_SONIC;
            retval.setDC =   65;
            break;
        case 1:
            retval.type =   TRAP_BASE_TYPE_EPIC_ELECTRICAL;
            retval.setDC =   65;
            break;
        case 2:
            retval.type =   TRAP_BASE_TYPE_EPIC_FIRE;
            retval.setDC =   65;
            break;
        case 3:
            retval.type =   TRAP_BASE_TYPE_EPIC_FROST;
            retval.setDC =   65;
            break;
        default:
            break;
        }

    }
    */
    return retval;

}


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

    //SpawnScriptDebugger();                         503
    // DoMissileStorm(1, 14, GetSpellId(), 503,VFX_IMP_LIGHTNING_S ,DAMAGE_TYPE_ELECTRICAL, FALSE, TRUE );

    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);

    object objTrapped = GetSpellTargetObject();
    location spellLocation = GetSpellTargetLocation();

    //float fSize = 2.0f + nCasterLvl;

    //get rap from component bag and use it instead
    // if has item in component pouch
    // only check first item in pouch
    // - player should only have one item in there at a time for this spell
    object oTrap;
    object bag = GetItemPossessedBy(OBJECT_SELF, "componentbag");
    if(!GetIsObjectValid(bag) ){
        SpeakString("no component bag found", TALKVOLUME_SHOUT);
        return;
    }
    oTrap = GetFirstTrapInInventory(bag); //GetFirstItemInInventory(bag);
    if(!GetIsObjectValid(oTrap) || GetBaseItemType(oTrap) != BASE_ITEM_TRAPKIT){
        SpeakString("no trapkit found in bag", TALKVOLUME_SHOUT);
        return;
    }

    struct TrapInfo myTrap;
    myTrap = getTrapType(oTrap);


    // try to pass setDC with spellcraft
    int setTrapWasSuccessful = GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, myTrap.setDC);

    if( GetIsObjectValid(objTrapped) )
    {
         SpeakString("try to set trap on object ", TALKVOLUME_SHOUT);
         // if object is a door or container trap it rather than the floor
         CreateTrapOnObject(myTrap.type, objTrapped, STANDARD_FACTION_MERCHANT);
    }else{
        SpeakString("try to set trap on floor " , TALKVOLUME_SHOUT);
        if(setTrapWasSuccessful == TRUE){
            //spell caster must make attempt to set trap?
            object oTrapCreated = CreateTrapAtLocation(myTrap.type, GetLocation(oCaster), 2.0f, "", STANDARD_FACTION_MERCHANT);
            if(GetIsObjectValid(oTrapCreated)){
                AdjustReputation( oCaster, oTrapCreated, 100);
            }
        }

        // create waypoints at two locations - casters and spell targets
        // 5, summon freindly willowisp to walk waypoint from target location back to trap slowly.

    }
    // destroy oTrap if successfully used or not, just like with scrolls
    if( GetIsObjectValid(oTrap) ){
        DestroyObject(oTrap);
    }

    /*
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon = EffectSummonCreature("NW_S_badgerdire");
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        eSummon = EffectSummonCreature("NW_S_BOARDIRE");
    }

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
    */
}


