--Zig Zag Box
--死のマジック・ボックス
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,ft)
	if ft==0 then return c:GetSequence()<5 else return true end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,ft)
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g2,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_CONTROL)
	local dc=dg:GetFirst()
	local cc=cg:GetFirst()
	if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e) and Duel.Destroy(dc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.GetControl(cc,1-tp)
		--Cannot be tributed
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(3303)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		cc:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		cc:RegisterEffect(e4,true)
		--Cannot be used as fusion material
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(3309)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e5:SetRange(LOCATION_MZONE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		cc:RegisterEffect(e5,true)
	end
end
