function [fx, feasible] = calculateFx(x, dimX, dimY, k, com)
    feasible = true;
    fx = 0;
    % X_matris och om konstraintsen håller (båda)
    
    %check if first constraint holds i.e Xjil = Xijl, each outgoing
    for contactPair = 1:k
        for i = 1:dimX*dimY*2
            [diff, outgoingSum] = checkNeighbours(i, contactPair, x, dimX, dimY);
            
            %checks that we are not in a start or terminal node, in which case we do not care that the sum is 0
            if ismember(i, com) == 0 % kollar så vi inte är i start eller terminal node
                if diff ~= 0
                    feasible = false;
                end
            end
            %checks second constraint, i.e will a node be passed at most
            %once
            if outgoingSum > 1
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
    