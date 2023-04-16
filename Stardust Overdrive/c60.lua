--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=60
if self_code then id=self_code end
if not SealedDuel then
	SealedDuel={}
	local function finish_setup()
		--Pre-draw
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetCountLimit(1)
		e1:SetOperation(SealedDuel.op)
		Duel.RegisterEffect(e1,0)
	end
	--define pack
	--pack[1]=BP01, [2]=BP02, [3]=BPW2, [4]=BP03
	--[1]=common, [2]=rare, [3]=foil
	pack={}
	pack[1]={
		14943837,47432275,87102774,50287060,09411399,16226786,46668237,54578613,13361027,86840720,49633574,11012887,48411996,11390349,47795344,73783043,10178757,73061465,72845813,11722335,47111934,
		74157028,43434803,56747793,87910978,45809008,93217231,46502013,82732705,12607053,20932152,57421866,57421866,20210570,56209279,28966434,81759748,17243896,54248491,80637190,74576482,42303365,
		16909657,89810518,43426903,47459126,9848939,72631243,9126351,69408987,32391631,68786330,95784434,21179143,94068856,20457551,57441100,33846209,60234913,69112325,22991179,94484482,21879581,
		57274196,94662235,56051648,83546647,29934351,56339050,82324105,18712704,81601517,18096222,54094821,43262273
	}
	pack[2]={
		40044918,81962318,59755122,84905691,46572756,8233522,35638627,25366484,14087893,80604091,68543408,93816465,82693917,29088922,55586621,82971335,54360049,17021204,35514096,8903700,34358408,
		95507060,20057949,55117418,38815069,91798373,64187086,90576781,99261403,82878489
	}
	pack[3]={
		28183605,12235475,85028288,9056100,45450218,74506079,900787,47395382,73483491,9888196,61757117,11366199,75162696,14462257,65422840,59509952,34022290,97811903,33900648,71519605,22123627,68396778,
		81489939,39037517,21159309,94538053,10060427,46237548,60634565,96029574,96907086,68663748,96729612,17874674,2420921,37792478,27970830,79798060,15187079,41181774,73853830,7841112,65303664,
		65026212,33413279,33236860,95453143,47664723,46272804,15939448,43140791,16751086,79544790,63465535,22858242
	}
	for _,v in ipairs(pack[1]) do table.insert(pack[3],v) end
	for _,v in ipairs(pack[2]) do table.insert(pack[3],v) end
	function SealedDuel.op(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE)
		end
		local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_CARD,0,id)
		--tag variable defining
		local z,o=tp,1-tp
		if not aux.AskEveryone(aux.Stringid(id,1)) then
			return
		end
		
		local groups={}
		groups[0]={}
		groups[1]={}
		for i=1,counts[0] do
			groups[0][i]={}
		end
		for i=1,counts[1] do
			groups[1][i]={}
		end
		for p=z,o do
			for team=1,counts[p] do
				for i=1,15 do
					local packnum=1
					for i=1,6 do
						local rarity
						if i==4 or i==5 then
							rarity=2
						elseif i<6 then
							rarity=1
						else
							rarity=Duel.GetRandomNumber(1,3)
						end
						local code
						code=pack[rarity][Duel.GetRandomNumber(1,#pack[rarity])]
						table.insert(groups[p][team],code)
					end
				end
			end
		end
		
		for p=z,o do
			for team=1,counts[p] do
				Duel.SendtoDeck(Duel.GetFieldGroup(p,0xff,0),nil,-2,REASON_RULE)
				for idx,code in ipairs(groups[p][team]) do
					Debug.AddCard(code,p,p,LOCATION_DECK,1,POS_FACEDOWN_DEFENSE)
				end
				Debug.ReloadFieldEnd()
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,2))
				local fg=Duel.GetFieldGroup(p,0xff,0)
				local extra=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
				local exclude=fg:Select(p,#fg-60-#extra,#fg-60-#extra,nil)
				if exclude then
					Duel.SendtoDeck(exclude,nil,-2,REASON_RULE)
				end
				Duel.ShuffleDeck(p)
				Duel.ShuffleExtra(p)
				if counts[p]~=1 then
					Duel.TagSwap(p)
				end
			end
		end
	end
	finish_setup()
end
if not Duel.GetStartingHand then
	Duel.GetStartingHand=function() return 5 end
end
