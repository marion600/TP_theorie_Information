% CONSTRUIRE_CHAINE_COD  Chaine avec codage Hamming(7,4), construite a partir de chaine_int
mdl = 'chaine_cod';  src = 'chaine_int';
load_system(src);
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl); open_system(mdl);
Pz = @(x,y) [x y x+60 y+40];
cp = @(nom,nouveau,x,y) add_block([src '/' nom],[mdl '/' nouveau],'Position',Pz(x,y));

% --- source equiprobable ---
add_block('simulink/Sources/Random Number',[mdl '/rs'],'Position',Pz(20,40),'Mean','0','Variance','1','Seed','graine+1','SampleTime','1');
add_block('simulink/Logic and Bit Operations/Compare To Constant',[mdl '/cs'],'Position',Pz(110,40),'relop','>','const','0');
add_block('simulink/Sinks/To Workspace',[mdl '/bits_sim'],'Position',Pz(200,0),'VariableName','bits_sim','SaveFormat','Array','SampleTime','1');
cp('Data Type Conversion','dc1',200,70);

% --- codage : Buffer 4 -> codeur -> Unbuffer ---
cp('Buffer','buf4',290,70);  set_param([mdl '/buf4'],'N','4');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/enc'],'Position',Pz(380,70));
add_block('dspbuff3/Unbuffer',[mdl '/unb1'],'Position',Pz(470,70));

% --- modulation, canal ---
cp('Gain','gain',560,70);   set_param([mdl '/gain'],'Gain','2*Ac');
cp('Bias','bias',650,70);   set_param([mdl '/bias'],'Bias','-Ac');
cp('Repeat','rep',740,70);
cp('Add','add',830,70);
cp(sprintf('Random\nNumber'),'noise',740,150);
set_param([mdl '/noise'],'SampleTime','4/(7*L)');

% --- detection : integrateur-vide ---
cp('Buffer','bufL',920,70);
cp('Mean','mean',1010,70);
cp(sprintf('Relational\nOperator'),'rel',1100,70);
cp('Constant','seuil',1010,150);  set_param([mdl '/seuil'],'SampleTime','inf');
cp('Data Type Conversion','dc2',1190,70);
add_block('simulink/Discrete/Integer Delay',[mdl '/dly'],'Position',Pz(1235,150),'NumDelays','6');

% --- decodage : Buffer 7 -> decodeur -> Unbuffer ---
cp('Buffer','buf7',1280,70); set_param([mdl '/buf7'],'N','7');
add_block('simulink/User-Defined Functions/MATLAB Function',[mdl '/dec'],'Position',Pz(1370,70));
add_block('dspbuff3/Unbuffer',[mdl '/unb2'],'Position',Pz(1460,70));
add_block('simulink/Sinks/To Workspace',[mdl '/bits_rec'],'Position',Pz(1550,70),'VariableName','bits_rec','SaveFormat','Array','SampleTime','1');

% --- code des deux MATLAB Function (memes calculs que codeur_hamming / decodeur_hamming) ---
enc_code = strjoin({ ...
    'function c = enc(m)', '%#codegen', ...
    'P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];', 'G = [eye(4) P];', ...
    'c = mod(G''*double(m(:)), 2);', 'end'}, newline);
dec_code = strjoin({ ...
    'function m = dec(r)', '%#codegen', ...
    'P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];', 'H = [P'' eye(3)];', ...
    'x = double(r(:));', 's = mod(H*x, 2);', 'idx = s(1) + 2*s(2) + 4*s(3);', ...
    'pos = [5 6 1 7 4 2 3];', ...
    'if idx > 0', '    j = pos(idx);', '    x(j) = 1 - x(j);', 'end', ...
    'm = x(1:4);', 'end'}, newline);
rt = sfroot;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/enc']);  ch.Script = enc_code;
ch = rt.find('-isa','Stateflow.EMChart','Path',[mdl '/dec']);  ch.Script = dec_code;

% --- connexions ---
l = @(a,b) add_line(mdl,a,b,'autorouting','on');
l('rs/1','cs/1');     l('cs/1','bits_sim/1');  l('cs/1','dc1/1');
l('dc1/1','buf4/1');  l('buf4/1','enc/1');     l('enc/1','unb1/1');
l('unb1/1','gain/1'); l('gain/1','bias/1');    l('bias/1','rep/1');
l('rep/1','add/1');   l('noise/1','add/2');
l('add/1','bufL/1');  l('bufL/1','mean/1');    l('mean/1','rel/1');
l('seuil/1','rel/2'); l('rel/1','dc2/1');
l('dc2/1','dly/1');   l('dly/1','buf7/1');     l('buf7/1','dec/1');   l('dec/1','unb2/1');
l('unb2/1','bits_rec/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1/(7*L)','SolverMode','SingleTasking','StopTime','1000');
save_system(mdl);
disp('Modele chaine_cod cree');