function tmpSum = checkNeighbours(i, l, x, dimX, dimY)
    tmpSum = 0; % this is the sum of the neighbours
    if i <= dimX*dimY
        if mod(i,dimX) ~= 0
            tmpSum = tmpSum + x(i+1, i, l);
        end
        if mod(i,dimX) ~= 1
            tmpSum = tmpSum + x(i-1, i, l);
        end
        
        modulogrej = mod(i,dimX);
        if modulogrej == 0
            modulogrej = dimX;
        end
        j = dimX*dimY+dimY*(modulogrej-1) + ceil(i/dimX); 
        tmpSum = tmpSum + x(j, i, l);
    else
        if mod(i,dimY) ~= 0
            tmpSum = tmpSum + x(i+1, i, l); 
        end
        if mod(i,dimY) ~= 1
            tmpSum = tmpSum + x(i-1, i, l);
        end
        
        modulogrej = mod(i-dimX*dimY, dimY);
        if modulogrej == 0
            modulogrej = dimY;
        end
        j = (modulogrej-1)*dimX+ceil((i-dimX*dimY)/dimY); 
        tmpSum = tmpSum + x(j, i, l);
    end