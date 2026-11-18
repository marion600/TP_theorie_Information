%% PARAMETRES - valeurs personnelles du TP, à lancer avant toute simulation
load('parametres.mat');          % P : mes valeurs, figées une fois pour toutes
p1     = P.p1;                   % probabilité d'émettre un 1
p1_ext = P.p1_ext;               % source très déséquilibrée (partie 2)
pe     = P.pe_cbs;               % probabilité d'erreur du canal binaire symétrique
A      = P.A;                    % amplitude : les bits sont émis à -A et +A
a      = P.a_unif;               % demi-largeur du bruit uniforme sur [-a, a]
sigma  = P.sigma;                % écart-type du bruit gaussien
L      = P.L;                    % nombre d'échantillons par bit
graine = round(P.graine);        % graine entière (évite l'avertissement de Simulink)