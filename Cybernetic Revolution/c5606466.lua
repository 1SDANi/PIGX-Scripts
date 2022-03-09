--異次元の落とし穴
--D.D. Pitfall
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_MSET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.filter(c,e,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:GetReasonPlayer()==tp and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function s.filter3(c,e,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsSummonPlayer(tp) and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local sg=eg:Filter(s.filter,nil,e,1-tp)
		return #sg==1
	end
	local sg1=eg:Filter(s.filter,nil,e,1-tp)
	e:SetLabelObject(sg1:GetFirst())
	Duel.SetChainLimit(s.chlimit)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg1,#sg1,0,0)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local sg=eg:Filter(s.filter3,nil,e,1-tp)
		return #sg==1
	end
	local sg1=eg:Filter(s.filter3,nil,e,1-tp)
	e:SetLabelObject(sg1:GetFirst())
	Duel.SetChainLimit(s.chlimit)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg1,#sg1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=eg:Filter(s.filter,nil,e,1-tp)
	if tc1 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=eg:Filter(s.filter3,nil,e,1-tp)
	if tc1 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
