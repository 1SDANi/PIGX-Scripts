--クリアー・バイス・ドラゴン
--Clear Dragon
local s,id=GetID()
function s.initial_effect(c)
	--clear
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.desreptg)
	c:RegisterEffect(e4)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetValue(s.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_DEFENSE)
	e8:SetValue(s.atkval)
	c:RegisterEffect(e8)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if not g or #g<=1 then return 0 end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:GetFirst():GetAttack()*2
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsFaceup() and #g>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		return true
	else return false end
end