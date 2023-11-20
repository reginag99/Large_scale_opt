nOfRelaxedConstraints = 2 * dimX * dimY;
u = zeros(1, nOfRelaxedConstraints) + 1/nOfRelaxedConstraints;
theta = 2;
thetaCount = 0;
nrOfIterations = 1000;
gammaT = [];
erg_sum = 1;
k_erg = 6;
h_bestUpperBound = Inf;
limit = round(k*0.1);
h_bestLowerBound = 0;
bestnl = [];
bestContactPairs = 0;

    
for iteration = 1:nrOfIterations
    [solution, contactPairs, nl, feasCom] = GetFeasiblesolution(dimX, dimY, u, k, com);
    [x, ht, newnl, okcom] = SolveLagrangeanSubProblem(dimX, dimY, u, k, com);
    if contactPairs > bestContactPairs
        bestnl = nl;
        bestContactPairs = contactPairs;
        bestcom = feasCom;
    end
    
    %[solutions, h_lower] = GetFeasiblesolution(dimX, dimY, k, com);
    %h_bestLowerBound = max(h_bestLowerBound, h_lower);
    
    h_bestUpperBound = min(h_bestUpperBound, ht); %keep the best ht(u_t) aka upper boundery
    gammaT = CalculateSubGradientDirection(x, k, dimX, dimY);
    %gammaT = norm(gammaT, 2);
    %[fx, feasible_fx] = calculateFx(x, dimX, dimY, k, com);
    alpha = theta*(ht - h_bestLowerBound)/norm(gammaT, 2)^2;
%     if iteration == 1
%        x_erg = x; 
%     else
%         erg_sum = erg_sum + iteration^k_erg;
%         x_erg = ((erg_sum - iteration^k_erg)/erg_sum) * x_erg + (iteration^k_erg/erg_sum) * x_previous;
%     end

    
    %construct a feasable solution to the primal problem my making
    %adjustments to x_erg. skriva om lösningen för h i
    %SolveLagrangeSubProblem till en egen fil och applicera detta här
    %också??
    %calculate the objective function value. this is our lower boundery in
    %iteration t. update to the best lower bound and corresponding solution
    %vector
    %terminate if t = tao nrOfiterations eller om skillnaden mellan hu och
    %fl är inom en viss gräns
    %t = t + 1;%vet inte om detta verkligen behövs
        %theta är en step length parameter, inget mr speciellt
    if u == 0
        u = max(0,u-alpha*max(0,gammaT));
    elseif u > 0
        u = max(0,u-alpha*gammaT);
    end
    %u = max(0,u+alpha*max(0,gammaT));


    %behöver vi även branshing? Jag är osäker? vet inte om detta endast är
    %nödvändigt på mer avancerade problem än detta men som jag förstår det
    %ska man gärna använda det för just salesman problems. om vi ska
    %använda detta är stegen förljande: 

    %vi har fått upper och lower bounds för ett specifikt u
    %kolla om denna kan tas bort ex för att den ej uppfyller något krav, är
    %inte feasable eller så
    %om möjligt uppdatera lower bound
    %välj en variabel vi ska bransha på baserat på x_erg. Denna är en
    %viktad x så gissar att man tar den med störst. ska kolla vidare
    %bransha på denna och forstätt med nästa iteration
    %terminate när alla interesant u har genererats och undersäkts
    if mod(iteration, 10) == 0
        theta = theta * 0.95;
    end
%     x_previous = x;
%     diff = h_bestUpperBound - h_bestLowerBound;
%     if diff < limit
%         break
%     end
%     
%     [x_rounded, feasible, nrContactPairs] = testX_erg(x_erg, dimX, dimY, k, com);
%     if feasible == 1 && nrContactPairs == k
%         disp("feasible solution found!!!")
%         break
%     end
       
    disp(iteration)
    
end
visagrid(dimX, dimY, bestnl, bestcom, u, 25);

