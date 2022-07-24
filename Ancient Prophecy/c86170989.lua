--ファルシオンβ
--Falchionβ
local s,id=GetID()
function s.initial_effect(c)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetBattleTarget():GetPreviousSequence()
	local seq1=seq+1
	local seq2=seq-1
	if seq1>4 then seq1=-1 end
	if seq2<0 then seq2=-1 end
	local g=Group.CreateGroup()
	if seq1>=0 then
		local c1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq1)
		if c1 then
			g:AddCard(c1)
		end
	end
	if seq2<=4 then
		local c2=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq2)
		if c2 then
			g:AddCard(c2)
		end
	end
	if chk==0 then return g and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetBattleTarget():GetPreviousSequence()
	local seq1=seq+1
	local seq2=seq-1
	if seq1>4 then seq1=-1 end
	if seq2<0 then seq2=-1 end
	local g=Group.CreateGroup()
	if seq1>=0 then
		local c1=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq1)
		if c1 then
			g:AddCard(c1)
		end
	end
	if seq2<=4 then
		local c2=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq2)
		if c2 then
			g:AddCard(c2)
		end
	end
	if g and #g>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end