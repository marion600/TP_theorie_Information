function y = huffman_dec(bits, codes)
% HUFFMAN_DEC  Decodeur de Huffman (decodage instantane, le code est prefixe).
%   y = huffman_dec(bits, codes) : bits = suite de 0/1 recue, codes{i} = mot du symbole i
%   (chaine de '0' et '1', construite par huffman_code). y = numeros des symboles decodes.
D = containers.Map(codes, 1:numel(codes));       % dictionnaire : mot de code -> numero du symbole
y = zeros(1,numel(bits)); k = 0; cur = '';       % y : sortie (preallouee), k : nb de symboles, cur : mot en cours
for b = bits(:)'                                 % on lit les bits un par un
    cur(end+1) = char('0'+b);                    % on ajoute le bit au mot en cours ('0' ou '1')
    if isKey(D,cur), k = k+1; y(k) = D(cur); cur = '';   % mot complet reconnu : symbole decode, on repart de zero
    end                                          % (code prefixe : aucun mot n'est le debut d'un autre)
end
y = y(1:k);                                      % on enleve la partie inutilisee de y
end
