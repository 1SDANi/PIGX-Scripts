--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=65
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
		27450400,53623827,89127526,52900379,88305978,88283496,40666140,76348260,48505422,74094021,33883834,1498130,70271583,6276588,69155991,32548609,55154048,91148083,81426505,16708652,80204957,1281505,
		15854426,41858121,17521642,53519297,89914395,16308000,42793609,89792713,88069166,77847678,14342283,76721030,3129635,49514333,63224564,43530283,94230224,97783659,57543573,84932271,2407147,
		38679204,37557626,36331074,62729173,99214782,55046718,92035412,28429121,55824220,81218874,27207573
	}
	pack[2]={
		53855409,80244114,16516630,41788781,14677495,13455953,2333365,2511717,32761286,5554990,31826057,28643791,54031490,27821104,88369727,80036543,15286412,41458579,98162021,60577362,76908448,38492752,
		75886890,74064212,168917,63942761,336369,35618486
	}
	pack[3]={
		30604579,67098114,93483212,42671151,61777313,51555725,97940434,23434538,86827882,23212990,45215453,67211766,94215860,54631834,40736921,25373678,16638212,15394083,77060848,40844552,49721904,
		68933343,94331452,29765339,53819808,89181369,27243130,10026986,41077745,75116619,29981921,66976526,92361635,14464864,24150026,50433147,10028593,37993923,598988,1710476,74509280,8310162,53063039,
		27564031,37474917,83991690,73778008,46384403,10389794,63468625,90953320,54977057,81066751,55794644,28573958,91188343,93353691,67904682,31919988,94515289,30757396,62007535,67985943,93379652,
		20374351,29552709,94092230,21496848,56768355,93157004
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
