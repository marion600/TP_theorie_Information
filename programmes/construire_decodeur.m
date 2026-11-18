% CONSTRUIRE_DECODEUR  Decodeur Hamming(7,4) par syndrome (portes logiques)
mdl = 'hamming_dec_sl';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl); open_system(mdl);
pos = @(x,y) [x y x+60 y+40];
L = 'simulink/Logic and Bit Operations/Logical Operator';
lg = @(nom,op,n,x,y) add_block(L,[mdl '/' nom],'Position',pos(x,y),'Operator',op,'Inputs',n);

add_block('simulink/Sources/From Workspace',[mdl '/rec'],'Position',pos(30,200),'VariableName','rec_in','SampleTime','1');
add_block('simulink/Signal Attributes/Data Type Conversion',[mdl '/cv'],'Position',pos(130,200),'OutDataTypeStr','boolean');
add_block('simulink/Signal Routing/Demux',[mdl '/dm'],'Position',[230 100 235 400],'Outputs','7');

% syndromes
lg('s0','XOR','4',330,60);  lg('s1','XOR','4',330,160);  lg('s2','XOR','4',330,260);
% negations
lg('n0','NOT','1',430,60);  lg('n1','NOT','1',430,160);  lg('n2','NOT','1',430,260);
% detecteurs d'erreur sur m0..m3
lg('e1','AND','3',540,40);  lg('e2','AND','3',540,140);
lg('e3','AND','3',540,240); lg('e4','AND','3',540,340);
% correction
lg('c1','XOR','2',650,40);  lg('c2','XOR','2',650,140);
lg('c3','XOR','2',650,240); lg('c4','XOR','2',650,340);
add_block('simulink/Signal Routing/Mux',[mdl '/mx'],'Position',[760 100 765 380],'Inputs','4');
add_block('simulink/Sinks/To Workspace',[mdl '/out'],'Position',pos(850,220),'VariableName','dec_out','SaveFormat','Array','SampleTime','1');

l = @(a,b) add_line(mdl,a,b,'autorouting','on');
l('rec/1','cv/1'); l('cv/1','dm/1');
% syndromes
l('dm/1','s0/1'); l('dm/3','s0/2'); l('dm/4','s0/3'); l('dm/5','s0/4');
l('dm/1','s1/1'); l('dm/2','s1/2'); l('dm/3','s1/3'); l('dm/6','s1/4');
l('dm/2','s2/1'); l('dm/3','s2/2'); l('dm/4','s2/3'); l('dm/7','s2/4');
l('s0/1','n0/1'); l('s1/1','n1/1'); l('s2/1','n2/1');
% e1: s=(1,1,0)  e2: (0,1,1)  e3: (1,1,1)  e4: (1,0,1)
l('s0/1','e1/1'); l('s1/1','e1/2'); l('n2/1','e1/3');
l('n0/1','e2/1'); l('s1/1','e2/2'); l('s2/1','e2/3');
l('s0/1','e3/1'); l('s1/1','e3/2'); l('s2/1','e3/3');
l('s0/1','e4/1'); l('n1/1','e4/2'); l('s2/1','e4/3');
% correction des 4 bits de message
l('dm/1','c1/1'); l('e1/1','c1/2');
l('dm/2','c2/1'); l('e2/1','c2/2');
l('dm/3','c3/1'); l('e3/1','c3/2');
l('dm/4','c4/1'); l('e4/1','c4/2');
l('c1/1','mx/1'); l('c2/1','mx/2'); l('c3/1','mx/3'); l('c4/1','mx/4');
l('mx/1','out/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete','FixedStep','1');
save_system(mdl);
disp('Modele hamming_dec_sl cree');