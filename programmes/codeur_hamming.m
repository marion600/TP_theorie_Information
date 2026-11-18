function c = codeur_hamming(m)
% CODEUR_HAMMING  Codeur Hamming (7,4) systematique, g(x)=1+x+x^3
%   m : matrice N x 4, une ligne = un message [m0 m1 m2 m3]
%   c : matrice N x 7, mots-codes [m0..m3 | r0 r1 r2]
P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];   % restes x^3*m(x) mod g(x)
G = [eye(4) P];                      % matrice generatrice systematique
c = mod(m*G, 2);                     % produit matriciel modulo 2
end