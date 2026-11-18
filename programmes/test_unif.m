%% TEST_UNIF - Canal à bruit uniforme : TEB simulé pour une série de seuils (Q6)
Parametres;                                          % charge mes paramètres (p1, A, a, graine...)
p0 = 1 - p1;                                         % probabilité d'émettre un 0
cl = @(x) min(max(x, 0), 1);                         % ramène une probabilité dans [0, 1]
Pe = @(s) p0*cl((a - s - A)/(2*a)) + p1*cl((s - A + a)/(2*a));   % Pe(s) théorique (Q5)

seuils = sort([-1.5:0.25:2, a-A]);                   % seuils testés, dont le seuil optimal théorique
teb = zeros(size(seuils));                           % TEB simulé pour chaque seuil
for k = 1:numel(seuils)
    seuil = seuils(k);                               % le modèle lit cette variable
    out = sim('chaine_unif');                        % simulation du modèle Simulink
    b  = double(out.bits_sim(:));                    % bits émis
    br = double(out.bits_rec(:));                    % bits décidés par le récepteur
    teb(k) = mean(b ~= br);                          % taux d'erreur binaire simulé
end
N  = numel(b);                                       % nombre de bits par simulation
ic = 1.96*sqrt(teb.*(1-teb)/N);                      % demi-largeur de l'IC à 95 %

[tmin, i] = min(teb);                                % seuil qui minimise le TEB simulé
fprintf('Simulation : seuil optimal = %.3f, TEB = %.4f\n', seuils(i), tmin);
fprintf('Théorie    : seuil optimal = %.3f, Pe  = %.4f\n', a-A, Pe(a-A));
fprintf('TEB simulé pour seuil = 0 : %.4f (théorie %.4f)\n', teb(seuils == 0), Pe(0));

sf = linspace(min(seuils), max(seuils), 500);        % seuils fins pour la courbe théorique
figure; plot(sf, Pe(sf), 'b-', 'LineWidth', 1.5); hold on; grid on;
errorbar(seuils, teb, ic, 'ro', 'MarkerFaceColor', 'r');
xlabel('seuil s'); ylabel('taux d''erreur binaire');
title('Bruit uniforme : TEB simulé et théorique selon le seuil');
legend('théorie P_e(s)', 'simulation (IC 95 %)', 'Location', 'north');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_unif_teb.png', 'Resolution', 200);