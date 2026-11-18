function [H, alph, p] = entropie(x)
% ENTROPIE  Entropie empirique d'une sequence de symboles (en bit/symbole).
%   [H, alph, p] = entropie(x) : x est un vecteur de symboles (caracteres, entiers...).
%   Sorties : alph = symboles distincts, p = leurs frequences, H = -somme(p.*log2(p)).
[alph,~,j] = unique(x(:));         % alph : symboles distincts ; j(i) = numero du symbole de x(i)
p = accumarray(j,1); p = p/sum(p); % nombre d'apparitions de chaque symbole, puis frequences (somme = 1)
H = -sum(p.*log2(p));              % formule de Shannon (tous les p sont > 0 : seuls les symboles presents)
end
