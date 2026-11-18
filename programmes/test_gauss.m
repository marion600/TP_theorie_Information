%% TEST_GAUSS - Canal à bruit gaussien : TEB simulé selon le seuil (Q7 et Q8)
Parametres;                                          % charge mes paramètres (p1, A, sigma, graine...)
p0 = 1 - p1;                                         % probabilité d'émettre un 0
Q  = @(x) 0.5*erfc(x/sqrt(2));                       % fonction Q : queue de la loi normale centrée réduite
Pe = @(s) p0*Q((s + A)/sigma) + p1*Q((A - s)/sigma); % Pe(s) théorique (énoncé, question 7)
sopt = sigma^2/(2*A)*log(p0/p1);                     % seuil optimal théorique

seuils = sort([-1:0.25:1.5, sopt]);                  % seuils testés, dont le seuil optimal
teb = zeros(size(seuils));                           % TEB simulé pour chaque seuil
for k = 1:numel(seuils)
    seuil = seuils(k);                               % le modèle lit cette variable
    out = sim('chaine_gauss');                       % simulation du modèle Simulink
    b  = double(out.bits_sim(:));                    % bits émis
    br = double(out.bits_rec(:));                    % bits décidés
    teb(k) = mean(b ~= br);                          % taux d'erreur binaire simulé
end
N  = numel(b);                                       % nombre de bits par simulation
ic = 1.96*sqrt(teb.*(1-teb)/N);                      % demi-largeur de l'IC à 95 %

[tmin, i] = min(teb);                                % seuil qui minimise le TEB simulé
fprintf('Simulation : seuil optimal = %.3f, TEB = %.4f\n', seuils(i), tmin);
fprintf('Théorie    : seuil optimal = %.3f, Pe  = %.4f\n', sopt, Pe(sopt));
fprintf('Seuil 0    : TEB simulé %.4f, théorie %.4f, gain théorique %.4f\n', ...
        teb(seuils == 0), Pe(0), Pe(0) - Pe(sopt));

sf = linspace(min(seuils), max(seuils), 500);        % seuils fins pour la courbe théorique
figure; plot(sf, Pe(sf), 'b-', 'LineWidth', 1.5); hold on; grid on;
errorbar(seuils, teb, ic, 'ro', 'MarkerFaceColor', 'r');
xlabel('seuil s'); ylabel('taux d''erreur binaire');
title('Bruit gaussien : TEB simulé et théorique selon le seuil');
legend('théorie P_e(s)', 'simulation (IC 95 %)', 'Location', 'north');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_gauss_teb.png', 'Resolution', 200);