#include "x2_inc_switches"
#include "x2_inc_itemprop"


const int NoTry = 3;


// * itemA - D objects
// * tagA - tagD strings
struct itemsInfo
{
    object itemA;
    object itemB;
    object itemC;
    object itemD;
    string tagA;
    string tagB;
    string tagC;
    string tagD;
};

// * return TRUE if baseType is a bludgeoning melee weapon
// * FALSE if else
int isBludWeapon(int baseType){
    if( baseType == BASE_ITEM_DIREMACE   ||
        baseType == BASE_ITEM_HEAVYFLAIL   ||
        baseType == BASE_ITEM_LIGHTFLAIL   ||
        baseType == BASE_ITEM_LIGHTHAMMER   ||
        baseType == BASE_ITEM_LIGHTMACE   ||
        baseType == BASE_ITEM_MORNINGSTAR   ||
        baseType == BASE_ITEM_WARHAMMER
    ){
        return TRUE;
    }
    return FALSE;
}

// * return TRUE if baseType is a hardenable weapon
// * FALSE if else
int isHardenableWeapon(int baseType);
int isHardenableWeapon(int baseType){
    if( baseType == BASE_ITEM_BASTARDSWORD  ||
        baseType == BASE_ITEM_BATTLEAXE   ||
        baseType == BASE_ITEM_DAGGER    ||
        baseType == BASE_ITEM_DIREMACE   ||
        baseType == BASE_ITEM_DOUBLEAXE   ||
        baseType == BASE_ITEM_DWARVENWARAXE   ||
        baseType == BASE_ITEM_GREATAXE   ||
        baseType == BASE_ITEM_GREATSWORD   ||
        baseType == BASE_ITEM_HALBERD   ||
        baseType == BASE_ITEM_HANDAXE   ||
        baseType == BASE_ITEM_HEAVYFLAIL   ||
        baseType == BASE_ITEM_KAMA   ||
        baseType == BASE_ITEM_KATANA   ||
        baseType == BASE_ITEM_KUKRI   ||
        baseType == BASE_ITEM_LIGHTFLAIL   ||
        baseType == BASE_ITEM_LIGHTHAMMER   ||
        baseType == BASE_ITEM_LIGHTMACE   ||
        baseType == BASE_ITEM_LONGSWORD   ||
        baseType == BASE_ITEM_MORNINGSTAR   ||
        baseType == BASE_ITEM_RAPIER   ||
        baseType == BASE_ITEM_SCIMITAR   ||
        baseType == BASE_ITEM_SCYTHE   ||
        baseType == BASE_ITEM_SHORTSPEAR   ||
        baseType == BASE_ITEM_SHORTSWORD   ||
        baseType == BASE_ITEM_SICKLE   ||
        baseType == BASE_ITEM_TRIDENT   ||
        baseType == BASE_ITEM_TWOBLADEDSWORD   ||
        baseType == BASE_ITEM_WARHAMMER
    ){
        return TRUE;
    }
    return FALSE;
}

// * return TRUE if baseType is armor, hemlet or  shield
// * FALSE if else
int isArmor(int baseType);
int isArmor(int baseType){
    if( baseType == BASE_ITEM_ARMOR ||
        baseType == BASE_ITEM_HELMET ||
        baseType == BASE_ITEM_LARGESHIELD ||
        baseType == BASE_ITEM_SMALLSHIELD ||
        baseType == BASE_ITEM_TOWERSHIELD
    ){
        SpeakString("item is a piece of armor  "+IntToString(baseType), TALKVOLUME_SHOUT);
        return TRUE;
    }
    SpeakString("item is not  piece of armor  "+IntToString(baseType), TALKVOLUME_SHOUT);
    return FALSE;
}

int GetArmorBaseACValue(object oArmor)
{
    // Get the appearance of the torso slot
    int nAppearance = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
    // Look up in parts_chest.2da the relevant line, which links to the actual AC bonus of the armor
    // We cast it to int, even though the column is technically a float.
    int nAC = StringToInt(Get2DAString("parts_chest", "ACBONUS", nAppearance));
    // Return the given AC value (0 to 8)
    return nAC;
}

// * return TRUE if the item is soft armor that can can be toughened
// * else FALSE
int isToughenable(object item);
int isToughenable(object item){
    if(GetBaseItemType(item) == BASE_ITEM_ARMOR ){
        int ac = GetArmorBaseACValue(item);
        if(ac >=1 && ac <=3)  return TRUE;
    }
    return FALSE;
}

