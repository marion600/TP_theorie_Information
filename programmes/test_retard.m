% TEST_RETARD  Cherche le retard (en bits codes) qui realigne le decodeur
Parametres;  construire_chaine_cod;
Ac = A*sqrt(4/7);  seuil = 0;
EbN0 = 10^(3/10);  sigma2 = A^2*L/(2*EbN0);   % 3 dB : TEB attendu ~0,032
for d = 0:6
    set_param('chaine_cod/dly','NumDelays',num2str(d));
    out = sim('chaine_cod','StopTime','20000');
    b = double(out.bits_sim(:));  br = double(out.bits_rec(:));
    lags = 0:40;  n = min(numel(b),numel(br)) - 60;  e = zeros(size(lags));
    for i = 1:numel(lags), e(i) = mean(b(41:n) ~= br(41+lags(i):n+lags(i))); end
    [teb, il] = min(e);
    fprintf('retard = %d bits codes : TEB = %.4f (lag = %d)\n', d, teb, lags(il));
end