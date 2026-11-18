function [m_est, c_corr, synd] = decodeur_hamming(r)
% DECODEUR_HAMMING  Decodeur par syndrome, corrige 1 erreur
%   r      : N x 7 mots recus (bits 0/1)
%   m_est  : N x 4 messages estimes
%   c_corr : N x 7 mots corriges
%   synd   : N x 3 syndromes
P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];
H = [P' eye(3)];                     % matrice de controle
synd = mod(r*H', 2);                 % syndrome s = r*H^T
c_corr = r;
for i = 1:size(r,1)
    if any(synd(i,:))                % syndrome non nul : erreur detectee
        % l'erreur est a la position j dont la colonne de H = syndrome
        [~, j] = ismember(synd(i,:), H', 'rows');
        c_corr(i,j) = mod(c_corr(i,j) + 1, 2);   % on inverse ce bit
    end
end
m_est = c_corr(:, 1:4);              % code systematique : message en tete
end