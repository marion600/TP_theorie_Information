function codes = huffman_code(p)
% HUFFMAN_CODE  Construit le code de Huffman d'une source.
%   codes = huffman_code(p) : p est le vecteur des probabilités des symboles.
%   Rend codes{i} = le mot de code (une chaîne de '0' et '1') du symbole i.
%   Idée : on regroupe toujours les deux groupes les moins probables, jusqu'à
%   n'en avoir plus qu'un. Les symboles rares finissent avec des mots longs.

n = numel(p);                      % nombre de symboles
codes = repmat({''}, n, 1);        % au départ, tous les mots de code sont vides
groups = num2cell(1:n);            % au départ, chaque symbole est seul dans son groupe
w = p(:)';                         % poids (probabilité) de chaque groupe, en ligne

while numel(w) > 1                 % on répète tant qu'il reste plus d'un groupe
    [w,i] = sort(w);               % on classe les groupes du moins probable au plus probable
    groups = groups(i);            % on réordonne les groupes de la même façon

    for s = groups{1}, codes{s} = ['0' codes{s}];   % le groupe le moins probable : on ajoute un 0
    end                                              % devant le mot de chacun de ses symboles
    for s = groups{2}, codes{s} = ['1' codes{s}];   % le 2e moins probable : on ajoute un 1
    end

    groups = [{[groups{1} groups{2}]}, groups(3:end)];  % on fusionne ces deux groupes en un seul
    w = [w(1)+w(2), w(3:end)];                          % son poids est la somme des deux poids
end
end