//Create Supply crate of weapons and Items. Items specified in arrays. Weapons and ammo gained from config.
//Correct ammo and muzzles selected for each weapon. Some random selection. _wepFilter will filter out any 'weapons' that you don't want adding.
//Created by axeman. Please ask to use / copy / edit or distribute: axeman@thefreezer.co.uk
private["_crate","_pos","_centre","_rad","_elev","_wepsItem","_magsFood","_magsDrink","_magsMedix","_magsItem","_magsClothes","_backpacks","_wep","_wepName","_wepMod","_wepPic","_wepClass","_wepScope","_wepKey"];
private["_wepStrScope","_wepAmmo","_wepMuzzles","_pClass","_wepArray","_wepTmpArray","_muzzleArray","_rndNum","_wepFilter","_wepSelect","_ammoArray","_cfgweapons","_rndAmmo","_rndMuzzle","_muzzleScope","_itemPcent"];
//diag_log "AXELOG:BOX STARTED";
AXE_fnc_findNestedElement = compile preprocessFileLineNumbers "\z\addons\dayz_server\modules\dayZDM\fn_findNestedElement.sqf";
_centre = DZE_DMLocation;
_rad = _this select 0;
_elev = 6;
_itemPcent = 60;
_cfgweapons = [];
_wepAmmo = [];
_wepFilter=["ItemKeyRed","ItemKeyYellow","ItemKeyBlue","ItemKeyGreen","ItemKeyBlack","ItemKey","MeleeSledge","MeleeFishingPole","MeleeMachete","MeleeCrowbar","MeleeHatchet","MeleeFlashlightRed","MeleeFlashlight"];//Catch missed weapons - Can be used to filter out further weapons.
_wepArray = [];//Weapon,Ammo,Muzzles

//Weapon and Cargo Arrays - Actual weapons are worked out from config.:
_magsItem = [["PartEngine",15],["PartGeneric",15],["PartVRotor",5],["PartWheel",20],["PartFueltank",15],["PartGlass",30],["ItemJerrycan",20],["ItemSandbag",30],["ItemTankTrap",30],["ItemWire",30],["ItemTentDomed",12],["TrapBear",20],["ItemHotwireKit",6],["ItemDocument",6]];
_magsMedix = [["ItemBandage",30],["ItemPainkiller",30],["ItemMorphine",30],["ItemBloodBag",30],["ItemEpinephrine",15],["ItemAntibiotic",30]];
_magsDrink = [["ItemSodaCoke",20],["ItemSodaPepsi",20],["ItemSodaMdew",20],["ItemSodaRbull",20],["ItemSodaOrangeSherbet",20]];
_magsFood = [["FoodCanBakedBeans",20],["FoodCanSardines",20],["FoodCanFrankBeans",20],["FoodCanPasta",20],["FoodCanUnlabeled",20],["FoodPistachio",20],["FoodNutmix",20],["FoodMRE",20]];
_magsClothes = [["Skin_Ins_Soldier_GL_DZ",6],["Skin_GUE_Commander_DZ",6],["Skin_Bandit1_DZ",6],["Skin_Bandit2_DZ",6],["Skin_BanditW1_DZ",6],["Skin_BanditW2_DZ",6],["Skin_TK_INS_Soldier_EP1_DZ",6],["Skin_TK_INS_Warlord_EP1_DZ",6],["Skin_SurvivorWcombat_DZ",6],["Skin_SurvivorWdesert_DZ",6],["Skin_GUE_Soldier_MG_DZ",6],["Skin_GUE_Soldier_Sniper_DZ",6],["Skin_GUE_Soldier_Crew_DZ",6],["Skin_GUE_Soldier_CO_DZ",6],["Skin_GUE_Soldier_2_DZ"],["Skin_Camo1_DZ",6],["Skin_Sniper1_DZ",6],["Skin_Rocket_DZ",6],["Skin_Soldier1_DZ",6],["Skin_Drake_Light_DZ",6],["Skin_Soldier_TL_PMC_DZ",6],["Skin_Soldier_Sniper_PMC_DZ",6],["Skin_Soldier_Bodyguard_AA12_PMC_DZ",6],["Skin_CZ_Special_Forces_GL_DES_EP1_DZ",6],["Skin_FR_OHara_DZ",6],["Skin_FR_Rodriguez_DZ",6],["Skin_CZ_Soldier_Sniper_EP1_DZ",6],["Skin_Graves_Light_DZ"]];
_wepsItem = [["NVGoggles",12],["ItemGPS",12],["ItemToolbox",5],["ItemEtool",5],["ItemWatch",6],["ItemMap",6],["ItemCompass",6],["ItemFlashlightRed",6],["ItemFlashlight",6],["ItemShovel",6],["ItemFishingPole",6],["ItemSledge",6],["ItemKeyKit",6]];
_backpacks = [["DZ_Assault_Pack_EP1"],["DZ_Czech_Vest_Puch"],["DZ_TerminalPack_EP1"],["DZ_ALICE_Pack_EP1"],["DZ_TK_Assault_Pack_EP1"],["DZ_CompactPack_EP1"],["DZ_British_ACU"],["DZ_GunBag_EP1"],["DZ_CivilBackpack_EP1"],["DZ_Backpack_EP1"],["DZ_LargeGunBag_EP1"]];

