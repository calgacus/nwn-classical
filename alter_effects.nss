#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"





// * based on the item type, return the factor to be applied to the damage
// * done by the missile.  default result is the parameter factor
float getAlteredMissileFactor(object item, float factor );
float getAlteredMissileFactor(object item, float factor )
{

    //////// VERY LOW VALUE
    if( GetTag(item) == "NW_IT_GEM001" ){
        return 0.5; //EffectDamage(nDam/2, DAMAGE_TYPE_PIERCING );
    }
    if( GetTag(item) == "NW_IT_GEM007" ){
        return 0.5; //EffectDamage(nDam/2, DAMAGE_TYPE_SLASHING );
    }
    if( GetTag(item) == "NW_IT_GEM002" ){
        return 0.5; //EffectDamage(nDam/2, DAMAGE_TYPE_BLUDGEONING  );
    }

    /////////  LOW VALUE
    if( GetTag(item) == "NW_IT_GEM014" ){ //Aventurine
        return 0.67; //EffectDamage(nDam/1.5, DAMAGE_TYPE_ACID);
    }
    if( GetTag(item) == "NW_IT_GEM004" ){ //Phenalope
        return 0.67; //EffectDamage(nDam/1.5, DAMAGE_TYPE_SONIC );
    }
    if( GetTag(item) == "NW_IT_GEM003" ){ //Amethyst
        return 0.67; //EffectDamage(nDam/1.5,  DAMAGE_TYPE_NEGATIVE );
    }
    if( GetTag(item) == "NW_IT_GEM015" ){ //Fluorspar
        return 0.67; //EffectDamage(nDam/1.5, DAMAGE_TYPE_COLD );
    }

    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        return factor; //EffectDamage(nDam, DAMAGE_TYPE_FIRE );
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        return 1.2;
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        return 1.3; //EffectDamage(nDam*1.3, DAMAGE_TYPE_COLD );
    }

    //////////////// HIGH VALUE

    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        return 1.6;//EffectDamage(nDam*1.6, DAMAGE_TYPE_ELECTRICAL );
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
        return 1.8;//EffectDamage(nDam*1.8, DAMAGE_TYPE_FIRE );
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
        return 2.0;//EffectDamage(nDam*2, DAMAGE_TYPE_COLD );
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        return 2.3;//EffectDamage(nDam*2.3, DAMAGE_TYPE_FIRE );
    }

    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
        return 2.6;//EffectDamage(nDam*2.6, DAMAGE_TYPE_ACID );
    }

    return factor;
}


// * return the new damage type done by the missile
// * default response is the parameter dType
int getAlteredMissileType(object item, int dType );
int getAlteredMissileType(object item, int dType )
{

    //////// VERY LOW VALUE
    if( GetTag(item) == "NW_IT_GEM001" ){
        return   DAMAGE_TYPE_PIERCING ;
    }
    if( GetTag(item) == "NW_IT_GEM007" ){
        return  DAMAGE_TYPE_SLASHING ;
    }
    if( GetTag(item) == "NW_IT_GEM002" ){
        return  DAMAGE_TYPE_BLUDGEONING  ;
    }

    /////////  LOW VALUE
    if( GetTag(item) == "NW_IT_GEM014" ){ //Aventurine
        return   DAMAGE_TYPE_ACID;
    }
    if( GetTag(item) == "NW_IT_GEM004" ){ //Phenalope
        return   DAMAGE_TYPE_SONIC ;
    }
    if( GetTag(item) == "NW_IT_GEM003" ){ //Amethyst
        return    DAMAGE_TYPE_NEGATIVE ;
    }
    if( GetTag(item) == "NW_IT_GEM015" ){ //Fluorspar
        return   DAMAGE_TYPE_COLD ;
    }

    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        return   DAMAGE_TYPE_FIRE ;
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        return 0;//code for either fire or acid
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        return   DAMAGE_TYPE_COLD ;
    }

    //////////////// HIGH VALUE

    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        return   DAMAGE_TYPE_ELECTRICAL ;
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
        return   DAMAGE_TYPE_FIRE ;
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
        return   DAMAGE_TYPE_COLD ;
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        return   DAMAGE_TYPE_FIRE ;
    }

    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
        return   DAMAGE_TYPE_ACID ;
    }

    return dType;
}


