% TEST_DECODEUR_SL  Valide le decodeur Simulink (0 puis 1 erreur sur chaque bit)
construire_decodeur;
M = fliplr(dec2bin(0:15) - '0');           % 16 messages [m0 m1 m2 m3]
C = codeur_hamming(M);                     % mots-codes
R = C;                                     % cas sans erreur
for j = 1:7
    Rj = C;  Rj(:,j) = mod(Rj(:,j)+1, 2);  % une erreur sur le bit j
    R = [R; Rj]; %#ok<AGROW>
end
N = size(R,1);                             % 8*16 = 128 mots
rec_in = [(0:N-1)', R];                    % [temps, 7 colonnes]
set_param('hamming_dec_sl','StopTime',num2str(N-1));
res = sim('hamming_dec_sl');
Me = double(res.dec_out);
attendu = repmat(M, 8, 1);
ok = all(Me == attendu, 2);
fprintf('Sans erreur : %d/16 corrects\n', sum(ok(1:16)));
for j = 1:7
    fprintf('Erreur bit %d : %d/16 corriges\n', j, sum(ok(16*j+1:16*j+16)));
end