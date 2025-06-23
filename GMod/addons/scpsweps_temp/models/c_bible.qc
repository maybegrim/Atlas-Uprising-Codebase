// Created by Crowbar 0.74

$modelname "weapons\c_bible.mdl"

$bodygroup "Base"
{
	studio "bible_reference.smd"
}
$bodygroup "Page_set"
{
	studio "Page_0.smd"
	studio "Page_10.smd"
	studio "Page_20.smd"
	studio "Page_30.smd"
	studio "Page_40.smd"
	studio "Page_50.smd"
	studio "Page_60.smd"
	studio "Page_70.smd"
	studio "Page_80.smd"
	studio "Page_90.smd"
	studio "Page_100.smd"
}
$bodygroup "Single_page"
{
	blank
	studio "Page_single.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 3.071 -2.698 -10.91

$cdmaterials "models\bible\"

$texturegroup "skinfamilies"
{
	{ "Bible"  "Pages"  }
	{ "Bible"  "Pages1" }
	{ "Bible"  "Pages2" }
	{ "Bible2" "Pages"  }
	{ "Bible2" "Pages1" }
	{ "Bible2" "Pages2" }
	{ "Bible3" "Pages"  }
	{ "Bible3" "Pages1" }
	{ "Bible3" "Pages2" }
}

$cbox 0 0 0 0 0 0

$bbox -19.249 -2.695 -25.946 24.646 8.836 4.127

$definebone "Book" "" -4.204282 -4.883745 0 0 0 0 0 0 0 0 0 0
$definebone "undercover_sides" "Book" 0.197818 6.602881 0 0 0 0 0 0 0 0 0 0
$definebone "Page_Base" "undercover_sides" 0 -0.579684 0 89.999982 -179.999978 0 0 0 0 0 0 0
$definebone "spine" "Book" 0 2.149185 0 0 0 0 0 0 0 0 0 0
$definebone "Cover_l" "spine" 0.665109 -0.855865 1.221643 89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "Cover_r" "spine" 0.665109 -0.855865 -1.221643 89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "page_root_r" "Page_Base" 0.553579 1.139453 -0.057442 0 -89.999982 0 0 0 0 0 0 0
$definebone "page_1_r" "Page_Base" 0.553579 1.139453 -0.057442 0 89.999982 -89.999982 0 0 0 0 0 0
$definebone "page_2_r" "page_1_r" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_3_r" "page_2_r" 0 1.53632 0 0 0 0 0 0 0 0 0 0
$definebone "page_4_r" "page_3_r" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_5_r" "page_4_r" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_end_down_r" "page_5_r" 0 1.536321 0 0 0 -89.999982 0 0 0 0 0 0
$definebone "page_end_up1_r" "page_5_r" 0 1.536321 0 0 0 89.999982 0 0 0 0 0 0
$definebone "page_end_up2_r" "page_end_up1_r" 0 0.789145 0 0 0 0 0 0 0 0 0 0
$definebone "page_root_up1_r" "Page_Base" 0.553579 1.139453 -0.057442 -0.000057 89.999982 0 0 0 0 0 0 0
$definebone "page_root_up2_r" "page_root_up1_r" 0 0.793782 0 0 0 0 0 0 0 0 0 0
$definebone "page_root_l" "Page_Base" -0.553579 0.453134 -0.057442 89.999982 89.999982 0 0 0 0 0 0 0
$definebone "page_1_l" "Page_Base" -0.553579 0.453134 -0.057442 0 89.999982 -89.999982 0 0 0 0 0 0
$definebone "page_2_l" "page_1_l" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_3_l" "page_2_l" 0 1.53632 0 0 0 0 0 0 0 0 0 0
$definebone "page_4_l" "page_3_l" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_5_l" "page_4_l" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_end_down_l" "page_5_l" 0 1.536321 0 0 -89.999982 89.999982 0 0 0 0 0 0
$definebone "page_end_up1_l" "page_5_l" 0 1.536321 0 0 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "page_end_up2_l" "page_end_up1_l" 0 0.789145 0 0 0 0 0 0 0 0 0 0
$definebone "page_root_up1_l" "Page_Base" -0.553579 0.453134 -0.057442 -89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "page_root_up2_l" "page_root_up1_l" 0 0.793782 0 0 0 0 0 0 0 0 0 0
$definebone "page_1_single" "Page_Base" 0 2.174788 -0.057442 0 89.999982 -89.999982 0 0 0 0 0 0
$definebone "page_2_single" "page_1_single" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_3_single" "page_2_single" 0 1.53632 0 0 0 0 0 0 0 0 0 0
$definebone "page_4_single" "page_3_single" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "page_5_single" "page_4_single" 0 1.536321 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine4" "" 0.000006 0 0 -79.749938 -89.999921 -90.000037 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" -3.058432 1.808683 0.068119 -73.711859 168.619339 91.480473 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 6.028141 0.000009 0.000002 -62.778249 -86.455271 -30.764565 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 11.692571 0.000162 -0.000016 0.002008 -53.432546 -21.436462 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "ValveBiped.Bip01_L_Forearm" 11.481129 -0.000336 -0.000181 41.641785 -7.382497 -24.582691 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "ValveBiped.Bip01_L_Hand" 3.859702 -0.14243 -1.191978 9.41135 -94.496507 -30.583856 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "ValveBiped.Bip01_L_Finger4" 1.312564 -0.000013 0.000006 -5.462636 -16.144648 -0.849936 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "ValveBiped.Bip01_L_Finger41" 0.729367 -0.000006 0.000002 -0.000173 -13.99761 0.000109 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "ValveBiped.Bip01_L_Hand" 3.942328 0.046741 -0.431442 2.389176 -89.26185 -12.041748 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "ValveBiped.Bip01_L_Finger3" 1.539095 0.000001 -0.000008 0.000341 -14.197448 -0.000067 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "ValveBiped.Bip01_L_Finger31" 1.196324 -0.000006 0.000002 -0.000351 -24.683595 0.00005 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "ValveBiped.Bip01_L_Hand" 3.88369 -0.046796 0.431442 1.418243 -78.738954 -15.076823 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "ValveBiped.Bip01_L_Finger2" 1.719581 -0.000018 0.000013 1.212432 -34.637156 1.720932 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "ValveBiped.Bip01_L_Finger21" 1.209183 -0.000009 0.000002 0.177097 -12.398417 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "ValveBiped.Bip01_L_Hand" 3.859857 -0.137977 1.332466 -2.699952 -74.815454 14.283484 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "ValveBiped.Bip01_L_Finger1" 1.719433 -0.000003 -0.000002 0.489244 -38.056844 -8.028229 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "ValveBiped.Bip01_L_Finger11" 1.099673 -0.000005 0.000004 0.148679 -13.999213 0.000226 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "ValveBiped.Bip01_L_Hand" 0.806041 -0.348931 1.32126 -48.86708 -68.015024 -30.326323 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "ValveBiped.Bip01_L_Finger0" 1.789783 -0.000001 -0.000002 -11.062051 -5.510436 41.967845 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "ValveBiped.Bip01_L_Finger01" 1.207005 -0.000001 -0.000002 -1.487758 16.031414 4.610231 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Wrist" "ValveBiped.Bip01_L_Forearm" 11.481606 -0.000097 -0.000053 7.877306 4.458363 -21.449936 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" -3.469696 -11.807331 -1.937605 73.71203 168.618779 -95.596496 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 6.028137 -0.000001 0.000003 44.029746 -9.723666 73.611039 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 11.692555 0.000079 0.00001 0.000168 -82.868083 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 11.480528 -0.000667 0.000011 5.251899 29.985859 -6.647053 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "ValveBiped.Bip01_R_Hand" 3.859674 -0.132545 1.193111 -2.9426 -67.700917 23.339902 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "ValveBiped.Bip01_R_Finger4" 1.059319 0.061756 -0.034468 -16.800957 -48.720392 5.349601 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "ValveBiped.Bip01_R_Finger41" 0.330198 0.30176 -0.213039 -15.836434 -39.199214 10.239217 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "ValveBiped.Bip01_R_Hand" 3.942295 0.050345 0.431046 -2.020423 -64.785205 13.727848 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "ValveBiped.Bip01_R_Finger3" 1.469903 0.013885 -0.006892 -3.446171 -66.984232 3.269071 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "ValveBiped.Bip01_R_Finger31" 1.085624 0.010718 0.017137 -7.720259 -71.226107 1.304286 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "ValveBiped.Bip01_R_Hand" 3.88366 -0.050303 -0.43104 -3.327285 -49.137201 -3.659648 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "ValveBiped.Bip01_R_Finger2" 1.815597 -0.083281 0.013399 5.471466 -92.719934 2.447796 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "ValveBiped.Bip01_R_Finger21" 1.33923 -0.210807 -0.012325 -12.689581 -69.902273 -8.645254 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "ValveBiped.Bip01_R_Hand" 3.859831 -0.148918 -1.331281 9.096615 -10.668982 -30.819391 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "ValveBiped.Bip01_R_Finger1" 1.900043 -0.104125 0.000963 14.534844 -57.265337 10.501286 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "ValveBiped.Bip01_R_Finger11" 1.322332 -0.276415 -0.11883 5.638257 -96.742103 -67.374338 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "ValveBiped.Bip01_R_Hand" 0.806024 -0.359832 -1.318333 9.112836 -63.309365 30.850288 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "ValveBiped.Bip01_R_Finger0" 1.789784 -0.000004 -0.000005 25.823374 56.903761 68.27274 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "ValveBiped.Bip01_R_Finger01" 1.207001 0 -0.000005 7.680038 52.086896 -9.262607 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Wrist" "ValveBiped.Bip01_R_Forearm" 11.481467 -0.000118 0.00001 4.045082 3.453344 16.075479 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_L_Wrist"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_R_Wrist"


$sectionframes 30 90

$sequence "idle" {
	"c_bible_anims\idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 60
	loop
}

$sequence "draw" {
	"c_bible_anims\draw.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 77 "c_bible.book_open" }
	{ event 3113 1 "" }
	fadein 0.2
	fadeout 0.2
	fps 60
}

$sequence "page_forward" {
	"c_bible_anims\page_forward.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	{ event 5004 34 "c_bible.pick_page" }
	{ event 5004 53 "c_bible.pick_page_swing" }
	{ event AE_CL_ENABLE_BODYGROUP 1 "Single_page" }
	{ event 3112 1 "Single_page" }
	{ event AE_CL_DISABLE_BODYGROUP 80 "Single_page" }
	{ event 3111 80 "Single_page" }
	{ event 3113 80 "" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 60
}

$sequence "page_back" {
	"c_bible_anims\page_back.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	{ event 5004 35 "c_bible.pick_page" }
	{ event 5004 61 "c_bible.pick_page_swing" }
	{ event AE_CL_ENABLE_BODYGROUP 1 "Single_page" }
	{ event 3112 1 "Single_page" }
	{ event AE_CL_DISABLE_BODYGROUP 86 "Single_page" }
	{ event 3111 86 "Single_page" }
	{ event 3113 86 "" }
	fadein 0.2
	fadeout 0.2
	snap
	fps 60
}

$sequence "place_bookmark" {
	"c_bible_anims\place_bookmark.smd"
	activity "ACT_VM_RELOAD" 1
	fadein 0.2
	fadeout 0.2
	fps 60
}

$sequence "remove_bookmark" {
	"c_bible_anims\remove_bookmark.smd"
	activity "ACT_RELOAD_LOW" 1
	fadein 0.2
	fadeout 0.2
	fps 60
}

$sequence "holster" {
	"c_bible_anims\holster.smd"
	activity "ACT_VM_HOLSTER" 1
	{ event 5004 38 "c_bible.book_close" }
	fadein 0.2
	fadeout 0.2
	fps 60
}

$include "DefineBones.qci"
