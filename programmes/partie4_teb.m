% PARTIE4_TEB  TEB sans codage / avec Hamming(7,4), a Eb fixe, comparaison a la theorie
Parametres;                                   % definit A (amplitude), graine...
rng(graine);
EbN0dB = 0:1:9;
Nb = 1e6;  nrep = 5;                          % 5 x 1e6 bits d'information par point
Q  = @(x) 0.5*erfc(x/sqrt(2));
Ac = A*sqrt(4/7);                             % amplitude d'un bit code (energie Eb conservee)
tebU = zeros(size(EbN0dB));  tebC = tebU;

% ---------------- simulation ----------------
for k = 1:numel(EbN0dB)
    EbN0 = 10^(EbN0dB(k)/10);
    sig  = A/sqrt(2*EbN0);                    % ecart-type du bruit apres integrateur
    eU = 0;  eC = 0;
    for r = 1:nrep
        b = double(rand(Nb,1) < 0.5);         % bits equiprobables
        % sans codage
        y  = A*(2*b-1) + sig*randn(Nb,1);
        eU = eU + sum((y > 0) ~= b);
        % avec codage
        M  = reshape(b,4,[])';                % blocs [m0 m1 m2 m3]
        C  = codeur_hamming(M);               % N/4 x 7
        y  = Ac*(2*C-1) + sig*randn(size(C));
        Mh = decode_vec(double(y > 0));
        eC = eC + sum(Mh(:) ~= M(:));
    end
    tebU(k) = eU/(nrep*Nb);   tebC(k) = eC/(nrep*Nb);
end

% ---------------- theorie ----------------
x  = -2:0.05:9;  X = 10.^(x/10);
pu = Q(sqrt(2*X));                            % sans codage
p  = Q(sqrt(2*(4/7)*X));                      % probabilite d'erreur d'un bit code

% (a) approximation de la question 8
pc_approx = zeros(size(p));
for j = 2:7
    pc_approx = pc_approx + (j/7)*nchoosek(7,j)*p.^j.*(1-p).^(7-j);
end

% (b) calcul exact : on enumere les 128 motifs d'erreur sur le mot nul
E  = dec2bin(0:127) - '0';                    % 128 x 7 motifs d'erreur
Mh = decode_vec(double(E));                   % message decode (mot nul envoye)
w  = sum(Mh,2);                               % nb de bits d'info faux pour chaque motif
we = sum(E,2);                                % poids du motif
pc = zeros(size(p));
for k = 1:128
    pc = pc + (w(k)/4) * p.^we(k) .* (1-p).^(7-we(k));
end

% ---------------- figure ----------------
figure;
semilogy(x,pu,'b-', x,pc,'r-', x,pc_approx,'r:', EbN0dB,tebU,'bo', EbN0dB,tebC,'rs');
hold on
xline(10*log10((2^(2*4/7)-1)/(2*4/7)),'k--','Shannon R=4/7 (0,24 dB)', ...
    'LabelHorizontalAlignment','right','LabelVerticalAlignment','bottom');
xline(10*log10(log(2)),'m--','limite absolue (-1,59 dB)', ...
    'LabelHorizontalAlignment','left','LabelVerticalAlignment','bottom');
grid on; xlim([-2 9]); ylim([1e-6 1]);
xlabel('E_b/N_0 (dB)'); ylabel('TEB');
title('Hamming (7,4) : TEB avec et sans codage');
if isfile('teb_cod.mat')
    s = load('teb_cod.mat');
    semilogy(s.EbN0dB, s.teb, 'g^', 'MarkerFaceColor', 'g');
end
legend('theorie sans codage','theorie avec codage (exacte)','theorie avec codage (approx. Q8)', ...
    'simulation sans codage','simulation avec codage (Matlab)', ...
    'simulation Simulink (chaine_cod)','Location','northeast');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf,'fig_teb_hamming.png','Resolution',200);

% ---------------- reponses Q11 ----------------
x0   = x(find(pc < pu, 1));
gain = interp1(log10(pu),x,-4) - interp1(log10(pc),x,-4);
fprintf('Le codage devient avantageux a partir de Eb/N0 = %.2f dB (theorie exacte)\n', x0);
fprintf('Gain de codage a TEB = 1e-4 : %.2f dB\n', gain);
disp(table(EbN0dB', tebU', tebC', 'VariableNames', {'EbN0dB','TEB_sans','TEB_avec'}));

% ---------------- fonction locale ----------------
function M = decode_vec(R)
% DECODE_VEC  Decodeur Hamming(7,4) vectorise (meme algo que decodeur_hamming)
P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];
H = [P' eye(3)];
S = mod(R*H', 2);                             % syndromes
idx = S*[1;2;4];                              % syndrome en entier 0..7
pos = zeros(7,1);
for j = 1:7, pos(H(:,j)'*[1;2;4]) = j; end    % position fautive de chaque syndrome
n = find(idx > 0);                            % mots avec erreur detectee
lin = sub2ind(size(R), n, pos(idx(n)));
R(lin) = 1 - R(lin);                          % on inverse le bit fautif
M = R(:,1:4);                                 % code systematique : message en tete
end