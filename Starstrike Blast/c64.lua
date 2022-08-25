--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=64
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
		18964575,45358284,71353388,17841097,44236692,70630741,43014054,32391566,79796561,31175914,78564023,3846170,66625883,92901944,24996659,61380658,97885363,96653775,23051413,59156966,85541675,
		22539270,84428023,11813722,57201737,84206435,10691144,46089249,83584898,19578592,18634367,71417170,43906884,70391588,6799227,33184236,5577649,32061744,68456353,67234805,45688586,85876417,
		22371016,67111213,93506862,92784374,29888389,65277087,91662792,28066831,54455435,27944249,54338958,26722601,85505315,46159582,19932396,82422049
	}
	pack[2]={
		79418153,5780210,4068622,31053337,30230789,39118197,65503206,23274061,96930127,50091196,22751868,58924378,82361206,82361206,45141013,7811875,94145021,93023479,66816282,92300891,59482302,
		88513608,52128900,15629801,41902352,39905966,90727556,53116300,22009013,83544697,46337945,18816758
	}
	pack[3]={
		67750322,20630765,67038874,29417188,68450517,94845226,34116027,66165755,22339232,18756904,5851097,30127518,31766317,6903857,93724592,60668166,59546528,58324930,85718645,71249758,44028461,
		79178930,31849106,4638410,66661678,21249921,7025445,67441435,21113684,58601383,97489701,23874409,50278554,96363153,29795530,24696097,45215453,68140974,4545683,31930787,67328336,68120130,
		72022087,19642774,45037489,18426196,23087070,52840598,26842483,14507213,89235196,80457744,14785765,87390067,72278479,40279770,123709,64734090,36227804,37349495,63612442,75673220,75673220,
		2067935,38562933,64550682,66399675,91449144,11877465,84766279,58494728,84488827,57272170,10755984
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
