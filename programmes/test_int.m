%% TEST_INT - Chaîne avec intégrateur : TEB en fonction de Eb/N0 (Q10 à Q12)
Parametres;                                      % charge mes paramètres (A, L, graine...)
seuil = 0;                                       % seuil nul : bits équiprobables (énoncé)
Q = @(x) 0.5*erfc(x/sqrt(2));                    % fonction Q
EbN0dB = 0:1:9;                                  % rapports Eb/N0 testés (dB)
Nmax = 1e6;                                      % nombre maximal de bits simulés par point
teb = zeros(size(EbN0dB)); ic = teb; N = teb;
for k = 1:numel(EbN0dB)
    EbN0   = 10^(EbN0dB(k)/10);                  % Eb/N0 en linéaire
    sigma2 = A^2 * L / (2*EbN0);                 % variance du bruit par échantillon : N0 L/(2 Tb), avec Eb = A^2 Tb et Tb = 1
    N(k)   = round(min(Nmax, max(1e4, 300/Q(sqrt(2*EbN0)))));   % assez de bits pour environ 300 erreurs, plafonné
    out = sim('chaine_int', 'StopTime', num2str(N(k)));         % simulation sur N bits
    b  = double(out.bits_sim(:));                % bits émis
    br = double(out.bits_rec(:));                % bits décidés
    n  = min(numel(b), numel(br)-1);             % nombre de bits comparés
    teb(k) = mean(b(1:n) ~= br(2:n+1));          % décalage d'un bit : la décision k+1 correspond au bit k
    ic(k)  = 1.96*sqrt(teb(k)*(1-teb(k))/n);     % demi-largeur de l'IC à 95 %
end
tebth = Q(sqrt(2*10.^(EbN0dB/10)));              % TEB théorique Q(sqrt(2 Eb/N0))
fprintf('Eb/N0 (dB)    N bits    TEB simulé    TEB théorique\n');
fprintf('%8d %12d %12.2e %12.2e\n', [EbN0dB; N; teb; tebth]);
figure; semilogy(EbN0dB, tebth, 'b-', 'LineWidth', 1.5); hold on; grid on;
errorbar(EbN0dB, teb, ic, 'ro', 'MarkerFaceColor', 'r');
xlabel('E_b/N_0 (dB)'); ylabel('TEB');
title('Chaîne avec intégrateur : TEB simulé et théorique');
legend('Q(\surd(2E_b/N_0)) théorique', 'simulation (IC 95 %)', 'Location', 'southwest');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_teb_integrateur.png', 'Resolution', 200);
save('teb_int.mat', 'EbN0dB', 'teb', 'ic');          % pour comparer plus tard avec la version sans intégrateur