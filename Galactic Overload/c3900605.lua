--アブソーブポッド
--Absorbing Jar
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	local p=Duel.GetTurnPlayer()
	local g1=Duel.GetDecktopGroup(p,5)
	local g2=Duel.GetDecktopGroup(1-p,5)
	local spg=g1:Clone()
	spg:Merge(g2)
	local hg1=Group.CreateGroup()
	local hg2=Group.CreateGroup()
	local gg1=Group.CreateGroup()
	local gg2=Group.CreateGroup()
	Duel.ConfirmDecktop(p,5)
	local tc=g1:GetFirst()
	for tc in aux.Next(g1) do
		local lv=tc:GetLevel()
		local pos=0
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable() then pos=POS_FACEDOWN end
		if pos~=0 then
			Duel.SSet(tp,tc,tp,false)
		elseif tc:IsAbleToDeck() then
			hg1:AddCard(tc)
		else gg1:AddCard(tc) end
	end
	Duel.ConfirmDecktop(1-p,5)
	tc=g2:GetFirst()
	for tc in aux.Next(g2) do
		local lv=tc:GetLevel()
		local pos=0
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable() then pos=POS_FACEDOWN end
		if pos~=0 then
			Duel.SSet(tp,tc,tp,false)
		elseif tc:IsAbleToDeck() then
			hg2:AddCard(tc)
		else gg2:AddCard(tc) end
	end
	if #hg1>0 then
		Duel.SendtoDeck(hg1,nil,2,REASON_EFFECT)
	end
	if #hg2>0 then
		Duel.SendtoDeck(hg2,nil,2,REASON_EFFECT)
	end
	if #gg1>0 then
		Duel.SendtoDeck(gg1,nil,2,REASON_EFFECT)
	end
	if #gg2>0 then
		Duel.SendtoDeck(gg2,nil,2,REASON_EFFECT)
	end
	local fg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.ShuffleSetCard(fg)
end