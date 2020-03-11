%----------------------------------------
%-  Display of the Backward Reachable Set
%----------------------------------------
    figure(fig_Reachable);
    clf;
    
    it=find(Topt_Coupe<=T); %% ICI VAL=Temp_optim
    xg=x(it,1);
    yg=x(it,2);

    if OCTAVE; color_app='*';
    else     ; color_app='.';
    end
    GRAPH_REACHABLE=plot(xg,yg,color_app,'MarkerSize',7,'MarkerFaceColor',[0.3 0.2 0.1]);

    %title(strcat('level set=',num2str(level_set)));
    axis square;
    axis([xmin(cdd(1)),xmax(cdd(1)),xmin(cdd(2)),xmax(cdd(2))]);
    hold on;
    grid on;

    xlabel(x_reachable,'FontSize',13,'FontWeight','bold'); 
    ylabel(y_reachable,'FontSize',13,'FontWeight','bold');
    TITLE=strcat(Title_reachable,num2str(T)); %,'level set=', num2str(level_set));
    title(TITLE);
    
%----------------------------------------
%- Display the "Target"
%- 
%----------------------------------------
    figure(fig_Reachable);
    hold on;

    level_set_Target=1e-10;
     
    i_target=find(Topt_Coupe<=level_set_Target);
            
    %level_temp=min(min(val)); i=find(val<=level_temp); %- this better for value problem
    xg=x(i_target,1);
    yg=x(i_target,2);

    if OCTAVE; color_target='c*'; color_contour='k--';
    else     ; color_target='c.'; color_contour='k--';
    end

    %- green region {VF0<=0}
     GRAPH_REACHABLE=plot(xg,yg,color_target,'MarkerSize',10);
     hold on;

        
%----------------------------------------
%- Display the level-sets of the minimum time function 
%- (in the x and y axis for the second player
%----------------------------------------

TMAX=1.5*T+0.1;
val=min(TMAX,Topt_Coupe);
%i=find(val==TMAX); %val(i)=0.0;
V=val;
    
figure(fig_Iso_TValue);
clf;
[Xmesh,Ymesh]=meshgrid(xmesh,ymesh);
contour(Xmesh,Ymesh,V',Nbre_Iso); %- contour
xlabel(AXEX,'FontSize',13,'FontWeight','bold');
ylabel(AXEY,'FontSize',13,'FontWeight','bold');
zlabel(AXEZ,'FontSize',13,'FontWeight','bold');
title(Title_IsoValues);
hold on;
grid on;

