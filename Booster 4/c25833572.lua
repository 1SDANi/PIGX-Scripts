--ゲート・ガーディアン
--Gate Guardian
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e2=aux.AddNormalSetProcedure(c)
	--summon with continuous spells
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.AND(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS),aux.TargetBoolFunction(Card.IsType,TYPE_SPELL)))
	e0:SetValue(POS_FACEUP)
	c:RegisterEffect(e0)
	--place in Szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function s.filter1(c)
	return c:IsCode(98434877) and not c:IsForbidden()
end
function s.filter2(c)
	return c:IsCode(62340868) and not c:IsForbidden()
end
function s.filter3(c)
	return c:IsCode(25955164) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (
		Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil) or
		Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil) or 
		Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE,0,1,nil)) end
end
function s.atchk1(c,sg)
	return c:IsCode(98434877) and sg:FilterCount(Card.IsCode,c,62340868)==1 and  sg:FilterCount(Card.IsCode,c,25955164)==1
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(s.atchk1,1,nil,sg)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local lc = Duel.GetLocationCount(tp,LOCATION_SZONE)
	if lc<=0 then return end
	local rg1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil)
	local rg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_GRAVE,0,nil)
	local rg3=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_GRAVE,0,nil)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,3,s.rescon,1,tp,HINTMSG_TOFIELD,nil,nil,true)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
		end
	end
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return
	else 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS+TYPE_UNION)
		e:GetHandler():RegisterEffect(e1)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end