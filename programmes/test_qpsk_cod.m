% TEST_QPSK_COD  QPSK Gray + Hamming(7,4) : recherche du retard puis TEB, compare a la partie 4
Parametres;
Q = @(x) 0.5*erfc(x/sqrt(2));
construire_chaine_qpsk_cod;
tebM = [0.11899 0.084779 0.054958 0.031826 0.015994 0.0067312 0.0023462 0.0005974 0.000114]; % partie 4 (Matlab)
lags = 0:60;

% --- 1) retard (en bits codes) qui realigne le decodeur, a 3 dB ---
sig2 = (7/16)/10^(3/10);
dd = 0:6;  e3 = zeros(size(dd));
for i = 1:numel(dd)
    set_param('chaine_qpsk_cod/dly','NumDelays',num2str(dd(i)));
    out = sim('chaine_qpsk_cod','StopTime','20000');
    b = double(out.bits_sim(:));  br = double(out.bits_rec(:));
    n = min(numel(b),numel(br)) - 80;
    e3(i) = min(arrayfun(@(d) mean(b(81:n) ~= br(81+d:n+d)), lags));
    fprintf('retard %d : TEB = %.4f\n', dd(i), e3(i));
end
[~, ib] = min(e3);  dbest = dd(ib);
set_param('chaine_qpsk_cod/dly','NumDelays',num2str(dbest));
fprintf('Retard retenu : %d bits codes\n', dbest);

% --- 2) balayage en Eb/N0 ---
EbN0dB = 0:8;  teb = nan(size(EbN0dB));
for k = 1:numel(EbN0dB)
    EbN0 = 10^(EbN0dB(k)/10);  sig2 = (7/16)/EbN0;
    N = round(min(5e5, max(2e5, 100/tebM(k))));
    out = sim('chaine_qpsk_cod','StopTime',num2str(N));
    b = double(out.bits_sim(:));  br = double(out.bits_rec(:));
    n = min(numel(b),numel(br)) - 80;
    teb(k) = min(arrayfun(@(d) mean(b(81:n) ~= br(81+d:n+d)), lags));
    fprintf('Eb/N0 = %d dB : TEB = %.4g (partie 4 : %.4g)\n', EbN0dB(k), teb(k), tebM(k));
end
save('teb_qpsk_cod.mat','EbN0dB','teb');

% --- figure ---
x = 0:0.05:9;
figure; semilogy(x,Q(sqrt(2*10.^(x/10))),'b-', EbN0dB,tebM,'rs', EbN0dB,teb,'g^');
grid on; ylim([1e-6 1]); xlabel('E_b/N_0 (dB)'); ylabel('TEB');
title('QPSK avec codage Hamming (7,4)');
legend('theorie sans codage','Hamming BPSK (partie 4, Matlab)','QPSK + Hamming (Simulink)','Location','southwest');
ax = gca; ax.Toolbar.Visible = 'off';
exportgraphics(gcf,'fig_qpsk_cod.png','Resolution',200);