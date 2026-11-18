% CONSTRUIRE_CODEUR  Cree le modele Simulink du codeur Hamming(7,4)
% registre a decalage 3 bascules (Unit Delay) + XOR + Switch (tout en booleen)
mdl = 'hamming_enc_sl';
if bdIsLoaded(mdl), close_system(mdl,0); end
new_system(mdl); open_system(mdl);
pos = @(x,y) [x y x+60 y+40];
L = 'simulink/Logic and Bit Operations/Logical Operator';

add_block('simulink/Sources/From Workspace',[mdl '/msg'],'Position',pos(30,40),'VariableName','msg_in','SampleTime','1');
add_block('simulink/Signal Attributes/Data Type Conversion',[mdl '/mb'],'Position',pos(140,40),'OutDataTypeStr','boolean');
add_block('simulink/Sources/Counter Limited',[mdl '/cnt'],'Position',pos(30,200),'uplimit','6','tsamp','1');
add_block('simulink/Logic and Bit Operations/Compare To Constant',[mdl '/ph'],'Position',pos(140,200),'relop','<','const','4');

add_block(L,[mdl '/xin'],'Position',pos(250,60),'Operator','XOR','Inputs','2');
add_block(L,[mdl '/fand'],'Position',pos(370,100),'Operator','AND','Inputs','2');
add_block(L,[mdl '/x1'],'Position',pos(560,100),'Operator','XOR','Inputs','2');

add_block('simulink/Discrete/Unit Delay',[mdl '/d0'],'Position',pos(470,160),'InitialCondition','0','SampleTime','1');
add_block('simulink/Discrete/Unit Delay',[mdl '/d1'],'Position',pos(670,100),'InitialCondition','0','SampleTime','1');
add_block('simulink/Discrete/Unit Delay',[mdl '/d2'],'Position',pos(780,100),'InitialCondition','0','SampleTime','1');

add_block('simulink/Signal Routing/Switch',[mdl '/sw'],'Position',pos(900,40),'Criteria','u2 ~= 0');
add_block('simulink/Sinks/To Workspace',[mdl '/out'],'Position',pos(1020,40),'VariableName','cw_out','SaveFormat','Array','SampleTime','1');

l = @(a,b) add_line(mdl,a,b,'autorouting','on');
l('msg/1','mb/1');
l('cnt/1','ph/1');
l('mb/1','xin/1');  l('d2/1','xin/2');
l('ph/1','fand/1'); l('xin/1','fand/2');
l('fand/1','d0/1');
l('d0/1','x1/1');   l('fand/1','x1/2');
l('x1/1','d1/1');   l('d1/1','d2/1');
l('mb/1','sw/1');   l('ph/1','sw/2');  l('d2/1','sw/3');
l('sw/1','out/1');

set_param(mdl,'SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
    'FixedStep','1','StopTime','111');
save_system(mdl);
disp('Modele codeur_hamming_sl cree');