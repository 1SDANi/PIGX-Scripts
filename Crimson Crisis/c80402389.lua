--大樹海
--Verdant Sanctuary
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search a Plant, Beast, or Insect monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_DELAY)
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
	return c:IsReason(REASON_DESTROY) and c:IsRace(RACE_PLANT+RACE_INSECT+RACE_BEAST) and c:HasLevel()
		and (c:IsPreviousLocation(LOCATION_MZONE) or (not c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return end
	local tc=eg:GetFirst()
	if not s.regfilter(tc) then return end
	Duel.RaiseEvent(tc,EVENT_CUSTOM+id,re,r,rp,tc:GetOwner(),tc:GetLevel())
end
function s.filter(c,lv)
	return c:GetLevel()<lv and c:IsRace(RACE_PLANT+RACE_INSECT+RACE_BEAST) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,eg:GetFirst():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,eg:GetFirst():GetLevel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
