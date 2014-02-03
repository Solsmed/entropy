numGenerations = 1000;
numOffspring = 2;
matSize = 30;
targetEntropy = 1;
histSize = 1000;

Adam = random('norm',0.5,0.2,matSize);%rand(matSize);
Eva = random('norm',0.5,0.2,matSize);%rand(matSize);

children = cell(numOffspring,1);
childEntropies = nan(numOffspring,1);

hist_Adam = cell(histSize, 1);
hist_Eva = cell(histSize, 1);
hist_a = cell(histSize, 1);
hist_b = cell(histSize, 1);
hist_amask = cell(histSize, 1);
hist_bmask = cell(histSize, 1);
hist_generation = cell(histSize, 1);

for generation = 1:numGenerations
    
    Eadam = abs(entropy(Adam) - targetEntropy);
    Eeva = abs(entropy(Eva) - targetEntropy);
    
    subplot(2, 2, 1)
    imshow(Adam)
    title(sprintf('%.3f',Eadam))
    subplot(2, 2, 2)
    imshow(Eva)
    title(sprintf('%.3f',Eeva))
    
    % Replicate and mutate
    for c = 1:numOffspring
        Ekainorabel = Inf;
        iter = 1;
        while Ekainorabel >= max(Eadam,Eeva)
            [KainOrAbel, mask] = fuck(Adam, Eva, targetEntropy);
            creativeness = (log10(iter)/6);
            KainOrAbel = KainOrAbel + (rand(matSize) > 0.5) .* creativeness * random('unif',0,1,matSize);
            KainOrAbel = mat2gray(KainOrAbel);
            Ekainorabel = abs(entropy(KainOrAbel) - targetEntropy);
            iter = iter + 1;
            
            creativeness
        end
        
        children{c} = KainOrAbel;
        subplot(2, numOffspring, numOffspring + c)
        imshow(KainOrAbel)
        childEntropies(c) = Ekainorabel;
        title(sprintf('%.3f',Ekainorabel))
        drawnow
    end
    
    %{
    histIndex = mod(generation, histSize);
    hist_Adam{} = cell(histSize, 1);
    hist_Eva = cell(histSize, 1);
    hist_a = cell(histSize, 1);
    hist_b = cell(histSize, 1);
    hist_amask = cell(histSize, 1);
    hist_bmask = cell(histSize, 1);
    hist_generation = cell(histSize, 1);
    %}
    
    %{
    fprintf('Dags för barnknull')
    pairwiseEntropies = nan(numOffspring, numOffspring);
    for a = 1:numOffspring
        for b = 1:numOffspring
            if (a == b)
                continue
            end
            
            if (a > b)
                continue
            end
            
            E = 0;
            for c = 1:numOffspring
                E = E + entropy(fuck(children{a}, children{b}, targetEntropy));
            end

            pairwiseEntropies(a,b) = E / numOffspring;
        end
    end
    %}
   
    [~, I] = sort(abs(childEntropies - targetEntropy));
    
    Eva = children{I(1)};
    Adam = children{I(2)};
    
   
    
    pause(0.6)
end

