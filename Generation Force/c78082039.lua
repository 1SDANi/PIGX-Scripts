--クローザー・フォレスト
--Closed Forest
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.OR(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST),aux.TargetBoolFunction(Card.IsRace,RACE_AQUATIC)))
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		--Global effect since either player can use this effect
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.regfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and
		(c:IsPreviousLocation(LOCATION_MZONE) or (c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_MZONE)))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if eg and #eg==1 and s.regfilter(tc) then
		Duel.RaiseEvent(tc,EVENT_CUSTOM+id,re,r,rp,tc:GetOwner(),tc:GetLevel())
	end
end
function s.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_AQUATIC+RACE_BEAST) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=eg:IsExists(Card.IsControler,1,nil,tp) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(id+tp)==0
	local c2=eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsExistingMatchingCard(s.filter,1-tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,1-tp) and e:GetHandler():GetFlagEffect(id+1-tp)==0
	if chk==0 then return c1 or c2 end
	if c1 then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			e:SetLabel(tp)
			e:GetHandler():RegisterFlagEffect(id+tp,RESET_EVENT+RESETS_STANDARD,0,1)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_HAND)
		else
			e:SetLabel(-1)
		end
	else
		if Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
			e:SetLabel(1-tp)
			e:GetHandler():RegisterFlagEffect(id+1-tp,RESET_EVENT+RESETS_STANDARD,0,1)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_DECK+LOCATION_HAND)
		else
			e:SetLabel(-1)
		end
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if p==-1 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(p,s.filter,p,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,p)
	if #g>0 then
		Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsMonster,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end