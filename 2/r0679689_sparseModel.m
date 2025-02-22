function [X] = r0679689_sparseModel(Uk, sk, Vk, A)
% Calculates Uk * diag(sk) * Vk' while keeping the sparsity pattern of sparse matrix A
% size(Uk) = m x k,   size(sk) = k x 1,   size(Vk) = n x k
% memory constraint: O(C), C = amount of nonzeros in A
    
    % find at which positions A has values, then calculate output values only for those positions
    [i, j, v] = find(A); % O(C)
    for val = 1:length(i)
        v(val) = Uk(i(val), :) .* sk' * Vk(j(val), :)'; % O(k) for intermediary calculation, k < m,n < C
    end
    X = sparse(i, j, v, size(A, 1), size(A, 2)); % O(C)
end

%{
% FULL MATRIX VERSION
Xx = zeros(size(A, 1), size(A, 2));
tmp = Uk * diag(sk) * Vk';
Xx(I, J) = tmp(I, J);
%}
    
%{
% FIRST SPARSE MATRIX VERSION, "X2(I, J) =" takes too much memory at once
X2 = sparse(size(A, 1), size(A, 2));
X2(I, J) = Uk(I, :) * S * Vk(J, :)';
X2(A == 0) = 0;
%} 
    
%{
% SECOND SPARSE MATRIX VERSION
[~, S_rows] = size(Uk);
[~, S_cols] = size(Vk);
S = sparse(S_rows, S_cols);
for z = 1:length(sk)
    S(z, z) = sk(z);
end

[I, J] = find(A);
X = sparse([], [], [], size(A, 1), size(A, 2), length(I));

for z = 1:length(I)
    X(I(z), J(z)) = Uk(I(z), :) * S * Vk(J(z), :)';
end
%}