_cfgweapons = configFile >> "cfgWeapons";
for "_i" from 0 to (count _cfgweapons)-1 do {
_wepName = "";
_wepMod = "";
_wepPic = "";
_wepScope = 0;
_wepStrScope = "";
_wepKey = 0;
_wepAmmo = [];
_wepMuzzles = [];
_muzzleArray = [];
_ammoArray = [];
_wepTmpArray = ["",[],[]];	
_wep = _cfgweapons select _i;
		
	if (isClass _wep) then {
	_wepClass = configName(_wep);
	_wepName = getText(configFile >> "cfgWeapons" >> _wepClass >> "displayName");
	_wepMod = getText(configFile >> "cfgWeapons" >> _wepClass >> "model");
	_wepPic =  getText(configFile >> "cfgWeapons" >> _wepClass >> "picture");
	_wepScope = getNumber(configFile >> "cfgWeapons" >> _wepClass >> "scope");
	_wepStrScope = getText(configFile >> "cfgWeapons" >> _wepClass >> "scope");
	_wepKey =  getNumber(configFile >> "cfgWeapons" >> _wepClass >> "keyid");
	_wepAmmo = getArray (configFile >> "cfgWeapons" >> _wepClass >> "magazines");
	_wepMuzzles = getArray (configFile >> "cfgWeapons" >> _wepClass >> "muzzles");
	_pClass = inheritsFrom (configFile >> "cfgWeapons" >> _wepClass);
	_pClass = configName _pClass;
	
	//while{_pClass==""}do{sleep .2};//Double waitUntil efficiency / timing. Wait required ! Waiting for config to be read. To remove == To break.
	
	//diag_log format["AXELOG:BOX:_wepClass:%1 | _wepName:%2 | _wepMod:%3 | _wepAmmo:%8 | _wepMuzzles:%9 | _pClass:%10",_wepClass,_wepName,_wepMod,_wepPic,_wepScope,_wepStrScope,_wepKey,_wepAmmo,_wepMuzzles,_pClass];
	
		if ((_wepClass!="") && (_wepName!="") && (_wepMod!="") && (_wepPic!="") && ((_wepScope>1) || (_wepStrScope == "public")) && (_wepKey<1) && !(_wepClass in _wepFilter)) then {
		
		_wepTmpArray set [0,_wepClass];
		
		if(count _wepMuzzles >0)then{
			{
				if(_x !="this")then{[_muzzleArray, _x] call BIS_fnc_arrayPush;};	
			}forEach _wepMuzzles;
		};
		
		if(count _wepAmmo >0)then{
			{
				if(_x !="this")then{[_ammoArray, _x] call BIS_fnc_arrayPush;};	
			}forEach _wepAmmo;
		};
		
		_rndNum = floor(random 6);
		if(_rndNum<3)then{_rndNum=3;};
		
		_wepTmpArray set [1,[_muzzleArray,_rndNum]];
		_wepTmpArray set [2,[_ammoArray,_rndNum]];
		
		[_wepArray, _wepTmpArray] call BIS_fnc_arrayPush;
		
		//diag_log format["AXELOG:BOX:Single Weapon Array:%1",_wepTmpArray];
		};


	};

};
//diag_log format["AXELOG:BOX:Weapon Array:%1",_wepArray];

