--The Divine Hourglass of Zorc
local s,id=GetID()
function s.initial_effect(c)
	--sum limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetCondition(aux.TRUE)
	c:RegisterEffect(e0)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(s.publicop)
	c:RegisterEffect(e1)
	--to fusion deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(s.hidecost)
	e2:SetTarget(s.hidetg)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
s.listed_names={id,1000008}
s.listed_series={0x302}
function s.hidecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local idct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_REMOVED,0,nil,id)
	local milct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x302)
	local revct = 1
	if idct==2 then revct=5
	elseif idct<=1 then revct=7 end
	if chk==0 then return milct>=revct and e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_EXTRA,0,revct,revct,nil,0x302)
	Duel.ConfirmCards(1-tp,g)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(1000008)
end
function s.retfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.hidetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	--Return
	local b1=Duel.IsExistingMatchingCard(s.retfilter,tp,0,LOCATION_MZONE,1,nil) and s.distg(e,tp,eg,ep,ev,re,r,rp,0)
	--End the Battle Phase
	local b2=Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and s.endtg(e,tp,eg,ep,ev,re,r,rp,0)
	--Floodgate
	local b3=s.fgtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,3))
		if op==1 then op=op+1 end
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+2
	end
	if op==0 then
		e:SetCategory(CATEGORY_DISABLE)
		e:SetOperation(s.disop)
		s.distg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==1 then
		e:SetOperation(s.endop)
		s.endtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		s.fgtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.fgop)
	end
end
function s.fgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.fgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function s.zorcfilter(c)
	return c:IsFaceup() and c:IsCode(1000008)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return Duel.IsExistingMatchingCard(s.zorcfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.retfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,s.retfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function s.endtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE end
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function s.milfilter(c)
	return c:IsSetCard(0x302) and (c:IsFaceup() or c:IsLocation(LOCATION_EXTRA))
end
function s.publicop(e,tp,eg,ev,ep,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.milfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,7,e:GetHandler()) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end