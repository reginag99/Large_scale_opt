t = 0;
nOfRelaxedConstraints = 2 * dimX * dimY;
u = zeros(1, nOfRelaxedConstraints);
theta = 2;
thetaCount = 0;
nrOfIterations = 1000;
gammaT = [];

for iteration = 1:nrOfIterations
    [x, upperBound_h] = SolveLagrangeanSubProblem(u);%hallå gänget tänker att h borde vara antalet kontaktpar som har en lösning
    
    
    
    gammaT = CalculateSubGradientDirection();
    %ska vara theta*(hopt-h(u))/gammaT^2; tänker att hoptimal = k
    %ht är lösningen på lagrange, vilket jag tänker att vi får ut i task 2
    alpha = theta*(k-ht)/gammaT^2;
    %theta är en step length parameter, inget mr speciellt
<<<<<<< HEAD
    if u == 0
        u = max(0,u+alpha*max(0,gammaT));
    elseif u > 0
        u = max(0,u+alpha*0,gammaT);
    end
=======
    u = max(0,u+alpha*max(0,gammaT));
>>>>>>> ca6421c7d7907e120b2f277e85e7554833210015
    t = t + 1;
    if mod(iteration, 10) == 0
        theta = theta * 0.95;
    end
end