//Weapon Crates
for "_count" from 1 to 12 do{
//diag_log format["AXELOG:ATTEMPT BOX(%2):Weapon Array:%1",_wepArray,_count];
_wepSelect = [];

	while {count _wepSelect < (((count _wepArray)/3)*2)} do {
	[_wepSelect, _wepArray call BIS_fnc_selectRandom] call BIS_fnc_arrayPush;
	};
	
	
	_pos = [_centre,1,_rad,0.3,0,_elev,0] call BIS_fnc_findSafePos;
	if(count _pos <3)then{_pos set [2, 0];};
	_crate = createVehicle ["TKVehicleBox_EP1", _pos, [], 0, "CAN_COLLIDE"];
	_crate setDir floor(random 360);
	clearweaponcargoGlobal _crate;
	clearmagazinecargoGlobal _crate;
	
		{
		_rndMuzzle = "";
		_rndAmmo = "";
		
		//Add Weapon
		_crate addWeaponCargoGlobal [(_x select 0),1];
		//diag_log format["AXELOG:BOX Weapon Add:%1",_x];
		
		//Add Muzzle if any
			if(count (_x select 1 select 0) > 0)then{
			_rndMuzzle = (_x select 1 select 0) call BIS_fnc_selectRandom;
			_muzzleScope = getNumber(configFile >> "CfgMagazines" >> _rndMuzzle >> "scope");
				if(_muzzleScope>1)then{
				_crate addmagazineCargoGlobal [_rndMuzzle,(_x select 1 select 1)];
				//diag_log format["AXELOG:BOX Muzzle Add:%1",_rndMuzzle];
				};
			};
		//Add Ammo	
			if(count (_x select 2 select 0) > 0)then{
			_rndAmmo = (_x select 2 select 0) call BIS_fnc_selectRandom;
			_crate addmagazineCargoGlobal [_rndAmmo,(_x select 2 select 1)];
			//diag_log format["AXELOG:BOX Ammo Add:%1",_rndAmmo];
			};
		
		
		}forEach _wepSelect;
	//Weapons Done

	//Additional Items - Pick randomly from a percentage (_itemPcent) of the items from all populated (_vars) arrays.
	private["_magVars","_in","_tmp","_out","_path"];
	_vars = [["_magsItem","magazine"],["_magsMedix","magazine"],["_magsDrink","magazine"],["_magsFood","magazine"],["_magsClothes","magazine"],["_wepsItem","weapon"]];
	
	{
	call compile format["_in = %1",_x select 0];
	_out = [];
	_path = [];
	
		while {count _out < (((count _in)/100)*_itemPcent) || (count _in < 1)} do {
		_tmp = [];
		[_out, _in call BIS_fnc_selectRandom] call BIS_fnc_arrayPush;
			{
			_path = [_out, _x select 0] call AXE_fnc_findNestedElement;
			//diag_log format["AXELOG:BOX Tmp:%1 | _path:%2",_tmp,_path];
				if((count _path)==0)then{
				[_tmp, _x] call BIS_fnc_arrayPush;
				};
			}forEach _in;
		_in = _tmp;
		};
		
		if(_x select 1 == "magazine")then{
		{_crate addmagazineCargoGlobal [_x select 0,_x select 1];}forEach _out;
		};
		
		if(_x select 1 == "weapon")then{
		{_crate addWeaponCargoGlobal [_x select 0,_x select 1];}forEach _out;
		};
		
	//diag_log format["AXELOG:BOX Items %2 Added:%1",_out,_x select 0];
	}forEach _vars;
	
	//Add backpack and finish
	_crate addbackpackCargoGlobal [_backpacks call BIS_fnc_selectRandom,floor(random 10)];
	_crate setPos _pos;
	//diag_log format["AXELOG:BOX Added:%1",_crate];
	[DZE_DMCrates, _crate] call BIS_fnc_arrayPush;
};
