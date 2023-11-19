function [solutions, nrContactPairs] = GetFeasiblesolution(dimX, dimY, u, k, com)
    
    linkCosts = zeros(dimX*dimY*2, 1);
    penalty = inf;
    %newSolutions = gsp(dimX, dimY, u, k, com);   
    %isDuplicates = length(newSolutions) ~= length(unique(newSolutions));
    solutions = [];
    
    
    for cP = 1:k
        % set penalty on each startnode
        linkCosts(com(cP, 1)) = 1000;
        % set penalty on each terminalnode
        linkCosts(com(cP, 2)) = 1000;
    end
    
    
    for contactPair = 1:k
        individualSolution = gsp(dimX, dimY, linkCosts, 1, com(contactPair, :));   % gives us index of passed nodes
        
        % check that we have not already passed the solution
        if linkCosts(individualSolution(2:end-1)) == 0
            solutions(contactPair).path = individualSolution;
            linkCosts(individualSolution) = linkCosts(individualSolution) + penalty;  
        else
            % does it cross more than one path
            nrPathsCrossed = 0;
            pathIndex = 0;
            for previousSolutions = 1:length(solutions)
                if ~isempty(intersect(individualSolution, solutions(previousSolutions).path))
                    nrPathsCrossed = nrPathsCrossed + 1;
                    oldPathIndex = previousSolutions;
                end
            end
            
            % compare length of paths with the path it crossed if it is 1
            if nrPathsCrossed == 1
                newPathLength = length(individualSolution);
                oldPathLength = length(solutions(oldPathIndex).path);
                % only add path if new one is better
                
                %if newPathLength < oldPathLength
                if rand() < 0.5
                    % remove penalty from old path nodes
                    linkCosts(solutions(oldPathIndex).path(2:end-1)) = 0;
                    doubleUsedNode = intersect(solutions(oldPathIndex).path, individualSolution);
                    linkCosts(doubleUsedNode) = penalty;
                    
                    
                    solutions(oldPathIndex).path = NaN;
                    % add penalty to new path nodes
                    solutions(contactPair).path = individualSolution;
                    linkCosts(individualSolution) = linkCosts(individualSolution) + penalty;  
                else % set new path to 0
                    solutions(contactPair).path = NaN;
                end
            end
            
            
            
            if nrPathsCrossed > 1
                solutions(contactPair).path = NaN;
            end
        end   
    end
    
    nl = [];
    okcom = [];
    nrContactPairs = 0;
    for contactPair = 1:k
        if ~isnan(solutions(contactPair).path)
            nl = [nl; solutions(contactPair).path];
            okcom = [okcom; com(contactPair, :)];
            nrContactPairs = nrContactPairs + 1;
        end
    end
    
    visagrid(dimX, dimY, nl, okcom, linkCosts, 25);
    %linkCosts(linkCosts >= 200)
    
    