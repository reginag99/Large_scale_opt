function [solutions, nrContactPairs] = GetFeasiblesolution(dimX, dimY, k, com)
    linkCosts = zeros(dimX*dimY*2, 1);
    penalty = 100;
    %newSolutions = gsp(dimX, dimY, u, k, com);   
    %isDuplicates = length(newSolutions) ~= length(unique(newSolutions));
    solutions = [];
    solutions(1).path = {1,2,3};
    
    for contactPair = 1:k
        individualSolution = gsp(dimX, dimY, linkCosts, 1, com(contactPair, :));   % gives us index of passed nodes
        
        % check that we have not already passed the solution
        if linkCosts(individualSolution) == 0
            solutions(contactPair).path = individualSolution;
            linkCosts(individualSolution) = linkCosts(individualSolution) + penalty;  
        else
            % does it cross more than one path
            nrPathsCrossed = 0;
            pathIndex = 0;
            for previousSolutions = 1:length(solutions)
                if ~isempty(intersect(individualSolution, solutions(previousSolutions).path))
                    nrPathsCrossed = nrPathsCrossed +1;
                    oldPathIndex = previousSolutions;
                end
            end
            
            % compare length of paths with the path it crossed if it is 1
            if nrPathsCrossed == 1
                newPathLength = length(individualSolution);
                oldPathLength = length(solutions(oldPathIndex).path);
                % only add path if new one is better
                if newPathLength < oldPathLength
                    % remove penalty from old path nodes
                    linkCosts(solutions(oldPathIndex).path) = linkCosts(solutions(oldPathIndex).path) - penalty;
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
    
    %visagrid(dimX, dimY, nl, okcom, linkCosts, 25);
    %linkCosts(linkCosts >= 200)
    
    