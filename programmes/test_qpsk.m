% TEST_QPSK  Validation, constellations, TEB Gray / naturel
Parametres;
Q = @(x) 0.5*erfc(x/sqrt(2));
lags = 0:20;

% --- Q2 : validation sans bruit (Gray) ---
construire_chaine_qpsk('gray');
sig2 = 0;
out = sim('chaine_qpsk','StopTime','2000');
b = double(out.bits_sim(:));  br = double(out.bits_rec(:));
[e0, il] = min(arrayfun(@(d) mean(b(21:1500) ~= br(21+d:1500+d)), lags));
fprintf('Sans bruit : TEB = %g (retard %d bits)\n', e0, lags(il)-1);

% --- Q3 : constellations (Gray) a 0, 5 et 10 dB ---
figure('Position',[100 100 1100 380]);
for i = 1:3
    valeurs = [0 5 10];
    EbN0dB = valeurs(i); 
    sig2 = 0.25/10^(EbN0dB/10);
    out = sim('chaine_qpsk','StopTime','6000');
    r = double(out.rx_sym(:));
    subplot(1,3,i); plot(real(r),imag(r),'.','MarkerSize',4); hold on
    plot(([1 -1 -1 1]+1j*[1 1 -1 -1])/sqrt(2),'r+','MarkerSize',12,'LineWidth',2);
    axis equal; grid on; xlim([-2 2]); ylim([-2 2]);
    xlabel('I'); ylabel('Q'); title(sprintf('E_b/N_0 = %d dB',EbN0dB));
    ax = gca; ax.Toolbar.Visible = 'off';
end
exportgraphics(gcf,'fig_constellations.png','Resolution',200);

% --- Q4, Q5 : TEB Gray et naturel ---
EbN0dB = 0:9;
teb = nan(2,numel(EbN0dB));
maps = {'gray','naturel'};
for m = 1:2
    construire_chaine_qpsk(maps{m});
    for k = 1:numel(EbN0dB)
        EbN0 = 10^(EbN0dB(k)/10);
        sig2 = 0.25/EbN0;
        N = round(min(2e6, max(2e4, 200/Q(sqrt(2*EbN0)))));
        out = sim('chaine_qpsk','StopTime',num2str(N));
        b = double(out.bits_sim(:));  br = double(out.bits_rec(:));
        n = min(numel(b),numel(br)) - 30;
        e = arrayfun(@(d) mean(b(21:n) ~= br(21+d:n+d)), lags);
        teb(m,k) = min(e);
    end
    fprintf('mapping %s termine\n', maps{m});
end
x = 0:0.05:9;  q = Q(sqrt(2*10.^(x/10)));
figure; semilogy(x,q,'b-', x,(3*q-2*q.^2)/2,'r-', EbN0dB,teb(1,:),'bo', EbN0dB,teb(2,:),'rs');
grid on;
xlabel('E_b/N_0 (dB)'); 
ylabel('TEB'); ylim([1e-6 1]);
title('QPSK : mapping de Gray et mapping naturel');
legend('theorie Gray = BPSK','theorie naturel','simulation Gray','simulation naturel','Location','southwest');
ax = gca;
ax.Toolbar.Visible = 'off';
exportgraphics(gcf,'fig_qpsk_teb.png','Resolution',200);
save('teb_qpsk.mat','EbN0dB','teb');
disp(table(EbN0dB', teb(1,:)', teb(2,:)', 'VariableNames', {'EbN0dB','TEB_Gray','TEB_naturel'}));