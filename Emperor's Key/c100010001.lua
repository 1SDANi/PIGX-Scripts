--ＮＯ１３ エーテリック・アメン
--New Orders 13: Etheric Mirage of Amun
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_XYZ)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--cannot negate summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.effcon)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
	--increase atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.attackup)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_COUNTER+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_COUNTER+CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.tg)
	e6:SetOperation(s.op)
	c:RegisterEffect(e6)
end
s.listed_names={45950291}
s.counter_place_list={COUNTER_XYZ}
function s.ft(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsType(TYPE_FUSION) and (not e or c:IsRelateToEffect(e))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.ft,nil,e,tp)
	if chk==0 then return g and #g>0 end
	local ct=0
	local dif=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		dif=tc:GetLevel()-e:GetHandler():GetLevel()
		if dif<0 then dif=-dif end
		ct=ct+dif
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.ft,nil,e,tp)
	if g and #g>0 then
		local ct=0
		local dif=0
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			dif=tc:GetLevel()-e:GetHandler():GetLevel()
			if dif<0 then dif=-dif end
			ct=ct+dif
		end
		if ct>0 then
			local num=Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
			if e:GetHandler() and e:GetHandler():IsRelateToEffect(e) and num>0 and e:GetHandler():IsCanAddCounter(COUNTER_XYZ,num) then
				e:GetHandler():AddCounter(COUNTER_XYZ,num)
			end
		end
	end
end
function s.filter(c,e)
	local ct=c:GetLevel()-e:GetHandler():GetLevel()
	if ct<0 then ct=-ct end
	return ct>0 and e:GetHandler():IsFaceup() and e:GetHandler():IsType(TYPE_FUSION) and e:GetHandler():IsCanAddCounter(COUNTER_XYZ,ct)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local ct=chkc:GetLevel()-e:GetHandler():GetLevel()
		if ct<0 then ct=-ct end
		return s.filter(chkc) and e:GetHandler():IsCanAddCounter(COUNTER_XYZ,ct) and chkc:IsControler(1-tp)
	end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
	local ct=g:GetFirst():GetLevel()-e:GetHandler():GetLevel()
	if ct<0 then ct=-ct end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:HasLevel() then
		local ct=tc:GetLevel()-e:GetHandler():GetLevel()
		if ct<0 then ct=-ct end
		local num=Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
		if e:GetHandler() and e:GetHandler():IsRelateToEffect(e) and num>0 and e:GetHandler():IsCanAddCounter(COUNTER_XYZ,num) then
			e:GetHandler():AddCounter(COUNTER_XYZ,num)
		end
	end
end
function s.attackup(e,c)
	return 100*c:GetCounter(COUNTER_XYZ)
end
function s.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end