// * apply helmet skill penalties depeneding on tailored and hardened status
// * return TRUE if new or altered penalties applied,
// * FALSE if not.
int applyHelmetPenalties(object item, int tailored, int hardness);
int applyHelmetPenalties(object item, int tailored, int hardness){
    SpeakString("applyHelmetPenalties   ", TALKVOLUME_SHOUT);
    if(hardness <= 0){
        return FALSE;
    }
    int skillpen = 6;
    int skillbon = 2;
    if(hardness > 2){
       skillpen = 4; //mithral is awesome
       skillbon += 2;
    }
    if(tailored > 0){
       SpeakString("applyHelmetPenalties if tailored "+ IntToString(skillpen) + " bon " + IntToString(skillbon) , TALKVOLUME_SHOUT);
       skillpen -= 2;
       skillbon += 2;
    }else{
      SpeakString("applyHelmetPenalties else  pen "+ IntToString(skillpen) + " bon " + IntToString(skillbon) , TALKVOLUME_SHOUT);
    }

    SpeakString("applyHelmetPenalties pen "+ IntToString(skillpen) + " bon " + IntToString(skillbon) , TALKVOLUME_SHOUT);
    itemproperty ip2 = ItemPropertyDecreaseSkill( SKILL_SEARCH, skillpen);
    itemproperty ip4 = ItemPropertyDecreaseSkill( SKILL_LISTEN, skillpen);
    itemproperty ip6 = ItemPropertyDecreaseSkill( SKILL_PERFORM, skillpen);
    itemproperty ip7 = ItemPropertyDecreaseSkill( SKILL_PERSUADE, skillpen);
    itemproperty ip9 = ItemPropertyDecreaseSkill( SKILL_SPELLCRAFT, skillpen);
    itemproperty ip10 = ItemPropertyDecreaseSkill( SKILL_SPOT, skillpen);
    itemproperty ip11 = ItemPropertyDecreaseSkill( SKILL_TAUNT, skillpen);

    itemproperty ip13 = ItemPropertySkillBonus ( SKILL_CONCENTRATION, skillbon);
    itemproperty ip14 =  ItemPropertySkillBonus( SKILL_DISCIPLINE, skillbon);

    IPSafeAddItemProperty(item, ip2, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip4, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip6, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip7, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip9, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip10, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip11, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip13, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    IPSafeAddItemProperty(item, ip14, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, FALSE);
    SpeakString("applyHelmetPenalties  end ", TALKVOLUME_SHOUT);
    return TRUE;
}


// * returns the first of any light armors found among in the items in info
object getLightArmor(struct itemsInfo info);
object getLightArmor(struct itemsInfo info){
    object retval;
    if(!GetIsObjectValid(info.itemA)) return retval;
    if(GetIsObjectValid(info.itemA) &&
        isToughenable(info.itemA)){
        return info.itemA;
    }
    if(GetIsObjectValid(info.itemB) &&
        isToughenable(info.itemB)){
        return info.itemB;
    }
    if(GetIsObjectValid(info.itemC) &&
        isToughenable(info.itemC)){
        return info.itemC;
    }
    if(GetIsObjectValid(info.itemD) &&
        isToughenable(info.itemD)){
        return info.itemD;
    }
    return retval;

}

// * toughen soft armor.
// * item to be toughened should be soft body armor eg leather armor
// * hardness the ac bonus to give to the item
// * return TRUE if item is successfully toughened,
// * FALSE if the attempt is really made but fails dues to a skill check fail
// * and NoTry if the attempt cannot even be made eg: due to lack of gold
int toughenItem( int hardness, struct itemsInfo info);
int toughenItem( int hardness, struct itemsInfo info){
    object item;
    item = getLightArmor(info);
    if( !GetIsObjectValid(item) || hardness <= 0 ){
        return NoTry;
    }
    if( GetLocalInt(item, "hardness") > 0){
        SpeakString("Oh, this was already toughened and cannot be further toughened.", TALKVOLUME_WHISPER);
        return NoTry;
    }
    if(GetGold() < 1000){
        SpeakString("Oh, I'll need at least 1000 gold to do this.", TALKVOLUME_WHISPER);
        return NoTry;
    }


    int success = FALSE;
    int cost = 1000;
    //run skill check
    //if success
        SetLocalInt(item, "hardness", hardness);
        //inc AC
        itemproperty ipac = ItemPropertyACBonus(hardness);
        IPSafeAddItemProperty( item, ipac, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        success = TRUE;
        SpeakString("Success!", TALKVOLUME_WHISPER);
        //make success sound    VOICE_CHAT_YES     VOICE_CHAT_TASKCOMPLETE  VOICE_CHAT_LAUGH VOICE_CHAT_CHEER
        // PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE, oPC);
    //else on fail
        // cost = cost/4
        //SpeakString("Curses! Foiled again!", TALKVOLUME_WHISPER);
        //make cuss sound     VOICE_CHAT_CUSS  VOICE_CHAT_BADIDEA VOICE_CHAT_NO
        // PlayVoiceChat(VOICE_CHAT_CUSS, oPC);

    // TakeGoldFromCreature(cost, oPC, TRUE);
    // destroy ingredients
    // return success;

    return NoTry;
}


// * returns first any war gear object found among in the items
object getWargear(struct itemsInfo info);
object getWargear(struct itemsInfo info){
    object retval;

    if(GetIsObjectValid(info.itemA) &&
        isArmor(GetBaseItemType(info.itemA)) ||
        isHardenableWeapon(GetBaseItemType(info.itemA))){
        return info.itemA;
    }
    if(GetIsObjectValid(info.itemB) &&
        isArmor(GetBaseItemType(info.itemB)) ||
        isHardenableWeapon(GetBaseItemType(info.itemB))){
        return info.itemB;
    }
    if(GetIsObjectValid(info.itemC) &&
        isArmor(GetBaseItemType(info.itemC)) ||
        isHardenableWeapon(GetBaseItemType(info.itemC))){
        return info.itemC;
    }
    if(GetIsObjectValid(info.itemD) &&
        isArmor(GetBaseItemType(info.itemD)) ||
        isHardenableWeapon(GetBaseItemType(info.itemD))){
        return info.itemD;
    }
    return retval;
}


// * harden the item,
// * return TRUE if the item gets hardened by the current function call
// * else FALSE
int hardenItem( int hardness, struct itemsInfo info);
int hardenItem( int hardness, struct itemsInfo info){
    object item = getWargear(info);
    if( GetIsObjectValid(item) && hardness > 0 ){
        if( GetLocalInt(item, "hardness") > 0){
            return FALSE;
        }
        itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER, hardness);
        IPSafeAddItemProperty(item, ip,  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        SetLocalInt(item, "hardness", hardness);
        if(isArmor(GetBaseItemType(item)) == TRUE){
            //if helmet apply penalties
            if(GetBaseItemType(item) == BASE_ITEM_HELMET){
                applyHelmetPenalties(item, GetLocalInt(item, "tailor"), hardness);
            }
            //inc AC
            if(hardness > 2) hardness = 2;
            itemproperty ipac = ItemPropertyACBonus(hardness);
            IPSafeAddItemProperty(item, ipac,  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);

        }
        if(isHardenableWeapon(GetBaseItemType(item)) == TRUE){
            if(!isBludWeapon(GetBaseItemType(item))){
                itemproperty ipac =  ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_1 );
                IPSafeAddItemProperty(item, ipac,  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            }
        }
        return TRUE;
    }
    return FALSE;
}

/**
   // NW_AARCL003 scale
   // NW_AARCL012 chain shirt
   // NW_AARCL004 chain mail

   // NW_AARCL011 banded
   // NW_AARCL005 splint
   // the above types can be hardened and tailored but
   // cannot be shaped or specialized or perfected

   //  NW_AARCL010 breast plate
   //  NW_AARCL006 half plate
   //  NW_AARCL007 full plate
**/

// * tailor an item,
// * return TRUE if tailored by the current function call
// * else return FALSE
int tailorItem( struct itemsInfo info, int race=-1, int gender=-1, int pheno=-1);
int tailorItem( struct itemsInfo info, int race=-1, int gender=-1, int pheno=-1){
    SpeakString("tailorItem  ", TALKVOLUME_SHOUT);
    object item = getWargear(info);
    if(!GetIsObjectValid(item)) {
        item = getLightArmor(info);
    }
    if(!GetIsObjectValid(item)) {
         SpeakString("tailorItem invalid item ", TALKVOLUME_SHOUT);
         return FALSE;
    }
    if( GetBaseItemType(item) != BASE_ITEM_ARMOR &&
        GetBaseItemType(item) != BASE_ITEM_HELMET ) {
        SpeakString("tailorItem not armor or helmet ", TALKVOLUME_SHOUT);
        return FALSE;
    }
    if(race <= -1 || gender <= -1 || pheno <= -1){
        SpeakString("tailorItem call MISSING PARAMS.", TALKVOLUME_SHOUT);
        return FALSE;
    }
    int hardness = GetLocalInt(item, "hardness");
    if( hardness == 0 &&
        GetBaseItemType(item) == BASE_ITEM_HELMET ) {
        SpeakString("Helmets must be hardened before tailored.", TALKVOLUME_SHOUT);
        return FALSE;
    }
    SpeakString("tailorItem 1 .", TALKVOLUME_SHOUT);
    int tailor = GetLocalInt(item, "tailor");
    int done = FALSE;
    if(tailor < 1){
        SpeakString("tailorItem 2 .", TALKVOLUME_SHOUT);
        //itemproperty ip = ItemPropertyLimitUseByRace(race);
        SetLocalInt(item, "tailorrace", race);
        SetLocalInt(item, "tailorgender", gender);
        SetLocalInt(item, "tailorsize", pheno);
        if( GetBaseItemType(item) == BASE_ITEM_ARMOR ) {
            if(hardness > 2) {
                hardness == 2;
            }
        }  //helmets have no such limit
        SpeakString("tailorItem 3 .", TALKVOLUME_SHOUT);
        SetLocalInt(item, "tailor", 1);
        itemproperty ipac = ItemPropertyACBonus(hardness+1);
        IPSafeAddItemProperty(item, ipac,  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
        if(GetBaseItemType(item) == BASE_ITEM_HELMET ) {
            SpeakString("apply helmet stuff   ", TALKVOLUME_SHOUT);
            applyHelmetPenalties(item, 1, hardness+1);
        }
        SpeakString("tailored Item  ", TALKVOLUME_SHOUT);
        return TRUE;
    }else{
        SpeakString("Already fully tailored.", TALKVOLUME_SHOUT);
    }
    return FALSE;
}



// * return the %chance of something geting smashed
// * if chance is negative then apply it to
// * the weapon instead of the armor - so hard armor might smash the weapon
int getChanceToShatter(object oArmor, object oDefender, int chance, int weaponHardness, int weaponType);
int getChanceToShatter(object oArmor, object oDefender, int chance, int weaponHardness, int weaponType){

    int armorHardness = GetLocalInt(oArmor, "hardness");
    chance += armorHardness;
    chance += GetAbilityModifier(ABILITY_STRENGTH, oDefender);

    if (Random(100) < chance){
        chance = weaponHardness - armorHardness;
        // if hardness-es equal then
        // there should still be a small
        // chance of a shatter event
        if(chance == 0){
            //assume 2 in 5 chance of weapon xor armor shattering
            chance = Random(5);
            if(chance == 2){chance = -1;}
            else if(chance > 2){ chance = 0; }
        }
        if(chance < 0){
            // Most bladed melee weapons can be shattered
            // but some melee weapons cannot as they are small
            // or used in a way not really compatible with huge swinging chops
            // i.e. Daggers, picks and kamas.
            // Bludgeoning weapons like maces do not shatter as they are made
            // of a thick chunk of metal on the business end.
            // There is yet no breaking of wooden handles and shafts breaking
            // and therefore wands clubs, rods, staves
            // and quarterstaffs do not get shattered (nor can they be hardened)
            if( weaponType == BASE_ITEM_BASTARDSWORD ||
                weaponType == BASE_ITEM_BATTLEAXE ||
                weaponType == BASE_ITEM_DOUBLEAXE ||
                weaponType == BASE_ITEM_DWARVENWARAXE ||
                weaponType == BASE_ITEM_GREATAXE ||
                weaponType == BASE_ITEM_GREATSWORD ||
                weaponType == BASE_ITEM_HALBERD ||
                weaponType == BASE_ITEM_KATANA ||
                weaponType == BASE_ITEM_LONGSWORD ||
                weaponType == BASE_ITEM_RAPIER ||
                weaponType == BASE_ITEM_SCIMITAR ||
                weaponType == BASE_ITEM_SCYTHE ||
                weaponType == BASE_ITEM_SHORTSWORD ||
                weaponType == BASE_ITEM_SICKLE ||
                weaponType == BASE_ITEM_KUKRI ||
                weaponType == BASE_ITEM_TWOBLADEDSWORD
            ){
                return chance;
            }
        }else if( //some weapons can shatter armors, some can't
                weaponType == BASE_ITEM_WARHAMMER ||
                weaponType == BASE_ITEM_DIREMACE ||
                weaponType == BASE_ITEM_HEAVYFLAIL ||
                weaponType == BASE_ITEM_MORNINGSTAR ||
                weaponType == BASE_ITEM_LIGHTFLAIL ||
                weaponType == BASE_ITEM_LIGHTMACE ||
                weaponType == BASE_ITEM_LIGHTHAMMER ||
                weaponType == BASE_ITEM_BATTLEAXE ||
                weaponType == BASE_ITEM_DOUBLEAXE ||
                weaponType == BASE_ITEM_DWARVENWARAXE ||
                weaponType == BASE_ITEM_GREATAXE ||
                weaponType == BASE_ITEM_THROWINGAXE ||
                weaponType == BASE_ITEM_HALBERD ||
                weaponType == BASE_ITEM_SCYTHE
                )
        {
            return chance;

        }
    }
    return 0;
}

// * hardened spears and tridents can cause extra damage on Called Shots
void applyCalledShotBonus(  object oTarget, int weaponType, int attackType );
void applyCalledShotBonus(  object oTarget, int weaponType, int attackType ){

    if( weaponType == BASE_ITEM_SHORTSPEAR ||
        weaponType == BASE_ITEM_TRIDENT ||
        weaponType == BASE_ITEM_RAPIER)
    {
        if(attackType == SPECIAL_ATTACK_CALLED_SHOT_ARM ||
           attackType == SPECIAL_ATTACK_CALLED_SHOT_LEG )
        {
            if( GetIsWeaponEffective(oTarget) ){
                int bonus  = 0;
                bonus = d6(1);

                effect damage1;
                damage1 = EffectDamage(bonus, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, damage1, oTarget);
            }
        }
    } // end called shot check
}

// * scythes, flails and morningstars can do extra damage when using the
// * Dirty Fighting feat againt an opponent using a shield
// * you can imagine the weapon getting over the top of a defenders shield and
// * wrapping around it and landing a hit to the head for example
// * returns TRUE when the weapon is succeeds at wrapping a shield
int tryToWrapAroundShield(object oAttacker, object oTarget, int weaponType );
int tryToWrapAroundShield(object oAttacker, object oTarget, int weaponType ){
    int wrappedShield = FALSE;
    if( weaponType == BASE_ITEM_HEAVYFLAIL  ||
        weaponType == BASE_ITEM_MORNINGSTAR  ||
        weaponType == BASE_ITEM_LIGHTFLAIL ||
        weaponType == BASE_ITEM_SCYTHE )
    {

        // this should not work on every try,
        // lets just say it has a chanceToWork sometimes
        int chanceToWork = 50;
        if(Random(100) < chanceToWork){ return wrappedShield; }

        int mode = GetLastAttackMode(oAttacker);
        if(mode == COMBAT_MODE_DIRTY_FIGHTING)
        {

            object shield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);

            if(GetIsObjectValid(shield))
            {
                int shtype = GetBaseItemType(shield);

                if( shtype == BASE_ITEM_LARGESHIELD ||
                    shtype == BASE_ITEM_SMALLSHIELD ||
                    shtype == BASE_ITEM_TOWERSHIELD )
                {
                    if( GetItemInSlot( INVENTORY_SLOT_LEFTHAND , oAttacker) != OBJECT_INVALID){
                        //say why attack didnt work
                        FloatingTextStringOnCreature("This weapon should be used with two-hands for full effect of the Dirty Fighting feat.", oAttacker, TRUE);
                        return FALSE;
                    }
                    if( !GetIsWeaponEffective(oTarget) ){
                        return TRUE; //assume it hit but creature is immune
                    }
                    int bonus  = 0;
                    if( weaponType == BASE_ITEM_HEAVYFLAIL )
                    {
                        bonus = d10(1);
                    }
                    if( weaponType == BASE_ITEM_MORNINGSTAR ||
                        weaponType == BASE_ITEM_SCYTHE)
                    {
                        bonus = d8(1);
                    }
                    if( weaponType == BASE_ITEM_LIGHTFLAIL )
                    {
                        bonus = d4(1);
                    }
                    effect damage1;
                    effect damage2;
                    if( weaponType == BASE_ITEM_SCYTHE )
                    {
                        damage1 = EffectDamage(bonus, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL);
                        damage2 = EffectDamage(bonus, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL);
                    }else{
                        damage1 = EffectDamage(bonus, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
                        damage2 = EffectDamage(bonus, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL);
                    }
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, damage1, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, damage2, oTarget);
                    wrappedShield = TRUE;
                }
            }
        }
    } // end dirty fighting check
    return wrappedShield;
}

// * Returns TRUE if oAttacker is using a flail or morning star but is
// * unable to use it to full effect due to weakness or one handedness.
// * FALSE otherwise.
// * Flails and Morning Stars must be used with two hands to have full effect
// * (i.e. with nothing in the left hand)
int cannotUseTheFlailWellEnough(int weaponType, object oAttacker);
int cannotUseTheFlailWellEnough(int weaponType, object oAttacker){
    if( weaponType == BASE_ITEM_HEAVYFLAIL ){
        // only the strong can wield Heavy Morning Stars to full effect
        // no special effects if strength below 16
        int minStrModifier = 3;
        int str = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);

        if(str < minStrModifier){
            //say why item was not successful
            if(GetIsPC(oAttacker)) {
                //AssignCommand(oAttacker, ActionUnequipItem(GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oAttacker)));
                FloatingTextStringOnCreature("I am too weak to use this weapon for it's full dirty fighting effect!", oAttacker, TRUE);
                PlayVoiceChat(VOICE_CHAT_CUSS, oAttacker);
            }
            return TRUE;
        }
    }
    if( weaponType == BASE_ITEM_HEAVYFLAIL ||
        weaponType == BASE_ITEM_LIGHTFLAIL ||
        weaponType == BASE_ITEM_MORNINGSTAR ){
        //cannot have anything in left hand
        if( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oAttacker) != OBJECT_INVALID){
            //say why attack didnt work
            FloatingTextStringOnCreature("This weapon should be used with two-hands for full effect.", oAttacker, TRUE);
            return TRUE;
        }
    }
    return FALSE;
}

