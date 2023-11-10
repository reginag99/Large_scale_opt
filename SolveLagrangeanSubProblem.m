%% see Algorithm 1 in project description (The subgradient sceheme)
% 1) Initialize:  t = 0, u_0 = 0, theta_0 = 2
% 2) Solve lagrangean subproblem for u = u^t and calculate upper bound h(u^t)
% on the optimal value (h(u^t) as defined in equation (2b) )
% 3) Calculate a subgradient direction gamma^t, and the step length alpha_t
% 4) Calculate u^(t+1)
% 5) Update the value of theta_t (multiply by 0.95 every tenth iteration)
% 6) Untill termination criterion is fulfilled, let t = t + 1 and repeat
% from 2

%u = 0; % vector av längd n där n är antal noder = dimX*dimY*2

% this is step 2 from algorithm

function x = SolveLagrangeanSubProblem(dimX, dimY, u, k, com)    
    nrNodes = dimX*dimY*2;
    x = zeros(nrNodes, nrNodes, k); % contains a 1 for X_ijl if there exists a path from node i to j for link l
    nl = gsp(dimX, dimY, u, k, com); % contains optimized(minimized paths for all subproblems)
    last = 0;
    okcom = [];
    newnl = [];
    
    % iterate over each subsubproblem / individual problem / contact-pair,
    % save paths with cost < 1
    for i = 1:k
        first = last+1;
        slask = find(nl(last+1:length(nl))== com(i,1));
        last = slask(1) + first-1;
        if (sum(u(nl(first:last))) < 1)
            okcom = [okcom i]; % contains row numbers in com vector of the contact pairs with cost < 1
            newnl = [newnl; nl(first:last)]; % contains node numbers of all the nodes in these contact pairs, sequentially stored
        end
    end
    
    % get x from results
    j = 1;
    for i = 1:length(okcom)
        linkNr = okcom(i);
        linkStartNode = com(linkNr, 1);
        linkTerminalNode = com(linkNr, 2);
        while newnl(j) ~= linkStartNode
            fromNode = newnl(j + 1);
            toNode = newnl(j);
            x(fromNode, toNode, linkNr) = 1;
            j = j + 1;
        end
        
        % this adds a 'logical' link that a connection between and start
        % and terminal node has been made
        x(linkStartNode, linkTerminalNode, linkNr) = 1;
        j = j + 1; % this is to skip the start node
    end
    
    % whats missing is the connections that were never formed because the
    % cost was above 1. what do we do about these links who lack connection
    % now
end