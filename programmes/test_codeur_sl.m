construire_codeur;
M = fliplr(dec2bin(0:15) - '0');         % 16 messages [m0 m1 m2 m3]
flux = [];
for i = 1:16
    flux = [flux, fliplr(M(i,:)), 0 0 0]; %#ok<AGROW> % m3 m2 m1 m0 + 3 zeros
end
msg_in = [(0:numel(flux)-1)', flux'];    % [temps, valeur]
res = sim('hamming_enc_sl');
cw_out = res.cw_out;
CW = reshape(double(cw_out), 7, [])';
C = codeur_hamming(M);                         % [m0 m1 m2 m3 | r0 r1 r2]
attendu = [fliplr(C(:,1:4)), fliplr(C(:,5:7))]; % [m3 m2 m1 m0 | r2 r1 r0]
fprintf('Mots-codes identiques : %d/16\n', sum(all(CW == attendu, 2)));