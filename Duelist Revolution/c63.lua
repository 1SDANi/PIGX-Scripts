--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=63
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
		61864793,34257001,60741115,96146814,23535429,22318971,58685438,94079037,83957459,83135907,18407024,45801022,81896771,17285476,44789585,53162898,89567993,75652080,74439492,
		52346240,88845345,49267971,49267971,1834107,37322745,36100154,9999961,36484016,62472614,34149830,60534585,97922283,96700602,22205600,59699355,95084054,58477767,20138923,
		84962466,28332833,54326448,91711547,93882364,30399511,3019642,24508238,4906301,57421866,58551308,93013676,22567609,37970940,78636495,11662742,26701483,37195861,87836938,
		13220032,51554871,15169262,89770167,53408006,54620698,27126980,91731841,69279219,81439173,1264319,47658964,59616123,73729209,37390589,37436476,62265044,99659159
	}
	pack[2]={
		69529567,96914272,95291684,57568840,20351153,19139516,55624610,82012319,15839054,41224658,74717840,712559,23327298,60312997,22082163,21350571,71209500,44792253,70187958,
		33970665,70781052,1995985,27004302,89893715,26381750,52786469,41431329,40619741,74657662,41777
	}
	pack[3]={
		98645731,7304544,7582066,35563539,47217354,45586855,21636650,13521194,87622767,98867329,61650133,83027236,45815891,21296383,20474741,56746202,15951532,40101111,1050684,
		48445393,63595262,35262428,57355219,79965360,6459419,32854013,32854013,97268402,20174189,77506119,13995824,49389523,76774528,2772236,84749824,56532632,37115575,27769400,
		14047624,13108445,12986807,48370501,76614340,49597193,75991898,75779210,75326861,72144675,96470883,10365322,43366227,36870345,876330,63487632,5237827,69243722,31632536,
		501000012,501000013
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