// * shatter a softer weapon or plate armor, shield or helmet upon a hit
// * return TRUE if an item is smashed, else FALSE
int ShatterItem(object oHardItem, object oHardItemHolder, object oTargetCreature);
int ShatterItem(object oHardItem, object oHardItemHolder, object oTargetCreature){

    // FIRST: assume oHardItem is a weapon
    int weaponType = GetBaseItemType(oHardItem);
    object oAttacker = oHardItemHolder;
    object oDefender = oTargetCreature;
    object oWeapon = oHardItem;
    object oArmor;
    int applySpecialAttacks = TRUE;
    int originalHardItemIsWeapon = TRUE;
    int wrappedShield = FALSE;

    // NEXT: if oHardItem is a piece of armor then
    // switch the attacker and defender
    if( weaponType == BASE_ITEM_ARMOR ||
        weaponType == BASE_ITEM_HELMET ||
        weaponType == BASE_ITEM_SMALLSHIELD ||
        weaponType == BASE_ITEM_TOWERSHIELD ||
        weaponType == BASE_ITEM_LARGESHIELD ){
        applySpecialAttacks = FALSE;
        oAttacker = oTargetCreature;
        oDefender = oHardItemHolder;
        oWeapon = GetLastWeaponUsed(oAttacker);
        if(!GetIsObjectValid( oWeapon )){
            return FALSE;
            // assuming GetLastWeaponUsed function returns nothing for
            // bites, claws and open hand attacks, etc
        }
        weaponType = GetBaseItemType(oWeapon);
        // if the weapon is a ranged weapon other than a throwing axe
        // quite as they cannot smash or be smashed
        if( GetWeaponRanged(oWeapon) == TRUE &&
            weaponType != BASE_ITEM_THROWINGAXE)
        {
            return FALSE;
        }
        oArmor = oHardItem;
        originalHardItemIsWeapon = FALSE;
    }
    int attackType = GetLastAttackType(oAttacker);
    int armorType = -1;

    if( originalHardItemIsWeapon == TRUE){
        oArmor = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDefender);
        armorType = GetBaseItemType(oArmor);
        if( armorType != BASE_ITEM_LARGESHIELD &&
            armorType != BASE_ITEM_SMALLSHIELD &&
            armorType != BASE_ITEM_TOWERSHIELD
            ){
            armorType = -1;
        }
        if( armorType == -1 ){
            oArmor = GetItemInSlot(INVENTORY_SLOT_HEAD, oDefender);
            armorType = GetBaseItemType(oArmor);
            if( armorType != BASE_ITEM_HELMET ){
                armorType = -1;
            }
        }
        if( armorType == -1 ){
            oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oDefender);
            armorType = GetBaseItemType(oArmor);
            if( armorType != BASE_ITEM_ARMOR ){
                armorType = -1;
            }
        }
    }else{
        armorType = GetBaseItemType(oArmor);
    }
    if(armorType == -1 || armorType == BASE_ITEM_INVALID){
        return FALSE; //not sure how we would get here but anyhoo
    }

    // special attacks do not apply to shatter attacks arising from the
    // onhit property of armor, only from weapons
    if(applySpecialAttacks == TRUE){
        if(cannotUseTheFlailWellEnough(weaponType, oAttacker) == TRUE){
            return FALSE;
        }
        applyCalledShotBonus( oDefender, weaponType, attackType);
        wrappedShield = tryToWrapAroundShield( oAttacker, oDefender, weaponType );
    }

    //if attacker is using certain special attack forms skip smash check
    if(attackType == SPECIAL_ATTACK_CALLED_SHOT_ARM ||
       attackType == SPECIAL_ATTACK_CALLED_SHOT_LEG ||
       attackType == SPECIAL_ATTACK_DISARM ||
       attackType == SPECIAL_ATTACK_IMPROVED_DISARM  ||
       attackType == SPECIAL_ATTACK_IMPROVED_KNOCKDOWN  ||
       attackType == SPECIAL_ATTACK_KNOCKDOWN ){
       return FALSE;
    }

    int weaponHardness = GetLocalInt(oWeapon, "hardness");
    int chance = weaponHardness;

    string smashedNote = "";
    string soundTag = "";

    int strbonus = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);
    // adjust for strength
    if( weaponType == BASE_ITEM_HALBERD ||
        weaponType == BASE_ITEM_GREATAXE ||
        weaponType == BASE_ITEM_HEAVYFLAIL ||
        weaponType == BASE_ITEM_GREATSWORD ||
        weaponType == BASE_ITEM_SCYTHE
        ){
        strbonus = FloatToInt( strbonus * 1.5f );
    }
    chance += strbonus;

    // for shields
    if( armorType == BASE_ITEM_LARGESHIELD &&
        armorType == BASE_ITEM_SMALLSHIELD &&
        armorType == BASE_ITEM_TOWERSHIELD)
    {
        if( wrappedShield == FALSE )
        {
            smashedNote = "MY SHIELD SHATTERED!";
            soundTag = "cb_ht_bladewood1";
            //if the shield is hadened use metal sound
            if(GetLocalInt(oArmor, "hardness") > 0){
               soundTag = "cb_ht_bladeplat1";
            }
            if( weaponType == BASE_ITEM_DIREMACE ||
                weaponType == BASE_ITEM_LIGHTMACE ||
                weaponType == BASE_ITEM_MORNINGSTAR ){
                chance += 1;
            }

            if( weaponType == BASE_ITEM_WARHAMMER ||
                weaponType == BASE_ITEM_HEAVYFLAIL ||
                weaponType == BASE_ITEM_BATTLEAXE  ||
                weaponType == BASE_ITEM_DOUBLEAXE  ||
                weaponType == BASE_ITEM_DWARVENWARAXE ||
                weaponType == BASE_ITEM_GREATAXE ||
                weaponType == BASE_ITEM_THROWINGAXE ||
                weaponType == BASE_ITEM_HALBERD ){
                chance += 3; // most axes are good at breaking shields
            }else if( weaponType == BASE_ITEM_GREATAXE ){
                chance += 6; //great axes are great at this
            }
        }
    }else if( armorType == BASE_ITEM_HELMET )
    {
        smashedNote = "MY HELMET SHATTERED!";
        soundTag = "cb_ht_bladeplat1";

        if(wrappedShield){
           chance += 2;//a surprise hit to the helmet should help the odds
        }

        if( weaponType == BASE_ITEM_WARHAMMER ){
            chance += 6;// warhammers are made for this
        }
        if( weaponType == BASE_ITEM_DIREMACE ||
            weaponType == BASE_ITEM_MORNINGSTAR ||
            weaponType == BASE_ITEM_HEAVYFLAIL  ||
            weaponType == BASE_ITEM_LIGHTMACE ){
            chance += 3;// maces are also made for this but not quite as well as warhammers
        }

    }else if( armorType == BASE_ITEM_ARMOR )
    {
        if(FindSubString(GetStringLowerCase(GetName(oArmor)), "plate") == -1){
            //only reasonable wway to detect breast plate
            return FALSE;
        }
        smashedNote = "MY BREASTPLATE SHATTERED!";
        soundTag = "cb_ht_bladeplat2";

        if( weaponType == BASE_ITEM_WARHAMMER ){
            chance += 6;// warhammers are made for this
        }
        if( weaponType == BASE_ITEM_DIREMACE ||
            weaponType == BASE_ITEM_MORNINGSTAR ||
            weaponType == BASE_ITEM_HEAVYFLAIL  ||
            weaponType == BASE_ITEM_LIGHTMACE ){
            chance += 3;// maces are also made for this but not quite as well as warhammers
        }
    }

    chance = getChanceToShatter(oArmor, oDefender, chance, weaponHardness, weaponType );

    if( Random(100) <= chance ){
        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oDefender);
        PlaySound(soundTag);
        DestroyObject(oArmor);
        if(GetIsPC(oDefender) == TRUE){
            PlayVoiceChat(VOICE_CHAT_CUSS, oDefender);
        }
        FloatingTextStringOnCreature(smashedNote, oDefender, FALSE);
        return TRUE;
    }else if( chance < 0 && Random(100) <= (-1*chance) ){
        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAttacker);
        soundTag = "cb_ht_bladeplat1";
        PlaySound(soundTag);
        DestroyObject(oWeapon);
        smashedNote = "MY WEAPON SHATTERED!";
        if(GetIsPC(oAttacker) == TRUE){
            PlayVoiceChat(VOICE_CHAT_CUSS, oAttacker);
        }
        FloatingTextStringOnCreature(smashedNote, oAttacker, FALSE);

        return TRUE;
    }
    return FALSE;
}


