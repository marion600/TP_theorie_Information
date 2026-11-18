function construire_chaine_qpsk(mapping)
% CONSTRUIRE_CHAINE_QPSK  Chaine QPSK en bande de base equivalente (niveau symbole)
%   mapping : 'gray' ou 'naturel'
mdl = 'chaine_qpsk';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl); open_system(mdl);
Pz = @(x,y) [x y x+70 y+40];

% --- source equiprobable + mise en paires (Buffer 2) ---
add_block('simulink/Sources/Random Number',[mdl '/rs'],'Position',Pz(20,40),'Mean','0','Variance','1','Seed','graine+1','SampleTime','1');
add_block('simulink/Logic and Bit Operations/Compare To Constant',[mdl '/cs'],'Position',Pz(120,40),'relop','>','const','0');
add_block('simulink/Sinks/To Workspace',[mdl '/bits_sim'],'Position',Pz(220,0),'VariableName','bits_sim','SaveFormat','Array','SampleTime','1');
add_block('simulink/Signal Attributes/Data Type Conversion',[mdl '/dc1'],'Position',Pz(220,70),'OutDataTypeStr','double');
add_block('dspbuff3/Buffer',[mdl '/buf2'],'Position',Pz(320,70),'N','2');

% --- modulation ---
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/mod'],'Position',Pz(420,70));
% --- canal : bruit complexe, variance sig2 sur chaque voie ---
add_block('simulink/Sources/Random Number',[mdl '/nI'],'Position',Pz(420,160),'Mean','0','Variance','sig2','Seed','graine+2','SampleTime','2');
add_block('simulink/Sources/Random Number',[mdl '/nQ'],'Position',Pz(420,220),'Mean','0','Variance','sig2','Seed','graine+3','SampleTime','2');
add_block('simulink/Math Operations/Real-Imag to Complex',[mdl '/ri2c'],'Position',Pz(520,190));
add_block('simulink/Math Operations/Add',[mdl '/add'],'Position',Pz(620,90));
add_block('simulink/Sinks/To Workspace',[mdl '/rx_sym'],'Position',Pz(720,150),'VariableName','rx_sym','SaveFormat','Array','SampleTime','2');
% --- demodulation ---
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/demod'],'Position',Pz(720,70));
add_block('dspbuff3/Unbuffer',[mdl '/unb'],'Position',Pz(820,70));
add_block('simulink/Sinks/To Workspace',[mdl '/bits_rec'],'Position',Pz(920,70),'VariableName','bits_rec','SaveFormat','Array','SampleTime','1');

% --- code des blocs mod / demod selon le mapping ---
if strcmp(mapping,'gray')
    mod_code = strjoin({'function s = qpsk_mod(b)','%#codegen','b = double(b(:));', ...
        's = ((1-2*b(1)) + 1j*(1-2*b(2)))/sqrt(2);','end'}, newline);
    dem_code = strjoin({'function b = qpsk_demod(r)','%#codegen', ...
        'b = [double(real(r) < 0); double(imag(r) < 0)];','end'}, newline);
else   % mapping naturel : 00,01,10,11 -> k = 1,3,5,7
    mod_code = strjoin({'function s = qpsk_mod(b)','%#codegen','b = double(b(:));', ...
        'k = 1 + 2*(2*b(1) + b(2));','s = exp(1j*pi/4*k);','end'}, newline);
    dem_code = strjoin({'function b = qpsk_demod(r)','%#codegen', ...
        'bi = double(real(r) < 0);','bq = double(imag(r) < 0);', ...
        'b = [bq; mod(bi + bq, 2)];','end'}, newline);
end
rt = sfroot;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/mod']);    ch.Script = mod_code;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/demod']);  ch.Script = dem_code;

l = @(a,b) add_line(mdl,a,b,'autorouting','on');
l('rs/1','cs/1'); l('cs/1','bits_sim/1'); l('cs/1','dc1/1'); l('dc1/1','buf2/1');
l('buf2/1','mod/1'); l('mod/1','add/1');
l('nI/1','ri2c/1'); l('nQ/1','ri2c/2'); l('ri2c/1','add/2');
l('add/1','rx_sym/1'); l('add/1','demod/1'); l('demod/1','unb/1'); l('unb/1','bits_rec/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1','SolverMode','SingleTasking','StopTime','1000');
save_system(mdl);
end