%% TEST_CBS - Canal binaire symétrique : TEB simulé comparé à pe
Parametres;                                   % charge mes paramètres (p1, pe, graine...)
out = sim('chaine_cbs');                      % lance le modèle Simulink
b   = double(out.bits_sim(:));                % bits émis par la source
br  = double(out.bits_rec(:));                % bits reçus après le canal
N    = numel(b);                              % nombre de bits comparés
nerr = sum(b ~= br);                          % nombre d'erreurs : bits différents
teb  = nerr / N;                              % taux d'erreur binaire simulé
ic   = 1.96*sqrt(teb*(1-teb)/N);              % demi-largeur de l'IC à 95 %
fprintf('N = %d bits, %d erreurs\n', N, nerr);
fprintf('TEB simulé = %.4f (±%.4f), pe = %.3f\n', teb, ic, pe);
fprintf('pe dans l''intervalle de confiance : %d\n', abs(teb - pe) <= ic);