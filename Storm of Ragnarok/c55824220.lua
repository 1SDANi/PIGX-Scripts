--輝石融合
--Pyroxene Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsRace,RACE_ELEMENTAL),Fusion.OnFieldMat)
end
