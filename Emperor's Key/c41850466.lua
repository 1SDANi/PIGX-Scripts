--ヌメロン・カオス・リチューアル
--Numeron Chaos Ritual
local s,id=GetID()
function s.initial_effect(c)
	c:RegisterEffect(Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x14b),aux.FALSE,s.fextra,Fusion.ShuffleMaterial,nil,nil,nil,SUMMON_TYPE_FUSION,nil,nil,nil,nil,nil,nil,nil,nil,nil,89477759))
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
end