// * return the new damage type done by the shield
// * default response is the parameter dType
int getAlteredDamageShieldType(object item, int dType );
int getAlteredDamageShieldType(object item, int dType )
{

    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        return DAMAGE_TYPE_FIRE ;
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        return DAMAGE_TYPE_ACID;//  acid
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        return DAMAGE_TYPE_COLD ;
    }
    if( GetTag(item) == "NW_IT_MSMLMISC06" ){ //bodaks tooth
        return  DAMAGE_TYPE_NEGATIVE;
    }

    //////////////// HIGH VALUE

    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        return  DAMAGE_TYPE_ELECTRICAL;
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
         return  DAMAGE_TYPE_FIRE;
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
         return  DAMAGE_TYPE_COLD;
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        return  DAMAGE_TYPE_FIRE;
    }
    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
         return DAMAGE_TYPE_MAGICAL;
    }

    return dType;
}



// * based on the item type, return the factor to be applied to the damage
// * done by the shield.  default result is the parameter factor
float getAlteredDamageShieldFactor(object item, float factor );
float getAlteredDamageShieldFactor(object item, float factor )
{
    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        factor = 1.1;
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        factor = 1.1;//  acid
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        factor = 1.2 ;
    }
    if( GetTag(item) == "NW_IT_MSMLMISC06" ){ //bodaks tooth
        factor = 1.5;
    }


    //////////////// HIGH VALUE
    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        factor = 1.5;
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
        factor = 1.75;
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
        factor = 2.0;
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        factor = 2.3;
    }
    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
        factor = 1.5;
    }


    return factor;
}



// * based on the item type, return the extra percent to be applied
// * to the damage done by the acid sheath.  default result is 0.
// * used in the Mestils Acid Sheath spell.
int getAlteredSheathFactor(object item );
int getAlteredSheathFactor(object item )
{
    int factor = 0;
    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        factor = 5;
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        factor = 5;//  acid
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        factor = 8;
    }
    if( GetTag(item) == "NW_IT_MSMLMISC06" ){ //bodaks tooth
        factor = 10;
    }


    //////////////// HIGH VALUE
    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        factor = 15;
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
        factor = 15;
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
        factor = 20;
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        factor = 30;
    }
    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
        factor = 35;
    }

    return factor;
}


// * based on the item type, return the new type of damage.
// * default result is the parameter dType
int getAlteredTrapType(object item, int dType );
int getAlteredTrapType(object item, int dType )
{

    /////// MEDIUM VALUE
    if( GetTag(item) == "NW_IT_GEM011" ){ //Garnet      NW_IT_GEM011
        return DAMAGE_TYPE_FIRE ;
    }
    if( GetTag(item) == "NW_IT_GEM013" ){ //Alexandrite     NW_IT_GEM013
        return DAMAGE_TYPE_ACID;//  acid
    }
    if( GetTag(item) == "NW_IT_GEM010" ){ //Topaz       NW_IT_GEM010
        return DAMAGE_TYPE_COLD ;
    }
    if( GetTag(item) == "NW_IT_MSMLMISC06" ){ //bodaks tooth
        return  DAMAGE_TYPE_NEGATIVE;
    }

    //////////////// HIGH VALUE

    if( GetTag(item) == "NW_IT_GEM008" ){ // Sapphire   NW_IT_GEM008   1000
        return  DAMAGE_TYPE_ELECTRICAL;
    }
    if( GetTag(item) == "NW_IT_GEM009" ){ //   Fire Opal NW_IT_GEM009   1500
         return  DAMAGE_TYPE_FIRE;
    }
    if( GetTag(item) == "NW_IT_GEM005" ){ //Diamond   NW_IT_GEM005 2000
         return  DAMAGE_TYPE_COLD;
    }
    if( GetTag(item) == "NW_IT_GEM006" ){ //   ruby  NW_IT_GEM006  3000
        return  DAMAGE_TYPE_FIRE;
    }
    if( GetTag(item) == "NW_IT_GEM012" ){ //   Emerald NW_IT_GEM012   4000
         return DAMAGE_TYPE_MAGICAL;
    }

    return dType;
}


// * identify max items in oPC's crafting bag
// * return TRUE if an item was identified by the spell
// * FALSE otherwise
int identifyItemsInCraftingBag( object oPC, int max );
int identifyItemsInCraftingBag( object oPC, int max ){
    SpeakString("identifyItemsInCraftingBag", TALKVOLUME_SHOUT);
    object bag = GetItemPossessedBy(oPC, "craftingbag");
    object item = GetFirstItemInInventory(bag);
    int identified = FALSE;

    while(max > 0 && GetIsObjectValid(item)){
        if(GetIdentified(item) == FALSE){
            SetIdentified(item, TRUE);
            max--;
            identified = TRUE;
        }
        item = GetNextItemInInventory(bag);
    }
    return identified;
}



