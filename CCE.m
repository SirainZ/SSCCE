function [label_out, label_all, sel, ncut_all, cnum] = CCE(X, sigma, kmin, interval, kmax, k)
    
    [num, d] = size(X);
    D = squareform(pdist(X))  ;
    W = exp(-(D / sigma).^2);
%     W = 1 - D;
    T = 1./sum(W);
    W = sqrt(T)' .* W .* sqrt(T);
    
    
    klist = kmin: interval: kmax;
    cnum = zeros([length(klist), 1]);
    cnum(1) = num;
    
    Wk = W ^ klist(1);
    Ws = W ^ interval;
    for i = 2:length(klist)
        Wk = Wk * Ws;
        [~, idx] = max(Wk, [], 1);
        c = find((1:num) == idx)';
        cnum(i) = length(c);
    end
    
    loc = find(cnum == k);
    l = length(loc);
    label_all = zeros(num, l);
    ncut_all = zeros(1, l);
    for i = 1:length(loc)
        Wk = W ^ klist(loc(i));
        [~, idx] = max(Wk, [], 1);
        c = find((1:num) == idx)';
        [~, label] = max(Wk(c, :), [], 1);
        label = label';
%         centers = c;

        ncut = Ncut(W, label);
        
        label_all(:, i) = label;
        ncut_all(i) = ncut;
    end
    
    [~, sel] = min(ncut_all);
    sel = sel(1);
    label_out = label_all(:, sel);
    
    
end