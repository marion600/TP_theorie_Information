%% PARTIE 2 - CODAGE DE SOURCE
% Objectif : etudier une source binaire, son entropie et son codage (questions 1 et 2).
clear; close all; clc;          % repartir d'un espace de travail propre

%% Parametres personnels
NOM = 'Yonkoua Nawel';
load('parametres.mat');         % structure P : mes valeurs personnelles, figees une fois pour toutes
p1  = P.p1;                     % probabilite d'emettre un 1
graine=P.graine
rng(graine);                    % graine fixee : tirages reproductibles
fprintf('p1 = %.2f\n', p1);     % affichage de controle
%% Verification de la frequence des 1
N  = 1e5;                          % nombre de bits tires
b  = source(N, p1);                % bits generes par la fonction source
f1 = mean(b);                      % frequence empirique des 1
ic = 1.96*sqrt(p1*(1-p1)/N);       % demi-largeur de l'IC a 95 %
fprintf('f1 = %.4f, p1 = %.2f, IC95%% = ±%.4f\n', f1, p1, ic);   % f1 doit etre a moins de ic de p1
%% Entropie de la source
p0 = 1 - p1;                       % probabilite d'emettre un 0
H1 = -p1*log2(p1) - p0*log2(p0);   % entropie H(p1) en bit/symbole
fprintf('H(p1) = %.4f bit/symbole\n', H1);
%% Courbe H(p)
p  = linspace(1e-6, 1-1e-6, 1000); % valeurs de p (on evite 0 et 1 : log2(0) n'existe pas)
Hp = -p.*log2(p) - (1-p).*log2(1-p);   % entropie binaire pour chaque p
figure;
plot(p, Hp, 'LineWidth', 1.5);     % courbe H(p)
hold on; grid on;
plot(p1, H1, 'ro', 'MarkerFaceColor', 'r');   % point correspondant a ma source
xlabel('p');
ylabel('H(p) (bit/symbole)');
title('Entropie d''une source binaire');
legend('H(p)', 'ma source (p_1)', 'Location', 'south');
ax = gca;                       % l'axe de la figure courante
ax.Toolbar.Visible = 'off';     % cache la barre d'outils pour qu'elle n'apparaisse pas sur l'image
exportgraphics(gcf, 'fig_entropie.png', 'Resolution', 200);   % figure pour le compte rendu
