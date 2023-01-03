--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=75
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
		83272895,45651298,82050203,18444902,45939611,71923655,44717069,70101178,7500772,43694481,70089580,6483224,32872833,79867938,5361647,32750341,68144350,4549095,4417407,30811116,93294869,93294869,
		39699564,28577986,28754338,54149433,50449881,11398059,57782164,72932673,72710085,71098407,44487250,70875955,33665663,32542011,68937720,43841694,70946699,17932494,91020571,27415516,53797637,
		89185742,30585393,93087299,67692580,30608985,54635862,28637168,92142169,29353756,65758454
	}
	pack[2]={
		19667590,18322364,67922702,66084673,92572371,65961085,27632240,90411554,26400609,53804307,89399912,51960178,23454876,86848580,23232295,85909450,10275411,6260554,12275533,2407234
	}
	pack[3]={
		53027855,22110647,46448938,44509898,7092142,76902476,49785720,71068247,25788011,52182715,18114794,5325424,31533704,91350799,59627393,19059929,19337371,45725480,79759367,6148016,44663232,
		7452945,78358521,4756629,54813225,66200210,90238142,15561463,85121942,47660516,83054225,13391185,75180828,26329679,88177324,68815132,66970002,92365601,51852507,200000000,55888045,11066358
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
