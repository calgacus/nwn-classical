


struct dropInfo
{
    string itemResref;
    string name;
    string desc;
    string tag;
    int challengeRating;

};

// * set the item properties  dropInfo
// * returns the updated dropInfo struct
struct dropInfo setItemProperties(struct dropInfo retval, string name, string desc, string tag, string resref, int challengeRating);
struct dropInfo setItemProperties(struct dropInfo retval, string name, string desc, string tag, string resref, int challengeRating){
   retval.itemResref = resref;
   retval.name = name;
   retval.desc = desc;
   retval.tag = tag;
   retval.challengeRating = challengeRating;
   return retval;
}


// * sets creatures with custom drops to leave a lootable corpse
void setCustomDropLootable(object oSpawn);
void setCustomDropLootable(object oSpawn){
    string tag = GetTag(oSpawn);
    // add all creature tags to the tags string with a trailing comma
    // if you want them to leave a lootable corpse
    string tags = "";
    //"ks_small_spider,";
    //tags += "ungol_spider,";

    // most monster with CR of > 3 should have a chance to drop something

    if( FindSubString(tags, tag+"," ) > -1){
        //SetLootable(oSpawn, TRUE);
        SetIsDestroyable(TRUE, FALSE, TRUE);
        DelayCommand(1.0, SetLootable(oSpawn, TRUE));
    }
}


// * gets the dropInfo struct of the item dropped by oDropper,
// * ie the creature whose corpse is getting looted.
// * runs a Lore skill check for oSlayer to see if any blood or item
// * can be harvested from oDropper.
struct dropInfo getDropInfo(object oDropper, object oSlayer);
struct dropInfo getDropInfo(object oDropper, object oSlayer ){

    struct dropInfo retval;
    int sk = d20(1)+GetSkillRank(SKILL_LORE, oSlayer);
    int dc = 15 + FloatToInt(GetChallengeRating(oDropper)/2.0f);
    //SpeakString("skill test dc " + IntToString(dc)+ ", skill test check " + IntToString(sk), TALKVOLUME_SHOUT);

    if(sk < dc ){
        return retval;
    }
    string droppersTag = "%"+GetTag(oDropper)+"%";
    int racialType = GetRacialType(oDropper);
    if(racialType == 24){
        ///skeletal types do not drop eyes
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "skelet") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "skelet") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "lich") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "lich") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "wraith") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "wraith") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "spectre") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "spectre") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "allip") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "allip") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "shadow") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "shadow") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "mohrg") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "mohrg") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetName(oDropper)), "form") >-1) return retval;
         if( FindSubString(GetStringLowerCase( GetDescription(oDropper)), "form") >-1) return retval;

    };
    int skinChance = GetCreatureSize(oDropper) * 15;
    int bloodChance = GetCreatureSize(oDropper) * 15;
    int itemChance =  50;
    string query = "SELECT * from customdrops WHERE  creaturetype == @race ";

    //query += "AND @tag LIKE tag ";

    //SpeakString("query "+ query, TALKVOLUME_SHOUT);

    sqlquery dropquery = SqlPrepareQueryCampaign("classical", query);
    string err = SqlGetError(dropquery);
    //SpeakString("err 1  "+ err, TALKVOLUME_SHOUT);

    SqlBindInt(dropquery, "@race", racialType);
    err = SqlGetError(dropquery);
    if(err != "")
        SpeakString("err 2  "+ err, TALKVOLUME_SHOUT);



    while(SqlStep(dropquery)){
        string tags = GetStringLowerCase(SqlGetString(dropquery, 4));
        //SpeakString("Found partial tag: "+ SqlGetString(dropquery, 4));
        if(tags != ""){
            int indx = FindSubString(GetStringLowerCase(GetTag(oDropper)), tags);
            if(indx == -1){
                //SpeakString("Found partial tag "+tags+" does not match : "+ GetTag(oDropper));
                continue;
            }
        }
        //SpeakString("Found dro: "+ SqlGetString(dropquery, 0) +" " + SqlGetString(dropquery, 1), TALKVOLUME_SHOUT);

        //SpeakString("skill   check passed " , TALKVOLUME_SHOUT);
        string name = SqlGetString(dropquery,0);
        string desc = SqlGetString(dropquery,1);
        string tag = SqlGetString(dropquery,2);
        string resref = SqlGetString(dropquery,5);
        //SpeakString("tag "+tag , TALKVOLUME_SHOUT);
        if( FindSubString(GetStringLowerCase(tag), "blood") >-1){
          //  SpeakString("found blood 1" , TALKVOLUME_SHOUT);
            if(d100(1) < bloodChance){
               // SpeakString("found blood 2" , TALKVOLUME_SHOUT);
                //if there is an item it must have both properties set here
                return setItemProperties(retval, name, desc, tag, resref, FloatToInt(GetChallengeRating(oDropper)));
            }
        } else if( FindSubString(GetStringLowerCase(tag), "hide") >-1){
            if(d100(1) < skinChance){
                //if there is an item it must have both properties set here
                return setItemProperties(retval, name, desc, tag, resref, FloatToInt(GetChallengeRating(oDropper)));
            }
        } else{
            if(d100(1) < itemChance){
                return  setItemProperties(retval, name, desc, tag, resref, FloatToInt(GetChallengeRating(oDropper)));
            }
        }
    }///end while

    //if nothing found so far try for something else
    string tag = GetStringLowerCase(GetTag(oDropper));
    query = "SELECT name, desc, itemtag, resref, trim(creaturetag) from customdrops WHERE creaturetype IS NULL AND creaturetag IS NOT NULL ";

    //SpeakString("query "+ query, TALKVOLUME_SHOUT);

    sqlquery poisonquery = SqlPrepareQueryCampaign("classical", query);
    err = SqlGetError(poisonquery);
    if(err != "") SpeakString("err 1  "+ err, TALKVOLUME_SHOUT);

    while(SqlStep(poisonquery)){
        string tags = GetStringLowerCase(SqlGetString(poisonquery, 4));
        tags = tags+" ";
       // SpeakString("Found partial tag 1 : "+ SqlGetString(poisonquery, 4));
        int indx = 0;
        int indx2 = 0;
        indx2 = FindSubString( tags, " ", indx);
        while(indx2 != -1){
            string substr = GetSubString(tags, indx, indx2 - indx);
            // SpeakString("Found partial tag 2:"+substr+":" );
            if(substr != " " && substr != ""){
                // SpeakString("look for-"+substr+"." );
                if( GetChallengeRating(oDropper) >= 1.0 &&
                    FindSubString(GetStringLowerCase(GetTag(oDropper)), substr) > -1){
                    // SpeakString("Found partial tag 3 : "+substr );
                    string name = SqlGetString(poisonquery,0);
                    string desc = SqlGetString(poisonquery,1);
                    string tag = SqlGetString(poisonquery,2);
                    string resref = SqlGetString(poisonquery,3);
                    return setItemProperties(retval, name, desc, tag, resref, FloatToInt(GetChallengeRating(oDropper)));
                }
            } else{
                // SpeakString("found space char or empty string." );
            }
            if(indx == indx2){ indx = indx +1; }
            else { indx = indx2; }
            indx2 = FindSubString( tags, " ", indx);
        }
    }///end while


    return retval;
}


/* this empty vial requirement is going too far down the realism rabbithole
int takerHasVialOrBottle(object oTaker){
    if(GetIsPC(oTaker)){
         SpeakString("taker is pc ", TALKVOLUME_SHOUT);
    }
    return TRUE;

}
*/

