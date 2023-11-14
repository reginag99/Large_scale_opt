%t = 0;
nOfRelaxedConstraints = 2 * dimX * dimY;
u = zeros(1, nOfRelaxedConstraints);
theta = 2;
thetaCount = 0;
nrOfIterations = 1000;
gammaT = [];
k_erg = 2;

for iteration = 1:nrOfIterations
    [x, ht] = SolveLagrangeanSubProblem(u);
  
    hu = max(h,ht);%keep the best ht(u_t) aka upper boundery
    gammaT = CalculateSubGradientDirection(x, n, k);
    alpha = theta*(k-ht)/gammaT^2;

    x_erg(1) = x(1,:,:);
    x_erg(2) = x(2,:,:); %osäker på detta. står bara om x0 i funcktionen i pdfen men vi behöver ju x-erg(2) för beräkningarna
    for s = 0:iteration-1
        x_erg_u = x_erg_u + (s+1)^k;
        x_erg_l = x_erg_l + (s+1)^k;
        x_erg(1,iteration) = x_erg_u/x_erg_l*x_erg(1,iteration-1) + t^k/x_erg_l*x_erg(1,iteration-2);
    end
    %construct a feasable solution to the primal problem my making
    %adjustments to x_erg. skriva om lösningen för h i
    %SolveLagrangeSubProblem till en egen fil och applicera detta här
    %också??
    %calculate the objective function value. this is our lower boundery in
    %iteration t. update to the best lower bound and corresponding solution
    %vector
    %terminate if t = tao nrOfiterations eller om skillnaden mellan hu och
    %hl är inom en viss gräns
    %t = t + 1;%vet inte om detta verkligen behövs
        %theta är en step length parameter, inget mr speciellt
    if u == 0
        u = max(0,u+alpha*max(0,gammaT));
    elseif u > 0
        u = max(0,u+alpha*0,gammaT);
    end
    u = max(0,u+alpha*max(0,gammaT));


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
end

