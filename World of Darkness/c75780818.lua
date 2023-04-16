-- ダイナ・タンク
-- Dyna Tank
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,71625222,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)