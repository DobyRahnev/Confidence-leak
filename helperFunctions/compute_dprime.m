function d_prime = compute_dprime(stim, resp)

% Assume symmetrical criteria for S1 and S2
hits = sum(stim==max(stim) & resp==max(stim));
misses = sum(stim==max(stim) & resp==min(stim));
fa = sum(stim==min(stim) & resp==max(stim));
cr = sum(stim==min(stim) & resp==min(stim));

% Correct for empty cells
if any([hits, misses, fa, cr] == 0)
    hits = hits + .5;
    misses = misses + .5;
    fa = fa + .5;
    cr = cr + .5;
end

% Compute hit and false alarm rate
HR = hits / (hits + misses);
FAR = fa / (fa + cr);

% Compute d'
d_prime = norminv(HR) - norminv(FAR);