// * return the poison from poison.2da that is created by mixing one
// * or two poisons and/or a blood
// * return 0 on error or fail (if no recipe exists )
int getPoisonType(object PoisonA, object PoisonB, object oBlood );
int getPoisonType(object PoisonA, object PoisonB, object oBlood  ){
    int TagnumA = StringToInt(GetStringRight(GetTag(PoisonA),2));
    int PoisonAType = TagnumA % 6;
    int PoisonAStr = FloatToInt(TagnumA / 6.01f)+1 ;

    int TagnumB = -1;
    int PoisonBType = -1;
    int PoisonBStr = -1;

    if(GetIsObjectValid(PoisonB))  {
        TagnumB = StringToInt(GetStringRight(GetTag(PoisonB),2));
        PoisonBType = TagnumB % 6;
        PoisonBStr = FloatToInt(TagnumB / 6.01f)+1 ;
    }
    int Psum = PoisonAStr + PoisonBStr;
    if(!GetIsObjectValid(PoisonB) || (PoisonBType == PoisonAType && !GetIsObjectValid(oBlood) ) ){
        // only a few basic poisons are created from one poison vial
        // these may require strong poisons
        if(PoisonAType == 1)  {// str
            SpeakString("Found strength poison", TALKVOLUME_SHOUT);
            if(Psum < 4)return POISON_TINY_SPIDER_VENOM;   //4
            if(Psum < 7)return POISON_SMALL_SPIDER_VENOM;  //6
            if(Psum == 7)return POISON_MEDIUM_SPIDER_VENOM;  //8
            if((Psum >= 8) && (Psum < 14) ) return POISON_LARGE_SPIDER_VENOM;//12
            if(Psum == 14) return POISON_WRAITH_SPIDER_VENOM;     //18
            return -1;
        }
        if(PoisonAType == 2)  {     // dex
            SpeakString("Found dex poison", TALKVOLUME_SHOUT);
            if(Psum < 2)return POISON_NIGHTSHADE;//3
            if(Psum < 4)return POISON_SMALL_CENTIPEDE_POISON; //4
            if(Psum >= 4 && Psum < 6 )return POISON_MALYSS_ROOT_PASTE;//5
            if(Psum >= 6 && Psum < 8) return  POISON_QUASIT_VENOM;    //12
            if(Psum >= 8 && Psum < 11) return POISON_ETTERCAP_VENOM;    //14
            if(Psum >= 11 && Psum < 14) return POISON_GIANT_WASP_POISON;  //12
            if(Psum >= 14) return POISON_TERINAV_ROOT;  //18
            return -1;
        }
        if(PoisonAType == 3)  {     // con
            SpeakString("Found con poison", TALKVOLUME_SHOUT);
            if(Psum < 3) return POISON_GREENBLOOD_OIL;  //3
            if(Psum >= 3 && Psum < 8) return POISON_BLADE_BANE; //7
            if(Psum >= 8 && Psum < 14 ) return POISON_ARSENIC;  //17
            if(Psum == 14) return POISON_DEATHBLADE ;  //18
            return -1;
        }
        if(PoisonAType == 4)  {     // int
            SpeakString("Found int poison", TALKVOLUME_SHOUT);
            if(Psum > 6 && Psum < 8) return POISON_OIL_OF_TAGGIT;
            if(Psum >= 8 && Psum <=10 ) return POISON_CARRION_CRAWLER_BRAIN_JUICE;
            if(Psum >= 11) return POISON_ID_MOSS;  //16
            return -1;
        }
        if(PoisonAType == 5)  {// wis
            SpeakString("Found wis poison", TALKVOLUME_SHOUT);
            if(Psum > 3 && PoisonAStr <= 7 )return POISON_BLOODROOT;// 7
            if(Psum >= 8 && Psum < 12)return POISON_STRIPED_TOADSTOOL;  //13
            if(Psum >= 12)return POISON_CHAOS_MIST;    //16
            return -1;
        }
        if(PoisonAType == 6)  {     // chr
            SpeakString("Found chr poison", TALKVOLUME_SHOUT);
            if(Psum > 4 && Psum <= 7) return POISON_UNGOL_DUST;   //7
            if(Psum >  7 && Psum < 9) return POISON_BLUE_WHINNIS ; //sleep
            if(Psum >= 9) return POISON_SASSONE_LEAF_RESIDUE; //acid 6 con
            return -1;
        }
        return -1; //just in case....
    }

    if( PoisonAType == PoisonBType && Psum >= 2 && GetIsObjectValid(oBlood)){
        //special poisons made with 1 poison and 1 blood
        if(PoisonAType == 1 && GetTag(oBlood) == "verminblood")  {// str
            SpeakString("Found strength poison", TALKVOLUME_SHOUT);
            if(Psum < 5)return POISON_ARANEA_VENOM;   //4
            if(Psum < 8)return  POISON_PURPLE_WORM_POISON;  //6
            if(Psum < 14)return  POISON_HUGE_SPIDER_VENOM;  //8
            if(Psum >= 14 && GetLocalInt(oBlood, "rating") <= 13 ) return  POISON_COLOSSAL_SPIDER_VENOM;//12
            if(Psum >= 14 && GetLocalInt(oBlood, "rating") >= 13) return POISON_GARGANTUAN_SPIDER_VENOM ;     //18
            return -1;
        }
        if(PoisonAType == 1 && GetTag(oBlood) == "dragonblood")  {// str
            SpeakString("Found strength poison", TALKVOLUME_SHOUT);
            if(Psum > 7 && GetLocalInt(oBlood, "rating") > 5) return POISON_DRAGON_BILE ;//18
            return -1;
        }
        if(PoisonAType == 1 && GetTag(oBlood) == "aberrationblood")  {// str
            SpeakString("Found strength poison", TALKVOLUME_SHOUT);
            if(Psum > 7 && GetLocalInt(oBlood, "rating") > 3  ) return POISON_SHADOW_ESSENCE  ;//18
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "aberrationblood")  {// con
            SpeakString("Found aberrationblood", TALKVOLUME_SHOUT);
            if(Psum > 7 && GetLocalInt(oBlood, "rating") > 3  ) return  POISON_NITHARIT  ;//18
            if(Psum >= 9 && GetLocalInt(oBlood, "rating") > 4  ) return   POISON_PHASE_SPIDER_VENOM  ;//24
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "monsterblood")  {// con
            SpeakString("Found monsterblood", TALKVOLUME_SHOUT);
            if(Psum >= 11 && GetLocalInt(oBlood, "rating") > 4  ) return    POISON_IRON_GOLEM  ;//d4 death
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "wyvernblood")  {// con
            SpeakString("Found wyvernblood", TALKVOLUME_SHOUT);
            if(Psum >= 11 && GetLocalInt(oBlood, "rating") > 4  ) return     POISON_WYVERN_POISON  ;//24
            if(Psum >  7 && GetLocalInt(oBlood, "rating") > 2  ) return    POISON_BURNT_OTHUR_FUMES  ;//18
            if(Psum >  12 && GetLocalInt(oBlood, "rating") > 7  ) return  44     ;//24   epic wyvern poison
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "direblood")  {// con
            SpeakString("Found direblood", TALKVOLUME_SHOUT);
            if(Psum >  7 && GetLocalInt(oBlood, "rating") > 4  ) return     POISON_DARK_REAVER_POWDER  ;//24
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "firegiantblood")  {// con
            SpeakString("Found firegiantblood", TALKVOLUME_SHOUT);
            if(Psum >  12 && GetLocalInt(oBlood, "rating") > 7  ) return POISON_BEBILITH_VENOM;//18
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "frostgiantblood")  {// con
            SpeakString("Found frostgiantblood", TALKVOLUME_SHOUT);
            if(Psum >  12 && GetLocalInt(oBlood, "rating") > 7  ) return  POISON_BLACK_LOTUS_EXTRACT;//36
            return -1;
        }
        if(PoisonAType == 3 && GetTag(oBlood) == "reptileblood")  {// con
            SpeakString("Found frostgiantblood", TALKVOLUME_SHOUT);
            if(Psum >  13 && GetLocalInt(oBlood, "rating") > 11  ) return   POISON_PIT_FIEND_ICHOR;//18 death         }else
            return -1;
        }
        if(PoisonAType != PoisonBType && Psum > 3 && GetIsObjectValid(oBlood)){
            //mixes of different poisons
            if(PoisonAType == 1 && PoisonAType == 3 && GetTag(oBlood) == "goblinblood")  {// con
                if(Psum >  3 && GetLocalInt(oBlood, "rating") > 2  ) return POISON_BLADE_BANE   ;// d6           }else
                return -1;
            }
            return -1;
        }
    }

    return -1;
}

