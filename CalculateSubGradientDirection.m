function gamma = CalculateSubGradientDirection(x, n, k)

gamma = ones(1, n);

for i = 1:n
    sum = 0;
    for l = 1:k
        for j = 1:n
            sum = sum + x(j, i, l);
        end
    end
    gamma(i) = gamma - sum;
end
