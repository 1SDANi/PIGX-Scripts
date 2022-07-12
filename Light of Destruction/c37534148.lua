--リボーンリボン
--Reborn Ribbon
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.cn)
	e3:SetTarget(s.tg)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_BATTLE+REASON_EFFECT) and ec:IsLocation(LOCATION_GRAVE)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:GetPreviousEquipTarget() and c:GetPreviousEquipTarget():IsCanBeSpecialSummoned(e,0,tp,false,false) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c:GetPreviousEquipTarget(),0,tp,tp,false,false,POS_FACEUP)
end