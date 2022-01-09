--インフェルノクインデーモン
--Infernalqueen Archfiend
local s,id=GetID()
function s.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--disable and destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4)
	--selfdestroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.sdtg)
	e5:SetOperation(s.sdop)
	c:RegisterEffect(e5)
end
s.roll_dice=true
s.listed_names={35975813}
function s.sdfilter1(c)
	return c:IsCode(35975813) and c:IsFaceup()
end
function s.sdfilter2(c,e,tp)
	return c:IsCode(35975813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(s.sdfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)>0 and
		Duel.IsExistingMatchingCard(s.sdfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectMatchingCard(tp,s.sdfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(e:GetHandler()) or not Duel.IsChainDisablable(ev) then return false end
	local rc=re:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc~=2 and dc~=3 and dc~=4 and dc~=5 and dc~=6 then return end
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end