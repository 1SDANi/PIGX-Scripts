--王魂調和
--King's Consonance
local s,id=GetID()
function s.initial_effect(c)
	local params = {aux.FilterBoolFunction(Card.IsType,TYPE_FUSION),Fusion.OnFieldMat(Card.IsAbleToRemove),s.fextra,Fusion.BanishMaterial}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	end
	return nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Fusion.SummonEffTG(table.unpack(params))
	if chk==0 then return eg:GetFirst():IsControler(1-tp) and tg(e,tp,eg,ep,ev,re,r,rp,chk) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=Fusion.SummonEffOP(table.unpack(params))
	if Duel.NegateAttack() then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end