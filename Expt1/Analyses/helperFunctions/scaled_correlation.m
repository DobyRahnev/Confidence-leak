function scaled_r = scaled_correlation(X, Y, s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%X and Y are input vectors
%s in the correlation window 
%
% Method developed by Nikolic et al. (2012) "Scaled correlation analysis: 
% a better way to compute a cross-correlogram". Code adapted from 
% https://en.wikipedia.org/wiki/Scaled_correlation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = floor(length(X)/s);

% segment the two data vectors
X = reshape(X, s, K);
Y = reshape(Y, s, K);

% demean
onesMat =  ones(s,K);
X       =  X - onesMat*diag(mean(X));
Y       =  Y - onesMat*diag(mean(Y));

% compute variances and co-variances for all segments
varX = mean(X .^ 2);
varY = mean(Y .^ 2);
cov  = mean(X .* Y);

% compute correlations coefficients for all segments
corrSegments = cov ./ sqrt(varX .* varY);

% remove not-a-number correlations
corrSegments(isnan(corrSegments)) = [];

% average all correlation coefficients to obtain scaled correlation
scaled_r = mean(corrSegments);