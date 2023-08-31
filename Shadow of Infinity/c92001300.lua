--古代の機械城
--Ancient Gear Castle
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(id)
	c:RegisterEffect(e2)
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCountLimit(1)
	e4:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,race=RACE_MACHINE})
	e4:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,race=RACE_MACHINE})
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		--summon proc
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,0))
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_PROC)
		ge1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge1:SetCondition(s.sumcon)
		ge1:SetTarget(aux.FieldSummonProcTg(aux.TargetBoolFunction(Card.IsSetCard,0x7),s.sumtg))
		ge1:SetOperation(s.sumop)
		ge1:SetValue(SUMMON_TYPE_TRIBUTE)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_series={0x7}
function s.castlefilter(c,tp,mi,ma)
	return c:IsHasEffect(id) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsReleasable()
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.IsExistingMatchingCard(s.castlefilter,c:GetControler(),LOCATION_SZONE,0,1,nil,c:GetControler(),mi,ma)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	local sg=Duel.SelectMatchingCard(tp,s.castlefilter,tp,LOCATION_SZONE,0,1,1,true,nil,tp,mi,ma)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	Duel.Release(sg,REASON_COST)
	sg:DeleteGroup()
end
