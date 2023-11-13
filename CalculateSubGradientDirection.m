function gamma = CalculateSubGradientDirection(x, n, k,dimX,dimY)

gamma = ones(1, n);

for i = 1:n
    sum = 0;
    for l = 1:k
        if n <= dimX*dimY
            if mod(i,dimX) < dimX
                sum = sum + x(i+1,i,l);
            end
            if mod(i,dimX) > 1
                sum = sum + x(i-1,i,l);
            end
            j = dimX*dimY+dimY*(mod(i,dimX)-1) + ceil(1/dimX);
        else
            if mod(i,dimY) < dimY
                sum = sum + x(i+1, i, l);
            end
            if mod(i,dimY) > 1
                sum = sum + x(i-1,i,l);
            end
            j = (mod(j-dimX*dimY)-1)*dimX+ceil((j-dimX*dimY)/dimY);
        end
    end
    gamma(i) = gamma(i) - sum;
end