// * return the disease from disease.2da that is created by mixing the
// * blood in info
// * return 0 on error or fail (if no recipe exists )
int getDiseaseType(struct itemsInfo info );
int getDiseaseType(struct itemsInfo info ){
    return 0;
}

// * Tries culture a vial of disease from the standard ones indisease.2da
// * the new vial can be applied to a weapon or a spike trap
int cultureDisease(object oPC, object bag, struct itemsInfo info );
int cultureDisease(object oPC, object bag, struct itemsInfo info){
    int dType = getDiseaseType(info );
    return dType;
}






// * returns a disease found among the items in info
object getOneDisease(struct itemsInfo info, int index);
object getOneDisease(struct itemsInfo info, int index){
    object retval;
    int found = 0;

    if(info.tagA == "disease"){
        found++;
        if(found == index) return info.itemA;
    }
    if(info.tagB == "disease"){
        found++;
        if(found == index) return info.itemB;
    }
    if(info.tagC == "disease"){
        found++;
        if(found == index) return info.itemC;
    }
    if(info.tagD == "disease"){
        found++;
        if(found == index) return info.itemD;
    }
    return retval;
}



// * returns a blood found among the items in info
object getOneBlood(struct itemsInfo info, int index);
object getOneBlood(struct itemsInfo info, int index){
    object retval;
    int found = 0;

