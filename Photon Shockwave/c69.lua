--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=69
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
		69380702,95788410,31173519,68167124,21051977,67445676,20838380,56223084,92595545,55488859,28877602,53540729,42328171,88205593,24694698,50088247,87483942,49144107,46083380,73178098,9576193,
		46961802,35848254,8632967,34026662,61011311,33782437,69176131,95561280,32065885,68054593,95448692,67232306,94626050,20721759,57115864,93504463,29999161,56993276,82382815,81443745,43114901,
		89609515,16693254,42082363,78486968,15871676,41269771,72429240,77542832,8814959,72142276,9236985,35631584,72029628,8414337,35419032
	}
	pack[2]={
		94656263,29116732,28990150,54266211,17045014,80538728,51701885,86361354,12533811,71233859,60398723,21843307,55271628,28654932,54059040,16480084,4545854,78364470,14759024,3536537,40921545,
		35209994,35209994
	}
	pack[3]={
		43096270,85138716,33904024,42874792,79279397,42752141,78156759,41930553,74530899,13478040,12755462,81665333,96383838,93830681,81873903,16923472,50866755,48928529,47805931,74416224,7405310,
		29876529,80495985,64734090,71341529,80651316,25716180,11411223,74294676,698785,72355441,9354555,15667446,43359262,93717133,55935416,54719828,80117527,18724123,81330115,17502671,6901008,32995007,
		54936498,17932494,40143123,71203602,8692301,47579719,359563,34086406,581014,73964868,36757171,83021423,56910167,29515122,82308875,57036718,83274244,82052602,18446701,29669359,55067058
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
