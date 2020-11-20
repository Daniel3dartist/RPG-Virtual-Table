extends Control

# ===============================================[ Score Attributes var ]============================================================= #

# Inputs values
onready var STR_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/STR_Input'
onready var DEX_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/DEX_Input'
onready var CON_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CON_Input'
onready var INT_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/INT_Input'
onready var WIS_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/WIS_Input'
onready var CHA_Input = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Score_Column/CHA_Input'

# Mods Values
onready var STR_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/STR_Mod_Value'
onready var DEX_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/DEX_Mod_Value'
onready var CON_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/CON_Mod_Value'
onready var INT_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/INT_Mod_Value'
onready var WIS_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/WIS_Mod_Value'
onready var CHA_Mod_Value = $'ColorRect/SheetArea/Sheet_TabContainer/Core Stats/HBoxContainer/Score_&_Mod/HBoxContainer/Mod_Column/CHA_Mod_Value'

func _input(event):
	# STR
	var strDefault = int(STR_Input.text)
	var strCompareNum = 10	
	# DEX
	var dexDefault = int(DEX_Input.text)
	var dexCompareNum = 10
	# CON
	var conDefault = int(CON_Input.text)
	var conCompareNum = 10	
	# INT
	var intDefault = int(INT_Input.text)
	var intCompareNum = 10	
	# WIS
	var wisDefault = int(WIS_Input.text)
	var wisCompareNum = 10
	# CHA
	var chaDefault = int(CHA_Input.text)
	var chaCompareNum = 10

	# STR Mod Input
	if strDefault != strCompareNum:
		var strMod
		var num

		num = int(STR_Input.text)
		strMod = num
		strMod = str(strMod - 10)
		STR_Mod_Value.text = strMod
		strCompareNum = num

	# DEX Mod Input
	if dexDefault != dexCompareNum:
		var dexMod
		var num

		num = int(DEX_Input.text)
		dexMod = num
		dexMod = str(dexMod - 10)
		DEX_Mod_Value.text = dexMod
		dexCompareNum = num

	# CON Mod Input
	if conDefault != conCompareNum:
		var conMod
		var num

		num = int(CON_Input.text)
		conMod = num
		conMod = str(conMod - 10)
		CON_Mod_Value.text =conMod
		conCompareNum = num

	# INT Mod Input
	if intDefault != intCompareNum:
		var intMod
		var num

		num = int(INT_Input.text)
		intMod = num
		intMod = str(intMod - 10)
		INT_Mod_Value.text = intMod
		intCompareNum = num

	# WIS Mod Input
	if wisDefault != wisCompareNum:
		var wisMod
		var num

		num = int(WIS_Input.text)
		wisMod = num
		wisMod = str(wisMod - 10)
		WIS_Mod_Value.text =wisMod
		wisCompareNum = num

	# CHA Mod Input
	if chaDefault != chaCompareNum:
		var chaMod
		var num

		num = int(CHA_Input.text)
		chaMod = num
		chaMod = str(chaMod - 10)
		CHA_Mod_Value.text = chaMod
		chaCompareNum = num