    if(info.tagA == "blood"){
        found++;
        if(found == index) return info.itemA;
    }
    if(info.tagB == "blood"){
        found++;
        if(found == index) return info.itemB;
    }
    if(info.tagC == "blood"){
        found++;
        if(found == index) return info.itemC;
    }
    if(info.tagD == "blood"){
        found++;
        if(found == index) return info.itemD;
    }
    return retval;
}


// * returns a poison found among the items in info
object getOnePoison(struct itemsInfo info, int index);
object getOnePoison(struct itemsInfo info, int index){
    object retval;
    int found = 0;

    if(info.tagA == "poison"){
        found++;
        if(found == index) return info.itemA;
    }
    if(info.tagB == "poison"){
        found++;
        if(found == index) return info.itemB;
    }
    if(info.tagC == "poison"){
        found++;
        if(found == index) return info.itemC;
    }
    if(info.tagD == "poison"){
        found++;
        if(found == index) return info.itemD;
    }
    return retval;
}

// * returns a trap found among the items in info
object getTrap(struct itemsInfo info);
object getTrap(struct itemsInfo info){
    object retval;

    if( info.tagA == "trapkit"){
        return info.itemA;
    }
    if( info.tagB == "trapkit"){
        return info.itemB;
    }
    if( info.tagC == "trapkit"){
        return info.itemC;
    }
    if( info.tagD == "trapkit"){
        return info.itemD;
    }
    return retval;
}


// * Tries brew a vial of poison from the standard ones in poison.2da
// * the new vial can be applied to a weapon or a spike trap
int brewPoison(object oPC, object bag, struct itemsInfo info);
int brewPoison(object oPC, object bag, struct itemsInfo info){
    return getPoisonType(getOnePoison(info, 1), getOnePoison(info, 2), getOneBlood(info, 1) );

}



// * Tries to add a disease from a vial to a spike trap.
// * returns TRUE upon success, FALSE otherwise
// * uses up the vial regardless.
int diseaseTrap(object oPC, struct itemsInfo info);
int diseaseTrap(object oPC, struct itemsInfo info){
    object oTrap = getTrap(info);
    object oDiseaseA = getOneDisease(info, 1);
    int success = FALSE;
    int traptype = GetTrapBaseType(oTrap);
    if( traptype < 0 || traptype > 3 ){
        SpeakString("Only Spike Traps can take poison.", TALKVOLUME_SHOUT);
        return success;
    }

    //28 is standard applyDC for applying deadly poisons to weapons
    int applyDC = (traptype*5) + 10; //maxes at 25

    if(GetSkillRank(SKILL_LORE, oPC) >=  applyDC){
        SpeakString("  passed check ", TALKVOLUME_SHOUT);
        int diseaseid =  GetLocalInt( oDiseaseA, "diseaseid");
        if(diseaseid == -1){
            SpeakString(" no disease applied  ", TALKVOLUME_SHOUT);
            return success;
        }
        SetLocalInt( oTrap, "isDiseased", 1);
        SetLocalInt( oTrap, "diseaseid", diseaseid);
        SpeakString(" applied disease diseaseid  "+ IntToString(diseaseid), TALKVOLUME_SHOUT);
        success = TRUE;
    }

    DestroyObject(oDiseaseA);
    SpeakString(" diseaseTrap done   ", TALKVOLUME_SHOUT);
    return success;
}


