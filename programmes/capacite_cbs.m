%% CAPACITE_CBS - Capacité du canal binaire symétrique C(pe) = 1 - H(pe)
Parametres;                                       % charge mes paramètres
Hb = @(x) -x.*log2(x) - (1-x).*log2(1-x);         % entropie binaire (x entre 0 et 1, exclus)
C  = 1 - Hb(pe);                                  % capacité de MON canal (bit par utilisation)
R  = 4/7;                                         % rendement du code de Hamming (4 bits d'info pour 7 bits émis)
fprintf('C(pe) = %.4f, R = %.4f, R < C : %d\n', C, R, R < C);

x = linspace(1e-6, 0.5, 1000);                    % pe de 0 à 0,5
figure; plot(x, 1 - Hb(x), 'LineWidth', 1.5); hold on; grid on;
plot(pe, C, 'ro', 'MarkerFaceColor', 'r');        % mon canal
yline(R, '--k');                                  % rendement de Hamming
xlabel('p_e'); ylabel('C (bit/utilisation)');
title('Capacité du canal binaire symétrique');
legend('C(p_e)', 'mon canal', 'R = 4/7', 'Location', 'northeast');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_capacite.png', 'Resolution', 200);