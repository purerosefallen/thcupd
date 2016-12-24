--有时像虎有时似鸟的家伙✿封兽鵺
--script by Nanahira
function c26125.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26125)
	e1:SetTarget(c26125.sptg)
	e1:SetOperation(c26125.spop)
	c:RegisterEffect(e1)
		--search
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(26125,1))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BE_BATTLE_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c26125.target)
		e2:SetOperation(c26125.operation)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_BECOME_TARGET)
		e3:SetCondition(c26125.condition)
		c:RegisterEffect(e3)
end
function c26125.filter0(c,e,fc)
	if not fc.hana_mat then return false end
	if c:IsImmuneToEffect(e) then return false end
	local chk=false
	local ct=0
	for i,f in pairs(fc.hana_mat) do
		ct=ct+1
		if f(c) then chk=true end
	end
	return ct==2 and chk
end
function c26125.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c26125.filter2(c,e,tp,mg,f)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x208) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(c26125.filter0,1,nil,e,c)
end
function c26125.chain_mat_filter(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x208) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,e:GetHandler(),chkf)
end
--mg1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
function c26125.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,0x6,0,c)
		local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>(0)
			and Duel.IsExistingMatchingCard(c26125.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c26125.chain_mat_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26125.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c26125.filter1,tp,0x6,0,c,e)
	local sg1=Duel.GetMatchingGroup(c26125.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c26125.chain_mat_filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectMatchingCard(tp,c26125.filter0,tp,0x6,0,1,1,c,e,tc)
			mat1:AddCard(c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc:CompleteProcedure()
	end
end
function c26125.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetLocation()==LOCATION_MZONE
end
function c26125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26125.filter(c)
	return c:IsSetCard(0x251c) and c:IsAbleToHand()
end
function c26125.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26125.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