// * Tries to add a poison from a vial to a spike trap.
// * returns TRUE upon success, FALSE otherwise
// * uses up all vials regardless.
// * the poisons applied are the standard poison.2da poisons
int poisonTrap(object oPC, struct itemsInfo info);
int poisonTrap(object oPC, struct itemsInfo info){

    object oTrap = getTrap(info);
    object oPoisonA = getOnePoison(info, 1);
    int success = FALSE;
    int traptype = GetTrapBaseType(oTrap);
    if( traptype < 0 || traptype > 3 ){
        SpeakString("Only Spike Traps can take poison.", TALKVOLUME_SHOUT);
        return success;
    }

    //28 is standard applyDC for applying deadly poisons to weapons
    int applyDC = (traptype*5) + 13; //maxes at 28

    if(GetSkillRank(SKILL_LORE, oPC) >=  applyDC){
        SpeakString("  passed check ", TALKVOLUME_SHOUT);
        int poisonid =  GetLocalInt( oPoisonA, "poisonid");
        if(poisonid == -1){
            SpeakString(" no poison applied  ", TALKVOLUME_SHOUT);
            return success;
        }
        SetLocalInt( oTrap, "ispoisoned", 1);
        SetLocalInt( oTrap, "poisonid", poisonid);
        SpeakString(" applied poison poisonid  "+ IntToString(poisonid), TALKVOLUME_SHOUT);
        success = TRUE;
    }

    DestroyObject(oPoisonA);
    SpeakString(" poisonTrap done   ", TALKVOLUME_SHOUT);
    return success;
}



// * Tries to concentrate two vials of poison into one stronger poison
// * returns TRUE upon success, FALSE otherwise
int concentratePoison(object oPC, object bag, struct itemsInfo info);
int concentratePoison(object oPC, object bag, struct itemsInfo info){
    object poisonA = getOnePoison(info, 1);
    object poisonB = getOnePoison(info, 2);
    int poisonATagnum = StringToInt(GetStringRight(GetTag(poisonA),2));
    int poisonAPoison = poisonATagnum % 6;
    int poisonAStr = FloatToInt(poisonATagnum / 6.01f)+1;

    int poisonBTagnum = StringToInt(GetStringRight(GetTag(poisonB),2));
    int poisonBPoison = poisonBTagnum % 6;
    int poisonBStr = FloatToInt(poisonBTagnum / 6.01f)+1 ;

    if(poisonAStr > 6 || poisonBStr > 6){
          SpeakString("Poison already at maximum concentration.", TALKVOLUME_SHOUT);
          return FALSE;
    }
    if(poisonBPoison != poisonAPoison){
        SpeakString("Poisons do not match, you cannot mix different types of poisons when concentrating them.", TALKVOLUME_SHOUT);
        SpeakString("Poisons "+IntToString(poisonAPoison) +" "+ IntToString(poisonBPoison), TALKVOLUME_SHOUT);
        return FALSE;
    }
    int max = poisonBStr + poisonAStr;
    if(max > 7) max = 7;
    if(GetGold(oPC) < (10 * max)){
        SpeakString("You need at least "+ IntToString(10 * max)+ " gold to do that.", TALKVOLUME_SHOUT);
        return FALSE;
    }
    int success = FALSE;
    if(GetSkillRank(SKILL_LORE, oPC) - (max*2 + 13) >= 0){
        //clscl_ble_07
        SpeakString("  passed check ", TALKVOLUME_SHOUT);
        string power = "Anemic";
        string resref = "clscl_";
        if(max == 2){power= " Weak";}
        if(max == 3){power= " Mild";}
        if(max == 4){power= " Average";}
        if(max == 5){power= " Strong";}
        if(max == 6){power= " Very Strong";}
        if(max == 7){power= " Deadly";}
        if(poisonAPoison == 1){resref+= "bav_";}
        if(poisonAPoison == 2){resref+= "trt_";}
        if(poisonAPoison == 3){resref+= "ble_";}
        if(poisonAPoison == 4){resref+= "idm_";}
        if(poisonAPoison == 5){resref+= "sts_";}
        if(poisonAPoison == 6){resref+= "und_";}


        resref += "0";
        if( (6*( max - 1)) + (poisonAPoison) < 10){
            resref += "0";
        }
        resref += IntToString((6*( max - 1)) + (poisonAPoison));
        SpeakString("  resref  "+resref, TALKVOLUME_SHOUT);
        object vial = CreateItemOnObject( resref, bag, 1, resref);

        if(GetIsObjectValid(vial)){
            SpeakString("  made vial  ", TALKVOLUME_SHOUT);
            success = TRUE;
            int commaIndx = FindSubString(GetName(vial), ",");
            string newName = GetStringLeft(GetName(vial), commaIndx+1) + power;
            SetName(vial, newName);

            DestroyObject(poisonA);
            DestroyObject(poisonB);
        }else{
           SpeakString("That should have worked, but it didn't.", TALKVOLUME_SHOUT);
        }
    }else{
        DestroyObject(poisonA);
        DestroyObject(poisonB);

    }
    SpeakString("  done   ", TALKVOLUME_SHOUT);
    return success;
}


