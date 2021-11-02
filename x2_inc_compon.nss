//::///////////////////////////////////////////////
//:: x2_inc_compon
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This include file has routines to handle the
    distribution of components requried for the
    XP2 crafting system.

*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  July 30, 2003
//:://////////////////////////////////////////////

#include "custom_drops"

const int MIN_SKILL_LEVEL = 5;



// * Drops craft items if killed or bashed
void craft_drop_items(object oSlayer);
// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable();

// * return the resref of the item to be dropped, stored on the dropper
struct dropInfo getResRefOfCustomDrop(object oDropper, object oSlayer);
struct dropInfo getResRefOfCustomDrop(object oDropper, object oSlayer){
    //is slayer a pc or in a party with a pc - then use a pc's Lore skill
    if(!GetIsPC(oSlayer)){
        object oLeader = GetFactionLeader(oSlayer);
        if(GetIsObjectValid(oLeader) && GetIsPC(oLeader)){
            oSlayer = oLeader;
            SpeakString(" PC leader found", TALKVOLUME_SHOUT);
        }else{
            SpeakString("no leader found", TALKVOLUME_SHOUT);
        }
    }
    return getDropInfo(oDropper, oSlayer);
}

void craft_drop_items(object oSlayer)
{
    // * only drop components if the player has some decent skill level
    // * the reason is to prevent clutter for players who have no interest
    // * in the crafting system
    string sResRef;
    if (GetSkillRank(SKILL_CRAFT_ARMOR, oSlayer) > MIN_SKILL_LEVEL || GetSkillRank(SKILL_CRAFT_WEAPON, oSlayer) > MIN_SKILL_LEVEL)
    {
        object oSelf = OBJECT_SELF;
        int nAppearance = GetAppearanceType(oSelf);

        string sCol = "Placeable_Drop";
        string sNumCol = "Placeable_Num";
        int bDoor = FALSE;
        int nNum = 1;

        if (GetObjectType(oSelf) == OBJECT_TYPE_CREATURE)
        {
            sCol = "Creature_Drop";
            sNumCol = "Creature_Num";

        }
        else
        if (GetObjectType(oSelf) == OBJECT_TYPE_DOOR)
        {
            sCol = "Door_Drop";
            bDoor = TRUE;
            sNumCol = "Door_Num";
        }
        // * if does not have an inventory then treat as a door
        if (GetHasInventory(OBJECT_SELF) == FALSE)
            bDoor = TRUE;

        // * appearance type is index into the 2da
        sResRef = Get2DAString("des_crft_drop", sCol, nAppearance );


        string sNum = Get2DAString("des_crft_drop", sNumCol, nAppearance);
        if (sNum != "****" && sNum != "")
        {
            nNum = StringToInt(sNum);
        }

        if (sResRef != "****" && sResRef != "")
        {
            int i = 1;
            location lLoc = GetLocation(OBJECT_SELF);

            // * By default only spawn 1 of each unless otherwise indicated
            for (i=1; i<=nNum; i++)
            {
                if (bDoor == TRUE)
                {
                    CreateObject(OBJECT_TYPE_ITEM, sResRef, lLoc);
                }
                else
                    CreateItemOnObject(sResRef, oSelf); // * create item on object's inventory
            }
        }
    }

    //////////////////// get custom drops ///////////////////////////////////
    //if( GetStringLength( sResRef) > 0 ) return; /// only one drop per beastie
    struct dropInfo droppedItem;
    SpeakString("get droppedItem    " , TALKVOLUME_SHOUT);
    droppedItem = getResRefOfCustomDrop(OBJECT_SELF, oSlayer);
    SpeakString("drop info name " + droppedItem.name, TALKVOLUME_SHOUT);
    if(GetStringLength( droppedItem.itemResref) > 0  ){

        SpeakString("droppedItem  ==  " +droppedItem.itemResref , TALKVOLUME_SHOUT);
        if ( GetStringLength( droppedItem.itemResref) > 0 )
        {
            // By default only spawn 1 of each unless otherwise indicated
            // create item on object's inventory
            object newitem = CreateItemOnObject(droppedItem.itemResref, OBJECT_SELF);
            SetName(newitem, droppedItem.name);
            SetDescription(newitem, droppedItem.desc);
            SetTag(newitem, droppedItem.tag);
        }

    }
}

// * handles dropping crafting items if a placeable is bashed
void craft_drop_placeable()
{
    object oKiller = GetLastKiller();
    // * I was bashed!
    if (GetIsObjectValid(oKiller) == TRUE)
    {
        craft_drop_items(oKiller);
    }
}

