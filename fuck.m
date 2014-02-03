function [ab, mask] = fuck( a, b, targetEntropy )
    matSize = size(a);
    rawMask = rand(matSize);
    
    [H, K] = hist(rawMask(:),numel(a));
    [~, I] = min(abs(cumsum(H) - numel(a)/2));
    
    cut = K(I) + 1/(numel(a) * 2);
    
    mask = rawMask < cut;
    
    %{
    maskMatrix(:,:,1) = abs(entropyfilt(a,true(9)) - targetEntropy);
    maskMatrix(:,:,2) = abs(entropyfilt(b,true(9)) - targetEntropy);
    
    [~, I] = min(maskMatrix,[],3);
    eq = maskMatrix(:,:,1) == maskMatrix(:,:,2);
    I(eq) = 0;

    %mask(I == 1) = 1;
    %mask(I == 2) = 0;
    %}

    a(mask) = 0;
    b(~mask) = 0;
    
    ab = a + b;
    %}
end

