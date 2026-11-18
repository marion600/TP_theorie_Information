function construire_chaine_qpsk_cod()
% CONSTRUIRE_CHAINE_QPSK_COD  QPSK (Gray) + codage Hamming(7,4), niveau symbole
mdl = 'chaine_qpsk_cod';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl); open_system(mdl);
Pz = @(x,y) [x y x+70 y+40];
B  = 'dspbuff3/Buffer';  U = 'dspbuff3/Unbuffer';
add_block('simulink/Sources/Random Number',[mdl '/rs'],'Position',Pz(20,40),'Mean','0','Variance','1','Seed','graine+1','SampleTime','1');
add_block('simulink/Logic and Bit Operations/Compare To Constant',[mdl '/cs'],'Position',Pz(110,40),'relop','>','const','0');
add_block('simulink/Sinks/To Workspace',[mdl '/bits_sim'],'Position',Pz(200,0),'VariableName','bits_sim','SaveFormat','Array','SampleTime','1');
add_block('simulink/Signal Attributes/Data Type Conversion',[mdl '/dc1'],'Position',Pz(200,70),'OutDataTypeStr','double');
add_block(B,[mdl '/buf4'],'Position',Pz(290,70),'N','4');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/enc'],'Position',Pz(380,70));
add_block(U,[mdl '/unb1'],'Position',Pz(470,70));
add_block(B,[mdl '/buf2'],'Position',Pz(560,70),'N','2');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/mod'],'Position',Pz(650,70));
add_block('simulink/Sources/Random Number',[mdl '/nI'],'Position',Pz(650,160),'Mean','0','Variance','sig2','Seed','graine+2','SampleTime','8/7');
add_block('simulink/Sources/Random Number',[mdl '/nQ'],'Position',Pz(650,220),'Mean','0','Variance','sig2','Seed','graine+3','SampleTime','8/7');
add_block('simulink/Math Operations/Real-Imag to Complex',[mdl '/ri2c'],'Position',Pz(750,190));
add_block('simulink/Math Operations/Add',[mdl '/add'],'Position',Pz(850,90));
add_block('simulink/Sinks/To Workspace',[mdl '/rx_sym'],'Position',Pz(950,160),'VariableName','rx_sym','SaveFormat','Array','SampleTime','8/7');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/demod'],'Position',Pz(950,70));
add_block(U,[mdl '/unb2'],'Position',Pz(1050,70));
add_block('simulink/Discrete/Integer Delay',[mdl '/dly'],'Position',Pz(1140,70),'NumDelays','0');
add_block(B,[mdl '/buf7'],'Position',Pz(1230,70),'N','7');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/dec'],'Position',Pz(1320,70));
add_block(U,[mdl '/unb3'],'Position',Pz(1410,70));
add_block('simulink/Sinks/To Workspace',[mdl '/bits_rec'],'Position',Pz(1500,70),'VariableName','bits_rec','SaveFormat','Array','SampleTime','1');

enc_code = strjoin({'function c = enc(m)','%#codegen','P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];', ...
    'G = [eye(4) P];','c = mod(G''*double(m(:)), 2);','end'}, newline);
dec_code = strjoin({'function m = dec(r)','%#codegen','P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];', ...
    'H = [P'' eye(3)];','x = double(r(:));','s = mod(H*x, 2);','idx = s(1) + 2*s(2) + 4*s(3);', ...
    'pos = [5 6 1 7 4 2 3];','if idx > 0','    j = pos(idx);','    x(j) = 1 - x(j);','end', ...
    'm = x(1:4);','end'}, newline);
mod_code = strjoin({'function s = qpsk_mod(b)','%#codegen','b = double(b(:));', ...
    's = ((1-2*b(1)) + 1j*(1-2*b(2)))/sqrt(2);','end'}, newline);
dem_code = strjoin({'function b = qpsk_demod(r)','%#codegen', ...
    'b = [double(real(r) < 0); double(imag(r) < 0)];','end'}, newline);
rt = sfroot;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/enc']);    ch.Script = enc_code;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/dec']);    ch.Script = dec_code;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/mod']);    ch.Script = mod_code;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/demod']);  ch.Script = dem_code;

l = @(a,b) add_line(mdl,a,b,'autorouting','on');
l('rs/1','cs/1'); l('cs/1','bits_sim/1'); l('cs/1','dc1/1');
l('dc1/1','buf4/1'); l('buf4/1','enc/1'); l('enc/1','unb1/1');
l('unb1/1','buf2/1'); l('buf2/1','mod/1'); l('mod/1','add/1');
l('nI/1','ri2c/1'); l('nQ/1','ri2c/2'); l('ri2c/1','add/2');
l('add/1','rx_sym/1'); l('add/1','demod/1'); l('demod/1','unb2/1');
l('unb2/1','dly/1'); l('dly/1','buf7/1'); l('buf7/1','dec/1');
l('dec/1','unb3/1'); l('unb3/1','bits_rec/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1/7','SolverMode','SingleTasking','StopTime','1000');
save_system(mdl);
end