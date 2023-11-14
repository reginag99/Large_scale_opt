function [fx, feasible] = calculateFx(x, dimX, dimY, k, com)
    feasible = true;
    fx = 0;
    % TODO, skriv funktion som beräknar primal objektive värdet från en
    % X_matris och om konstraintsen håller (båda)
    
    %check if first constraint holds i.e Xjil = Xijl, each outgoing
    %connection corresponds to an incomming for each contact pair (TODO, add special thing for start and terminal)
    for contactPair = 1:k
        for i = 1:dimX*dimY*2
            outgoingSum = checkNeighbours(i, x, dimX, dimY);
            incomingSum = 0;
            incomingSum = incomingSum + x(i, i-1 , contactPair);
            incomingSum = incomingSum + x(i, i+1 , contactPair);
            if i <= dimX*dimY
                j = dimX*dimY+dimY*(modulogrej-1) + ceil(i/dimX); 
            else
                j = (modulogrej-1)*dimX+ceil((i-dimX*dimY)/dimY); 
            end
            incomingSum = incomingSum + x(i, j, l);
            % vad gör vi om vi är i start eller terminal node
            if ismember(i, com) == 0: %checks that we are not in a start or terminal node, in which case we do not care that the sum is 0
                if outgoingSum - incomingSum ~= 0
                    feasible = false;
                end
            end
        end
    end
    
    %check if second constraint holds, i.e will a node be passed at most
    %once
    for contactPair = 1:k
        for i = 1:dimX*dimY*2
            if checkNeighbours(i, x, dimX, dimY) > 1
                feasible = false;
            end
        end
    end
    
    % calculate functionValue
    for contactPair = 1:k
        s = com(contactPair, 1);
        t = com(contactPair, 2);
        fx = fx + x(s, t, contactPair);
    end
    