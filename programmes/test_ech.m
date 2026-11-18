%% TEST_ECH - Sans intégrateur : un seul échantillon (au milieu) par bit (Q12)
Parametres;                                      % charge mes paramètres
seuil = 0;                                       % seuil nul
Q = @(x) 0.5*erfc(x/sqrt(2));                    % fonction Q
EbN0dB = 0:1:9;                                  % rapports Eb/N0 testés (dB)
N = 2e5;                                         % bits par point (le TEB est élevé, 2e5 suffisent)
teb = zeros(size(EbN0dB)); ic = teb;
for k = 1:numel(EbN0dB)
    EbN0   = 10^(EbN0dB(k)/10);                  % Eb/N0 en linéaire
    sigma2 = A^2 * L / (2*EbN0);                 % variance du bruit par échantillon
    out = sim('chaine_ech', 'StopTime', num2str(N));
    b  = double(out.bits_sim(:));                % bits émis
    br = double(out.bits_rec(:));                % bits décidés
    n  = min(numel(b), numel(br)-1);
    t0 = mean(b(1:n) ~= br(1:n));                % TEB sans décalage
    t1 = mean(b(1:n) ~= br(2:n+1));              % TEB avec décalage d'un bit
    teb(k) = min(t0, t1);                        % le bon alignement donne le plus petit TEB
    ic(k)  = 1.96*sqrt(teb(k)*(1-teb(k))/n);     % demi-largeur de l'IC à 95 %
end
fprintf('Eb/N0 (dB)    TEB sans intégrateur\n');
fprintf('%8d %18.4f\n', [EbN0dB; teb]);

d = load('teb_int.mat');                         % résultats avec intégrateur
tebth_int = Q(sqrt(2*10.^(EbN0dB/10)));          % théorie avec intégrateur : Q(sqrt(2 Eb/N0))
tebth_ech = Q(sqrt(2*10.^(EbN0dB/10)/L));        % théorie sans intégrateur : Q(sqrt(2 Eb/(N0 L)))
figure; semilogy(EbN0dB, tebth_int, 'b-', EbN0dB, tebth_ech, 'g-', 'LineWidth', 1.5); hold on; grid on;
errorbar(d.EbN0dB, d.teb, d.ic, 'bo', 'MarkerFaceColor', 'b');
errorbar(EbN0dB, teb, ic, 'ro', 'MarkerFaceColor', 'r');
xlabel('E_b/N_0 (dB)'); ylabel('TEB');
title('TEB avec et sans intégrateur');
legend('théorie avec intégrateur', 'théorie sans intégrateur', 'simulation avec intégrateur', 'simulation sans intégrateur', 'Location', 'southwest');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_teb_comparaison.png', 'Resolution', 200);