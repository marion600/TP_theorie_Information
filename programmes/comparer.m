function r = comparer(t, nomfic)
% COMPARER  Compare, en bit/caractere, les codages possibles d'un texte t.
%   r.fixe : code de longueur fixe ; r.H0 : entropie d'ordre 0 ; r.huff : longueur moyenne de Huffman ;
%   r.H2 : H(X1X2)/2 (paires de caracteres consecutifs) ; r.gzip : taille du fichier gzip.
%   nomfic : fichier temporaire dans lequel on ecrit t pour le compresser avec gzip.
N = numel(t);                                      % nombre de caracteres
[H0,alph,p] = entropie(t);                         % entropie d'ordre 0 et frequences des caracteres
M = numel(alph);                                   % taille de l'alphabet
[~,~,idx] = unique(t(:));                          % numero (1..M) de chaque caractere
len = cellfun(@numel, huffman_code(p));            % longueurs des mots du code de Huffman
r.fixe = ceil(log2(M));                            % bits d'un code de longueur fixe
r.H0 = H0;                                         % entropie d'ordre 0
r.huff = p(:)'*len(:);                             % longueur moyenne de Huffman = somme p_i * l_i
pairs = (idx(1:end-1)-1)*M + idx(2:end);           % chaque paire (c_k, c_k+1) devient un seul entier
r.H2 = entropie(pairs)/2;                          % entropie des paires, ramenee a un caractere
fid = fopen(nomfic,'w','n','UTF-8'); fprintf(fid,'%s',t); fclose(fid);   % ecriture du texte dans le fichier
gzip(nomfic); d = dir([nomfic '.gz']);             % compression gzip puis lecture de la taille du .gz
r.gzip = 8*d.bytes/N;                              % bit par caractere apres gzip
end
