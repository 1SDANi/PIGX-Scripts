--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=57
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
		67270095,94664694,93542102,28002611,27762803,80555116,16940215,89333528,16828633,89211486,88494899,76650663,40155554,13761956,41978142,14983497,13821299,76614003,49003716,19252988,96008713,
		54161401,44811425,71315423,86198326,19230407,82828051,92890308,25173686,60306104,68540058,62867251,21597117,75498415,89493368,52286175,48381268,75775867,77036039,49826746,46239604,81278754,
		38981606,74976215,1474910,94303232,21702241,21702241,94681654,20686759,56074358,93469007,29863101,92346415,28741524,81524977,28529976,54913680,80402389,53291093,80280737,42079445,15552258,
		88341502,14730606,41234315,77229910,14613029,40012727,76407432,76384284,63948258
	}
	pack[2]={
		71438011,45033006,3648368,77372241,52222372,53944920,71218746,7700132,98045062,30683373,14943837,40348946,2009101,16898077,40048324,3431737,2619149,75937826,39703254,63253763,652362,67196946,
		17896384,89563150,3891471,2779999,39163598,36737092,27827272,88190790
	}
	pack[3]={
		81480460,8822710,41090784,15605085,69461394,33972299,6588580,70583986,33198837,92676637,66288028,29071332,92450185,55465441,41077745,14462257,65422840,65282484,38898779,1287123,31038159,73333463,
		3167573,64382839,87148330,35984222,50263751,37869028,56252810,55136228,42956963,88559132,2986553,88671720,75198893,1596508,32646477,31924889,16674846,64160836,564541,37953640,99342953,40703222,
		1764972,95526884,37169670,14553285,76214441,69031175,68319538,37675138,62379337,77336644,61257789,30915572,93709215,67300516,16191953,94878265,36623431,45041488,58820853,86223870
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
