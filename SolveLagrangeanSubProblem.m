% outputs an x matrix of dimensions n*n*k  that contains a 1 for X_ijl if there exists a path from node i to j for contact-pair l
function [x, nrContactPairs] = SolveLagrangeanSubProblem(dimX, dimY, u, k, com)    
    n = dimX*dimY*2;
    nl = gsp(dimX, dimY, u, k, com); % contains optimized(minimized paths for all subproblems)
    last = 0;
    okcom = [];
    newnl = [];
    nrContactPairs = 0;
    
    % iterate over each subsubproblem / individual problem / contact-pair,
    % save paths with cost < 1
    for i = 1:k
        first = last+1;
        slask = find(nl(last+1:length(nl)) == com(i,1));
        last = slask(1) + first-1;
        if (sum(u(nl(first:last))) < 1)
            okcom = [okcom i]; % contains row numbers in com vector of the contact pairs with cost < 1
            newnl = [newnl; nl(first:last)]; % contains node numbers of all the nodes in these contact pairs, sequentially stored
        end
    end
    
    % create a large-ass x matrix from results (the links are bi-directional, should they be?)
    x = zeros(n, n, k); 
    j = 1;
    for i = 1:length(okcom)
        linkNr = okcom(i);
        linkStartNode = com(linkNr, 1);
        linkTerminalNode = com(linkNr, 2);
        while newnl(j) ~= linkStartNode
            fromNode = newnl(j + 1);
            toNode = newnl(j);
            x(fromNode, toNode, linkNr) = 1;
            x(toNode, fromNode, linkNr) = 1;
            j = j + 1;
        end
        
        % this adds a 'logical' link that a connection between and start
        % and terminal node has been made
        x(linkStartNode, linkTerminalNode, linkNr) = 1;
        x(linkTerminalNode, linkStartNode, linkNr) = 1;
        nrContactPairs = nrContactPairs + 1;
        j = j + 1; % this is to skip the start node so we dont connect two different contact pairs
    end
end