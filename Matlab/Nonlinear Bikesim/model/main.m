clear all; close all; clc;

% Set the viewer preference
vrsetpref('DefaultViewer', 'internalv5')
% Obtain vrworld and construct canvas
w = vrworld('bicycle');
open(w);

%% Create the MATLAB GUI
scrsz = get(0,'ScreenSize');
figure('Position',[100 scrsz(4)-600-100 800 600],'Color',zeros(3,1))

% Simulink 3D 
vr.canvas(w, gcf, [0 200 800 400]);

% Dataplot
A(2) = axes('units','pixels','position',[0  0  400  180]); hold on; box on;
z = zeros(4,1);
plot([0 0],[0,1.8],':k'); plot(0,0,'.k','MarkerSize',32); hold on;
hz = plot(1.5*[0 sin(z(1))],1.5*[0,cos(z(1))],'-k','LineWidth',3,...
    'XDataSource','1.5*[0 -sin(z(1))]','YDataSource','1.5*[0 cos(z(1))]');
axis([-2 2 0 1.8]);

% User input plot
u    = NaN*ones(3,1);
A(1) = axes('units','pixels','position',[0  180  400  20],'XTick',[],'YTick',[]); hold on; box on;
hu = area([0 0 u(2) u(2) 0],[0 1 1 0 0],...
    'XDataSource','[0 0 u(2) u(2) 0]','FaceColor',[1 .5 .5]); 
axis([-1 1 0 1]); 
vmax = 4.7;
Kv = -8.0;
Kc = -0.7;
v  = vmax;
if v < vmax;
    Tdelta = -Kv*(vmax-v)*z(3); % v < vmax
else
    Tdelta = -Kc*(v-vmax)*z(1); % v > vmax
end
hk = plot([Tdelta,Tdelta],[0 1],'k','LineWidth',3,'XDataSource','[Tdelta Tdelta]');

% Eigenvalue plot
A(3) = axes('units','pixels','position',[400  0  400  200],'XTick',[],'YTick',[]);
eigplot; v = NaN;
hv = plot([v,v],[10,-10],'k','XDataSource','[v,v]','LineWidth',3);
axis([0 10 -10 10]);

omega = 5; %rad/s
phimax = pi/6; % rad

%% Simulation
load_system('model');
set_param(gcs,'SimulationMode','external');
set_param(gcs,'SimulationCommand','connect');
set_param(gcs,'SimulationCommand','start');

rto_v = get_param('model/Display','RuntimeObject');
rto_u = get_param('model/Inputscope','RuntimeObject');
rto_z = get_param('model/Statescope','RuntimeObject');

% While simulating
while strcmp(get_param(gcs,'SimulationStatus'),'external')
    
    v = rto_v.InputPort(1).Data;
    u = rto_u.InputPort(1).Data;
    z = rto_z.InputPort(1).Data;
    if v < vmax;
        Tdelta = z(3)/5;%-Kv*(vmax-v)*z(3); % v < vmax
    else
        Tdelta = z(1)/5;%-Kc*(v-vmax)*z(1); % v > vmax
    end
    refreshdata(hk,'caller') % Evaluate y in the function workspace
    refreshdata(hu,'caller') % Evaluate y in the function workspace
    % xlim(A(1),abs(Kv*phimax*omega*(v-vmax))*[-1 1]) 
    refreshdata(hv,'caller') % Evaluate y in the function workspace
    refreshdata(hz,'caller') % Evaluate y in the function workspace
	drawnow; pause(0.01);
end





