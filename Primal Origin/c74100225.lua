--進化の特異点
--Singularity of Evolution
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),Fusion.OnFieldMat)
end
