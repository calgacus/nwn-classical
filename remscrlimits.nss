void main()
{
    //remove all class use limitations from all scrolls
    //add inherent value to all scrolls
    object opc = GetLastOpenedBy();

    SpeakString("1 starting",TALKVOLUME_SHOUT );
    SpeakString("2 OBJECT_SELF is valid? " + IntToString( GetIsObjectValid(OBJECT_SELF)), TALKVOLUME_SHOUT );

    object scroll = GetFirstItemInInventory(OBJECT_SELF);
    SpeakString("2.b scroll is valid? " + IntToString( GetIsObjectValid(scroll)), TALKVOLUME_SHOUT );

    SpeakString("3 found a  " + IntToString( GetBaseItemType(scroll)));

    while(GetIsObjectValid(scroll)){
        SpeakString("4 found  a  "  + IntToString( GetBaseItemType(scroll)), TALKVOLUME_SHOUT);
        if( GetBaseItemType(scroll)==BASE_ITEM_SPELLSCROLL ||
            GetBaseItemType(scroll)==BASE_ITEM_ENCHANTED_SCROLL   ) {
            SpeakString("found a scroll", TALKVOLUME_SHOUT);

            //Get the first itemproperty on the helmet
            itemproperty ipLoop=GetFirstItemProperty(scroll);

            //Loop for as long as the ipLoop variable is valid
            while (GetIsItemPropertyValid(ipLoop))
            {
                //If ipLoop is a true seeing property, remove it
                if (GetItemPropertyType(ipLoop)== ITEM_PROPERTY_USE_LIMITATION_CLASS)
                    RemoveItemProperty(scroll, ipLoop);

                //Next itemproperty on the list...
                ipLoop=GetNextItemProperty(scroll);
                SpeakString("Remove Item Property   ", TALKVOLUME_SHOUT);
            }//end loop      GetIsItemPropertyValid
        }
        scroll = GetNextItemInInventory(OBJECT_SELF);
    }//end loop   GetIsObjectValid
    SpeakString("5 ending",TALKVOLUME_SHOUT );

}
