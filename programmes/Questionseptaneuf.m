% QUESTIONSEPTANEUF  Partie 2.3 et 2.4, questions 7 a 9 : extension de la source, compresseurs, sortie de Huffman.
clear; close all; clc;
NOM = 'Yonkoua Nawel';
load('parametres.mat'); p1_ext = P.p1_ext; rng(P.graine);   % source tres desequilibree (parametres figes)
fprintf('p1_ext = %.2f\n', p1_ext);
H = @(p) -(p.*log2(p+(p==0)) + (1-p).*log2(1-p+(p==1)));   % entropie binaire (le terme (p==0) evite log2(0))

% Q7 : extension de la source (blocs de k bits)
bsrc = source(1e5, p1_ext);              % 1e5 bits de la source desequilibree
Lk = zeros(1,10); Lk_sim = zeros(1,10);  % longueurs moyennes par bit, theoriques et simulees
for k = 1:10
    id = (0:2^k-1)';                     % les 2^k blocs possibles (numerotes en entier)
    w = sum(dec2bin(id,k)-'0',2);        % nombre de 1 de chaque bloc
    pk = p1_ext.^w .* (1-p1_ext).^(k-w); % probabilite d'un bloc : p1^w (1-p1)^(k-w)
    ck = huffman_code(pk);               % code de Huffman de l'extension
    lk = cellfun(@numel,ck);             % longueurs des mots
    Lk(k) = (pk'*lk(:))/k;               % longueur moyenne par bit de source (theorie)
    nb = floor(1e5/k);                   % nombre de blocs complets dans la simulation
    B = reshape(bsrc(1:nb*k),k,[])';     % un bloc par ligne
    ib = B*2.^(k-1:-1:0)';               % numero (binaire -> entier) de chaque bloc
    Lk_sim(k) = sum(lk(ib+1))/(nb*k);    % longueur moyenne par bit mesuree sur la simulation
end
Hs = H(p1_ext); kk = 1:10;               % entropie de la source et valeurs de k
figure;
plot(kk,Lk,'o-',kk,Lk_sim,'x--',kk,Hs*ones(1,10),'-',kk,Hs+1./kk,':','LineWidth',1.3);
legend('L_k/k théorique','L_k/k simulé','H','H+1/k');
xlabel('k'); ylabel('bit par bit de source'); grid on;
title('Codage de Huffman de l''extension de la source');
exportgraphics(gcf, 'fig_extension.png', 'Resolution', 200);
disp([kk' Lk' Lk_sim']); Hs

% Q8 : memoire du texte et compresseurs
t = fileread('nouveau_roman.txt','Encoding','UTF-8');
t = strrep(t, char(13), '');
r1 = comparer(t, 'tmp_full.txt')        % texte complet : fixe, H0, Huffman, H(X1X2)/2, gzip
r2 = comparer(t(1:5000), 'tmp_5000.txt') % 5000 premiers caracteres

% Q9 : proprietes de la sortie du codeur de Huffman
[H0,~,p] = entropie(t);
[~,~,idx] = unique(t(:));
codes = huffman_code(p);
s = [codes{idx(:)'}];                    % sortie du codeur (chaine de '0' et '1')
bits = (s=='1');
prop1 = mean(bits)                       % proportion de 1 : proche de 0,5 si les bits sont equiprobables
H2b = entropie(2*bits(1:end-1)+bits(2:end))/2   % entropie par bit des paires de bits : proche de 1 si independants
