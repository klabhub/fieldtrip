function [v] = nanvar(x, normalizeflag, dim, flag)

% [V] = NANVAR(X, NORMALIZEFLAG, DIM, FLAG) computes the variance,
% across all cells in x along the dimension dim, accounting for NaNs. 
% Normalizeflag = 1 normalizes by N, normalizeflag = [] or 0 normalizes by N-1. 
% 
% X should be an linear cell-array of matrices for which the size in at 
% least one of the dimensions should be the same for all cells. If flag==1, the mean will
% be subtracted first (default behavior, but to save time on already demeaned data, it
% can be set to 0).

if nargin<2 || isempty(normalizeflag)
  normalizeflag = 0;
end

D = checkinput(x);
if nargin<3 || isempty(dim),
  dim = find(D,1,'last');
else
  % check whether the requested dim can be used
  if ~D(dim), error('data can not be concatenated across dimension %d',dim); end
end

if nargin<4,
  flag = 1;
end

if flag,
  m    = nanmean(x, dim);
  x    = cellvecadd(x, -m);
end

nx   = max(size(x));
nsmp = cellfun(@sum,        isfinite(x), repmat({dim},1,nx), 'UniformOutput', 0);
ssmp = cellfun(@nansumsq,   x,           repmat({dim},1,nx), 'UniformOutput', 0);

if normalizeflag
  N = sum(nsmp);
else
  N = sum(nsmp)-1;
end

v = sum(cell2mat(ssmp), dim)./N;  

function [s] = nansumsq(x, dim)

s = nansum(x.^2, dim);
