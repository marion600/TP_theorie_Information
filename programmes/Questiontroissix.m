% QUESTIONTROISSIX  Partie 2.2, questions 3 a 6 : entropie du texte, Huffman, cout de la table.
clear; close all; clc;

% Q3 : entropie du texte
t = fileread('nouveau_roman.txt','Encoding','UTF-8');   % texte (Stevenson, Le cas etrange du docteur Jekyll), UTF-8
t = strrep(t, char(13), '');             % on enleve les retours chariot (\r) de Windows
N = numel(t)                             % nombre de caracteres
[H0, alph, p] = entropie(t)              % entropie d'ordre 0, alphabet et frequences
M = numel(alph)                          % taille de l'alphabet
bits_fixe = ceil(log2(M))                % bits d'un code de longueur fixe
redondance = 1 - H0/8                    % redondance par rapport a 8 bits par caractere

[ps,i] = sort(p,'descend');              % frequences triees, de la plus grande a la plus petite
lab = cell(20,1);                        % etiquettes des 20 premiers caracteres
for k = 1:20
    c = alph(i(k));
    if c == ' ',          lab{k} = 'esp';                 % l'espace est ecrit "esp"
    elseif double(c) < 33 || double(c) == 160
        lab{k} = sprintf('#%d', double(c));               % caracteres de controle : on affiche leur code
    else
        lab{k} = c;
    end
end
figure; bar(ps(1:20));                   % diagramme des 20 frequences les plus elevees
set(gca,'XTick',1:20,'XTickLabel',lab);
title('20 caractères les plus fréquents'); ylabel('fréquence');
xlabel('caractère (esp = espace, #10 = saut de ligne)');   % ce que represente chaque barre
exportgraphics(gcf, 'fig_frequences.png', 'Resolution', 200);

% Q4 : validation de Huffman sur l'exemple de l'enonce
pt = [0.4 0.2 0.2 0.1 0.1];
c = huffman_code(pt);                    % mots de code
lt = cellfun(@numel,c);                  % longueurs des mots
Lbar_test = pt(:)'*lt(:)                 % longueur moyenne : doit valoir 2,2 bits
kraft = sum(2.^-lt(:))                   % somme de Kraft : doit valoir 1
pref = true;                             % le code est-il prefixe ?
for a=1:5, for d=1:5
    if a~=d && strncmp(c{a},c{d},lt(a)), pref = false; end   % c{a} debut de c{d} : pas prefixe
end, end
pref

% Q5 : Huffman sur le texte
[~,~,idx] = unique(t(:));                % numero de chaque caractere du texte
codes = huffman_code(p);                 % code de Huffman du texte
len = cellfun(@numel,codes);             % longueurs des mots
Lbar = p(:)'*len(:)                      % longueur moyenne
eff = H0/Lbar                            % efficacite H/Lbar
verif = (H0 <= Lbar) && (Lbar < H0+1)    % verification de H <= Lbar < H+1
s = [codes{idx(:)'}];                    % texte code : concatenation des mots
bits = (s=='1');                         % suite de bits (logiques)
y = huffman_dec(bits, codes);            % decodage
ok = isequal(y(:), idx(:))               % vrai si le texte est restitue sans erreur
taux = 8*N/numel(bits)                   % taux de compression par rapport a 8 bits/caractere

% Q6 : cout de la table de codage
Ct = sum(8 + ceil(log2(max(len)+1)) + len(:))   % par symbole : 8 bits (caractere) + longueur du mot + mot
Nmin = 100*Ct/Lbar                       % nombre de caracteres pour que la table coute moins de 1 % du message
