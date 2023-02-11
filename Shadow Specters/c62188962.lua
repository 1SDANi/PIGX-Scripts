--ヴァンパイア帝国
--Vampire Kingdom
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:GetPreviousLocation()==LOCATION_DECK
end
function s.dfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsDestructable(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chck)
	local g=eg:Filter(s.cfilter,nil)
	local c1=eg:Filter(Card.IsControler,nil,tp)
	local c2=eg:Filter(Card.IsControler,nil,1-tp)
	if chkc then return true end
	if chk==0 then return g and #g>0 and ((c1>0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)) or (c2>0 and Duel.IsExistingTarget(aux.TRUE,1-tp,LOCATION_ONFIELD,0,1,nil))) end
	ft1=Duel.GetMatchingGroupCount(s.dfilter,tp,LOCATION_ONFIELD,0,nil,e)
	ft2=Duel.GetMatchingGroupCount(s.dfilter,1-tp,LOCATION_ONFIELD,0,nil,e)
	if ft1>c1 then ft1=c1 end
	if ft2>c2 then ft2=c2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,s.dfilter,tp,0,LOCATION_MZONE,ft1,ft1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(1-tp,s.dfilter,1-tp,0,LOCATION_MZONE,ft2,ft2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
