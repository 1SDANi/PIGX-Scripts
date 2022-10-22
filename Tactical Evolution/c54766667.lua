--ホーリーフレーム
--Light Effigy
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(id)
	e0:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e0)
	--Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cs)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
function s.cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,e)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK))) and c:IsSummonable(true,e)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,e:GetLabelObject())
	end
end