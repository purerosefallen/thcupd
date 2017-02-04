 
--夜雀之怪 米斯蒂娅·萝蕾拉
function c21066.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21066,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21066)
	e1:SetTarget(c21066.target)
	e1:SetOperation(c21066.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21066,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,210660)
	e2:SetCondition(c21066.sccon)
	e2:SetTarget(c21066.sctarg)
	e2:SetOperation(c21066.scop)
	c:RegisterEffect(e2)
end
function c21066.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c21066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c21066.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c21066.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c21066.filter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c21066.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c21066.syfilter(c,exc)
	return c:IsSynchroSummonable(exc) and c:IsSetCard(0x208)
end
function c21066.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21066.syfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21066.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
