% TEST_COD  TEB de la chaine Simulink avec codage Hamming(7,4), compare a la simulation Matlab
Parametres;                                   % A, L, graine
construire_chaine_cod;
Ac = A*sqrt(4/7);  seuil = 0;
EbN0dB = 0:8;                           % rapports Eb/N0 testes (dB)
tebM   = [0.11899 0.084779 0.054958 0.031826 0.015994 0.0067312 0.0023462 0.0005974 0.000114]; % partie4_teb (0..8 dB)
teb = nan(size(EbN0dB));  retard = teb;  Nbits = teb;
Nmax = 5e5;                              % nombre maximal de bits par point (limite le temps de calcul)
for k = 1:numel(EbN0dB)
    EbN0   = 10^(EbN0dB(k)/10);
    sigma2 = A^2*L/(2*EbN0);
    ref    = tebM(EbN0dB(k)+1);                % TEB attendu (Matlab) pour dimensionner N
    N = round(min(Nmax, max(2e5, 100/ref)));   % ~100 erreurs attendues
    tic;  out = sim('chaine_cod','StopTime',num2str(N));  t = toc;
    b  = double(out.bits_sim(:));  br = double(out.bits_rec(:));
    % retard introduit par les Buffer : on garde celui qui minimise les erreurs
    lags = 0:40;  n = min(numel(b),numel(br)) - 60;  e = zeros(size(lags));
    for i = 1:numel(lags)
        e(i) = mean(b(41:n) ~= br(41+lags(i):n+lags(i)));
    end
    [teb(k), il] = min(e);  retard(k) = lags(il);  Nbits(k) = n-40;
    fprintf('Eb/N0 = %d dB : TEB = %.4g (Matlab : %.4g), retard = %d bits, N = %d, %.0f s\n', ...
        EbN0dB(k), teb(k), ref, retard(k), Nbits(k), t);
end
save('teb_cod.mat','EbN0dB','teb');            % pour la figure du rapport
disp(table(EbN0dB', teb', tebM(EbN0dB+1)', 'VariableNames', {'EbN0dB','TEB_Simulink','TEB_Matlab'}));