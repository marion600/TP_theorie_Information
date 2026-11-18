function b = source(N, p1)
% SOURCE  Source binaire simple (sans memoire, stationnaire).
%   b = source(N, p1) renvoie un vecteur colonne de N bits independants,
%   avec P(1) = p1 et P(0) = 1 - p1.
%   Principe : rand(N,1) tire N nombres uniformes sur [0,1]. Le test "< p1" est
%   vrai avec la probabilite p1 : on obtient donc un 1 avec la probabilite p1.
 b = double(rand(N, 1) < p1);   % comparaison -> booleens, convertis en 0/1 (double)
end
