void main()
{

	object oPC = GetLastOpenedBy();

	if ( !GetIsPC(oPC) ) { return; }

	if ( GetItemPossessedBy(oPC, "mg_key1") == OBJECT_INVALID) { return; }

	object oPartyM = GetFirstFactionMember(oPC, FALSE);
	int rnum =  Random(4) +1;  // yields 1 to 4, or do you want the same randomly generated number on every party member?  if so put this line inside the loop as the first line
	//We stop when there are no more valid NPC's in the party.
	while( GetIsObjectValid(oPartyM) )
 	{
    		SetLocalInt(oPartyM,"randomport", rnum);
    		oPartyM = GetNextFactionMember(oPC, FALSE);
 	}

	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	// We stop when there are no more valid PC's in the party.
	while(GetIsObjectValid(oPartyMember) == TRUE)
 	{
	     // Do something to party member
	     SetLocalInt(oPartyM,"randomport", rnum);
	     // Get the next PC member of oPC's faction.
	     // If we put anything but oPC into this, it may be a totally
	     // unreliable loop!
	     oPartyMember = GetNextFactionMember(oPC, TRUE);
 	}

}
