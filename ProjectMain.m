t = 0;
nOfRelaxedConstraints = 2 * dimX * dimY;
u = zeros(1, nOfRelaxedConstraints);
theta = 2;
thetaCount = 0;
nrOfIterations = 1000;
gammaT = [];

for iteration = 1:nrOfIterations
    SolveLagrangeanSubProblem(u);
    gammaT = CalculateSubGradientDirection();
    u = 
    t = t + 1;
    if mod(iteration, 10) == 0
        theta = theta * 0.95;
    end
end

