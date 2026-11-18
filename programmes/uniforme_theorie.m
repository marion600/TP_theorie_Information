%% UNIFORME_THEORIE - Canal à bruit uniforme sur [-a, a] : densités, seuil optimal, Pe(s)
Parametres;                                          % charge mes paramètres (p1, A, a...)
p0 = 1 - p1;                                         % probabilité d'émettre un 0 (bit à -A)

% --- Question 4 : densités de r = x + n selon le bit émis ---
r  = linspace(-A-a-0.5, A+a+0.5, 2000);              % valeurs possibles de r
f0 = (abs(r + A) <= a) / (2*a);                      % f(r|0) : uniforme sur [-A-a, -A+a]
f1 = (abs(r - A) <= a) / (2*a);                      % f(r|1) : uniforme sur [A-a, A+a]
figure; plot(r, f0, 'b', r, f1, 'r--', 'LineWidth', 1.5); hold on; grid on;
xline(A-a, ':k'); xline(a-A, ':k');                  % bornes de la zone de recouvrement
xlabel('r'); ylabel('densité de probabilité');
title('Bruit uniforme : densités f(r|0) et f(r|1)');
ylim([0 0.45]);        
legend('f(r|0)', 'f(r|1)', 'zone de recouvrement', 'Location', 'north');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_unif_densites.png', 'Resolution', 200);

% --- Question 5 : probabilité d'erreur selon le seuil s (décision : 1 si r > s) ---
cl = @(x) min(max(x, 0), 1);                         % ramène une probabilité dans [0, 1]
Pe = @(s) p0*cl((a - s - A)/(2*a)) + p1*cl((s - A + a)/(2*a));   % p0 P(r>s|0) + p1 P(r<s|1)
s  = linspace(-A-a, A+a, 2000);                      % seuils testés
[Pmin, i] = min(Pe(s));                              % minimum numérique de Pe
fprintf('s optimal = %.3f (théorie a-A = %.3f), Pe min = %.4f, Pe(0) = %.4f\n', ...
        s(i), a-A, Pmin, Pe(0));
figure; plot(s, Pe(s), 'LineWidth', 1.5); hold on; grid on;
plot(s(i), Pmin, 'ro', 'MarkerFaceColor', 'r');
xlabel('seuil s'); ylabel('P_e(s)');
title('Bruit uniforme : probabilité d''erreur en fonction du seuil');
legend('P_e(s)', 'seuil optimal');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf, 'fig_unif_pe.png', 'Resolution', 200);