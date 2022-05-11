--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=50
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
		44430454,80825553,83604828,20003527,83982270,16197610,61538782,98049038,41470137,4253484,31247589,77642288,3030892,30525991,76520646,3918345,39303359,2196767,
		65685470,38468214,64463828,69270537,96765646,55375684,82760689,63741331,90135989,26120084,99013397,25407406,24285858,51670553,64163367,23282832,60306104,
		18158397,45653036,26956670,53341729,99735427,26834022,52228131,84613836,21007444,20985997,57384901,83778600,19763315
	}
	pack[2]={
		95943058,17810268,43318266,79703905,984114,79580323,5975022,78868776,66707058,91070115,58332301,90957527,94820406,19980975,52496105,98891840,84491298
	}
	pack[3]={
		29590752,60493189,3897065,27346636,64262809,91250514,27655513,54040221,90434926,28297833,38445524,81510157,67227834,42534368,17032740,58554959,57610714,
		56597272,42592719,27178262,90557975,57006589,65984457,28877100,38280762,22160245,21947653,92373006,26533075,13893596,71564252,7200041,61802346,33695750,
		79229522,6614221,42009836,73333463,33655493,31034919,77538567,4923662,30312361,86676862,13293158,50282757,50304345,87798440,12071500,11136371,12958919,
		47408488,10004783,75732622,48343627,47121070,74519184,88264978,14258627,41753322,87148330,7736719,14536035
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
				for i=1,12 do
					local packnum=1
					for i=1,5 do
						local rarity
						if i==4 then
							rarity=2
						elseif i<5 then
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
				local exclude=fg:Select(p,0,#fg-30-#extra,nil)
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
