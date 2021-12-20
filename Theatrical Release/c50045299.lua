--ドラゴン族・封印の壺
--Dragon Capture Jar
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.banop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e3:SetLabelObject(ng)
end
function s.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Clear()
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAbleToRemove()
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
				e:GetLabelObject():AddCard(tc)
			end
		end
	end
end
function s.spfilter2(c,e,tp)
	return c:GetFlagEffect(id)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and c:GetOwner()==1-tp and c:IsLocation(LOCATION_REMOVED)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject():Filter(s.spfilter2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local rg=e:GetLabelObject()
	if ft2<=0 or #rg<=0 then return end
	local sg2=rg:Filter(s.spfilter2,nil,e,tp)
	local gc2=#sg2
	if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		sg=sg2:Select(1-tp,1,1,nil)
		if sg~=nil then
			Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
		end
		rg:Clear()
		return
	end
	if gc2>0 and ft2>0 then
		if #sg2>ft2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			sg2=sg2:Select(1-tp,ft2,ft2,nil)
		end
		for sc in aux.Next(sg2) do
			Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
	rg:Clear()
end
