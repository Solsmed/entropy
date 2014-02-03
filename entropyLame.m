function E = entropy(A)
    H = hist(A(:),numel(A));
    
    E = -nansum(H/numel(A) .* log(H/numel(A)));
end