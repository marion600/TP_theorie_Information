% TEST_SOURCE  Verifie la source Simulink : frequence des 1 comparee a p1 (intervalle de confiance a 95 %)
Parametres;                                  % charge mes parametres (p1, graine...)
out = sim('source_binaire');
b = double(out.bits_sim(:));
N = numel(b)
f1 = mean(b)
   p1
ic = 1.96*sqrt(p1*(1-p1)/N)
abs(f1 - p1) < ic