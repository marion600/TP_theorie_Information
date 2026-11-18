% TEST_HAMMING  Validation du codeur/decodeur Hamming(7,4)
P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];
G = [eye(4) P];  H = [P' eye(3)];
disp('G*H^T mod 2 (doit etre nul) :'); disp(mod(G*H', 2));

% les 16 messages possibles
M = dec2bin(0:15) - '0';  M = fliplr(M);     % lignes [m0 m1 m2 m3]
C = codeur_hamming(M);

% 1) sans erreur
[Me, ~, ~] = decodeur_hamming(C);
fprintf('Sans erreur   : %d/16 messages corrects\n', sum(all(Me==M,2)));

% 2) une erreur a chacune des 7 positions
for j = 1:7
    R = C;  R(:,j) = mod(R(:,j)+1, 2);
    [Me, ~, ~] = decodeur_hamming(R);
    fprintf('Erreur bit %d : %d/16 corriges\n', j, sum(all(Me==M,2)));
end

% 3) deux erreurs : le decodeur se trompe (pour illustrer d_min = 3)
R = C;  R(:,1) = mod(R(:,1)+1,2);  R(:,2) = mod(R(:,2)+1,2);
[Me, ~, ~] = decodeur_hamming(R);
fprintf('Deux erreurs : %d/16 messages corrects\n', sum(all(Me==M,2)));