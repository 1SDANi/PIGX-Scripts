--クイズ
--Quiz
--This doesn't work for some reason
--Here's the text for if anyone ever figures this script out
--Banish all monsters in your GY facedown starting at the first monster in your GY; Your opponent calls the name of the first card found at the bottom of your GY. Return all but the first card banished to activate this effect to your GY, also, if they call it wrong, Special Summon the first card that was banished to activate this effect.
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and aux.SpElimFilter(c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local o=Group.CreateGroup()
	for tc in aux.Next(g) do
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 then
			o:AddCard(tc)
		end
	end
	o:KeepAlive()
	e:SetLabelObject(o)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,#e:GetLabelObject()-1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g==0 then return end
	local first=g:GetFirst()
	g:RemoveCard(first)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(1-tp,TYPE_MONSTER)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if ac~=first:GetCode() then
		Duel.SpecialSummon(first,0,tp,tp,false,false,POS_FACEUP)
	end
	e:GetLabelObject():DeleteGroup()
end