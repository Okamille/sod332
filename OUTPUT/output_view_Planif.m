function varargout = Two_Players_Game(varargin)

clear
close all;

%=======================%=======================%=============
%- OCTAVE detect	%- Default is OCTAVE=0. Special commands for octave : (graphs, legends...)
OCTAVE = (exist ('OCTAVE_VERSION', 'builtin') > 0); 
if OCTAVE fprintf('(OCTAVE DETECTED)\n'); else fprintf('(MATLAB DETECTED)\n'); end;
fprintf('Calcul Temps_Optimal par ROCHJ v2.2 - matlab/octave postprocessing;\n');
%=======================%=======================%=============

TEST='Two_Players';
%addpath('amax=1_bmax=0.8');
fprintf('Mars 2020 - Cours de Planification - Problème de \n');

 global Topt INF TOPT_COUPE
    global xmesh ymesh 
    global xmin xmax 
    global dx nn
    

 INF=1e5;

%------------------------------------------------
% 1- loading data.dat and initialisation of parameters
%-      Execute "AALoad_data.m" file
%----------------------------------------------------
    
     AALoad_data;  %- Here the parameters and the time function are uploaded 
                    
     % Matrix Topt: contains the minimum time function
     % The mesh nodes are in xmesh and ymesh               
                
%-------------------------------------------------
%- 2- Backward_REACHABLE Set (Capture Basin) - fig 1 
%-    Isovalues of the minimum time function (in dim 2 - second player)
%-------------------------------------------------

    fig_Reachable=1;
    x_reachable='X-axis';
    y_reachable='Y-axis';
    Title_reachable='Reachable Set at T=';      
    
    fig_Iso_TValue=2; Nbre_Iso=40;
    
    AXEX='X-axis';
    AXEY='Y-axis';
    AXEZ='Minimum Time Function'; 
    Title_IsoValues='Iso-Values of the Minimum Time Function';    
            
    AAPlot;
%-----------------------------------------------------
%- 4 - Trajectory reconstruction - Plot optimal trajectory
%-----------------------------------------------------
  
         Initial_Position_Player1=[0.0;-0.5];
          
         Initial_Position_Player2=[0.0;0.0];
          
         Zlist=reconstruction4d(Initial_Position_Player1,Initial_Position_Player2); %% COMPLETER CE FICHIER
         
         xx_Player1=Zlist(:,1);
         yy_Player1=Zlist(:,2);
         xx_Player2=Zlist(:,3);
         yy_Player2=Zlist(:,4);
         
         figure(fig_Reachable);
         grid on;
         hold on;
         [TRAJ_Player1]=plot(xx_Player1,yy_Player1,'black','LineWidth',2);
        
         [TRAJ_Player2]=plot(xx_Player2,yy_Player2,'red','LineWidth',2);
         %legend([TRAJ_Player1,TRAJ_Player2],'Player1','Player2'); 
         
         [Initial_Position_Player1]=plot(xx_Player1(1),yy_Player1(1)    ,'g.','MarkerSize',20);
         [Final_Position_Player1]= plot(xx_Player1(end),yy_Player1(end),'g+','MarkerSize',20);
         [Initial_Position_Player2]=plot(xx_Player2(1),yy_Player2(1)    ,'b.','MarkerSize',20);
         [Final_Position_Player2]= plot(xx_Player2(end),yy_Player2(end),'b+','MarkerSize',20);
          
         legend([TRAJ_Player1,TRAJ_Player2,Initial_Position_Player1,...
             Initial_Position_Player2,Final_Position_Player1,Final_Position_Player2],...
                    'Player1','Player2','Start_Player1','Start_Player2','Arrival_Player1','Arrival_Player2'); 

%=========================
end

function plotRect(dimRect,centre,col)
fill(dimRect(1,:)+centre(1,1),dimRect(2,:)+centre(1,2),col);
end 

function plot_cercle(cx,cy,r,color)
theta=0:0.1:2*pi+0.1;
p=[(r*cos(theta))' (r*sin(theta))'];
patch(cx+p(:,1),cy+p(:,2),color,'EdgeColor',color);
end 
 

