--ヴァイロン・スティグマ
--Vylon Stigma
local s,id=GetID()
function s.initial_effect(c)
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(s.eqtg)
	e0:SetOperation(s.eqop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp)
	return c:IsFaceup() and c:GetEquipTarget() and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function s.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local eqc=g1:GetFirst()
	e:SetLabelObject(eqc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eqc:GetEquipTarget(),eqc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==eqc then tc=g:GetNext() end
	if not eqc:IsRelateToEffect(e) then return end
	Duel.Equip(tp,eqc,tc)
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end