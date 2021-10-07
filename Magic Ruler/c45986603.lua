--強奪
--Snatch Steal
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,1,aux.CheckStealEquip,s.eqlimit,nil,s.target)
	--deckdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_CONTROL)
	e4:SetValue(s.ctval)
	c:RegisterEffect(e4)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function s.target(e,tp,eg,ep,ev,re,r,rp,tc)
	e:SetCategory(CATEGORY_CONTROL+CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.ctval(e,c)
	return e:GetHandlerPlayer()
end