// * try to create a healing kit with up to max bonus
// * oPC is the pc attemptin to craft the kit
// * bag is the crafting bag holding the components
// * max is the maximum bonus of the healing kit
// * Dc is the DC of the Lore skill check needed to succeed
// * the bonus of the kit will be = ((skill check) - DC) +1
// * return TRUE if kit is created, else FALSE
int createHealingKit(object oPC, object bag, struct itemsInfo info, int max);
int createHealingKit(object oPC, object bag, struct itemsInfo info, int max){
    int skill = GetSkillRank(SKILL_LORE, oPC);
    int DC = (max + 11);
    int check = skill - DC;
    int success = FALSE;

    if(check >= 0){
        check++;
        if(check > max) check = max;
        object kit = CreateItemOnObject("nw_it_medkit001", bag, 1, "healingkit_"+IntToString(check));
        SetName(kit, "Healing Kit +"+IntToString(check));
        if(GetIsObjectValid(kit)){
            itemproperty ipac = ItemPropertyHealersKit(check);
            IPSafeAddItemProperty(kit, ipac,  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
            success = TRUE;
        }
    }

    DestroyObject(info.itemA);
    DestroyObject(info.itemB);
    DestroyObject(info.itemC);
    return success;
}


// * try to create recipe based on the components in the PCs crafting_bag
// * return TRUE if an object gets created,
// * FALSE otherwise
int tryRecipeFromComponents( object oPC );
int tryRecipeFromComponents( object oPC ){
    SpeakString("tryRecipeFromComponents", TALKVOLUME_SHOUT);
    object bag = GetItemPossessedBy(oPC, "craftingbag");
    struct itemsInfo info;
    int numberOfItems = 0;
    object item = GetFirstItemInInventory(bag);
    int bloodnum = 1;
    int poisonnum = 1;
    string itemtag = "";
    while(GetIsObjectValid(item)){
        itemtag = "";
        if( isToughenable(item) ){
            itemtag = "lightarmor";
            SpeakString(" mainItem tag " + GetTag(item), TALKVOLUME_SHOUT);
        }else if( isArmor(GetBaseItemType(item)) || isHardenableWeapon(GetBaseItemType(item))){
            itemtag = "wargear";
            SpeakString(" mainItem tag " + GetTag(item), TALKVOLUME_SHOUT);
        }else if( FindSubString(GetStringLowerCase(GetTag(item)), "_it_poison")){
            itemtag = "%" + "poison"+ IntToString(poisonnum) +"%";
            poisonnum++;
        }else if( FindSubString(GetStringLowerCase(GetTag(item)), "_disease")){
            itemtag = "%" + "disease"+ IntToString(poisonnum) +"%";
        }else if( FindSubString(GetStringLowerCase(GetTag(item)), "blood")){
            itemtag = "%" + "blood"+ IntToString(bloodnum)  +"%";
            // NW_IT_MSMLMISC17 X3_IT_WYVERNBLD
        }else if( FindSubString(GetStringLowerCase(GetTag(item)),GetStringLowerCase( "NW_IT_TRAP"))){
            itemtag = "%" + "trapkit" +"%";
        }else{
            ///////////// other items ///////////
            itemtag = "%" + GetStringUpperCase(GetTag(item)) +"%";
        }

        if(!GetIsObjectValid(info.itemA) ){
            info.itemA = item;
            info.tagA = itemtag;
        }else if(!GetIsObjectValid(info.itemB) ){
            info.itemB = item;
            info.tagB = itemtag;
        }else if(!GetIsObjectValid(info.itemC) ){
            info.itemC = item;
            info.tagC = itemtag;
        }else if(!GetIsObjectValid(info.itemD) ){
            info.itemD = item;
            info.tagD = itemtag;
        }
        numberOfItems++;

        item = GetNextItemInInventory(bag);
    }
    if(numberOfItems > 1){
        SpeakString("found " +IntToString(numberOfItems) +" items", TALKVOLUME_SHOUT);
    }else{
        SpeakString("not enough items ", TALKVOLUME_SHOUT);
        return FALSE; //need at leat 2 items to craft anything
    }

    string query = "SELECT * from recipes WHERE numberOfItems == @numberOfItems ";
    if(numberOfItems > 0 && info.tagA != " " ){
        query += "AND upper(ingredient_tags) LIKE @inga ";
    }
    if(numberOfItems > 1 && info.tagB != " "){
        query += "AND upper(ingredient_tags) LIKE @ingb ";
    }
    if(numberOfItems > 2 && info.tagC != " "){
        query += "AND upper(ingredient_tags) LIKE @ingc ";
    }
    if(numberOfItems > 3 && info.tagD != " " ){
        query += "AND upper(ingredient_tags) LIKE @ingd ";
    }

    sqlquery recipequery;
    SpeakString("query "+ query, TALKVOLUME_SHOUT);

    recipequery = SqlPrepareQueryCampaign("classical", query);
    string err = SqlGetError(recipequery);
    SpeakString("err 1  "+ err, TALKVOLUME_SHOUT);

    SqlBindInt(recipequery, "@numberOfItems", numberOfItems);
    err = SqlGetError(recipequery);
    SpeakString("err 2  "+ err, TALKVOLUME_SHOUT);

    if(numberOfItems >= 2){
       SqlBindString(recipequery, "@inga", info.tagA);
       SpeakString( info.tagA, TALKVOLUME_SHOUT);

       err = SqlGetError(recipequery);
       SpeakString("err 3  "+ err, TALKVOLUME_SHOUT);

       SqlBindString(recipequery, "@ingb", info.tagB);
       SpeakString( info.tagB, TALKVOLUME_SHOUT);

       err = SqlGetError(recipequery);
       SpeakString("err 4  "+ err, TALKVOLUME_SHOUT);
    }
    if(numberOfItems > 2 && info.tagC != " " ){
       SqlBindString(recipequery, "@ingc", info.tagC);
       SpeakString( info.tagC, TALKVOLUME_SHOUT);

       err = SqlGetError(recipequery);
       SpeakString("err 5  "+ err, TALKVOLUME_SHOUT);
    }
    if(numberOfItems > 3 && info.tagD != " " ){
        SqlBindString(recipequery, "@ingd", info.tagD);
        SpeakString( info.tagD, TALKVOLUME_SHOUT);

        err = SqlGetError(recipequery);
        SpeakString("err 6  "+ err, TALKVOLUME_SHOUT);
    }

    err = SqlGetError(recipequery);
    SpeakString("err post  "+ err, TALKVOLUME_SHOUT);

    while(SqlStep(recipequery)){
        SpeakString("Found recipe: "+ SqlGetString(recipequery, 0) +" " + SqlGetString(recipequery, 1), TALKVOLUME_SHOUT);
        //if harden recipe
        if(SqlGetString(recipequery, 0) == "harden"){
            SpeakString("Found a Harden recipe:", TALKVOLUME_SHOUT);
            return hardenItem(SqlGetInt(recipequery,3), info);
        }
        //if tailor recipe
        if(SqlGetString(recipequery, 0) == "tailor"){
            SpeakString("Found a Tailor armor recipe:", TALKVOLUME_SHOUT);
            return tailorItem(info, GetRacialType(oPC), GetGender(oPC), GetPhenoType(oPC));
        }
        //if toughen recipe
        if(SqlGetString(recipequery, 0) == "toughen"){
            SpeakString("Found a Toughen (light armor) recipe:", TALKVOLUME_SHOUT);
            return toughenItem( SqlGetInt(recipequery, 3), info);
        }
        //if create heal kit
        if(SqlGetString(recipequery, 0) == "healkit"){
            SpeakString("Found a healing kit recipe:", TALKVOLUME_SHOUT);
            int max = SqlGetInt(recipequery, 3);

            return createHealingKit( oPC, bag, info, max);
        }
        //if concentrate poison
        if(SqlGetString(recipequery, 0) == "poison concentrate"){
            SpeakString("Found a concentrate poison recipe:", TALKVOLUME_SHOUT);
            return concentratePoison(oPC, bag, info);
            //add kit ot bag
            //remove components from bag
        }
        //if add poison to spike trap
        if(SqlGetString(recipequery, 0) == "trap poison"){
            SpeakString("Found a spiketrap recipe:", TALKVOLUME_SHOUT);
            return poisonTrap(oPC, info);
            //add kit ot bag
            //remove components from bag
        }
        //if add disease to spike trap
        if(SqlGetString(recipequery, 0) == "trap disease"){
            SpeakString("Found a spiketrap recipe:", TALKVOLUME_SHOUT);
            return diseaseTrap(oPC, info);
            //add kit ot bag
            //remove components from bag
        }
        //if brew poison
        if(SqlGetString(recipequery, 0) == "poison brew"){
            SpeakString("Found a brew poison recipe:", TALKVOLUME_SHOUT);
            return brewPoison(oPC, bag, info);
            //add kit ot bag
            //remove components from bag
        }
        //if culture disease
        if(SqlGetString(recipequery, 0) == "disease culture"){
            SpeakString("Found a culture a disease recipe:", TALKVOLUME_SHOUT);
            return cultureDisease(oPC, bag, info);
            //add kit to bag
            //remove components from bag
        }
    }
    SpeakString("end, no recipe found   ");
    return FALSE;
}
