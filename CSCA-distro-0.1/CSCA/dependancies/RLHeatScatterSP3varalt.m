function [] = RLHeatScatterSP3varalt(xCell,rCell,figNum,lims,labs,cleans,xlocs,rlocs,altpoints,showlocs)
    % Expects a set of x vectors, y vectors and z vectors, as well as the
    % number of subplots necessary
    
    % showlocs == 0 (no local mins plotted), 
    %          == 1 (all local mins plotted),
    %          == 2 (all local mins plotted with true min separately)
    figure(figNum);
    clf;
    
    Dims=size(xCell{1});
    combs=combnk(1:Dims(2),2);
    scombs=size(combs);
    
    % Add arbitrary points to a given scatter plot (generally measures of
    % central tendancy). Supports up to 4. You can mess with RGB color
    % values but right now they're all yellow. 
    ptDims=size(altpoints);
    Colors={[255,255,0]./256,[255,255,0]./256,[255,255,0]./256,[255,255,0]./256};
    Markers={'s','o','d','^'};

    
    % Plot scatter plots (2D)
    for i=1:scombs(1)
        
        % Make Color Vector
        response=log(rCell{1});
        nc=16;
        offset=1;
        c=response-min(response);
        c = round((nc-1-2*offset)*c/max(c)+1+offset);
%         colormap(newmap);
        
        % Make a set of subplots, width = 5 plots, height is arbitrary as
        % needed to present all pairwise combinations of fit parameters
        % (plus the spectrum)
        subplot(ceil((length(combs)+1)/5),5,i);
        scatter(xCell{1}(:,combs(i,1)),xCell{1}(:,combs(i,2)),2, c, 'filled')
        % Option plots local minima included in cluster. 
        if or(showlocs==1,showlocs==2)
            hold on ;
            scatter(xlocs{1}(:,combs(i,1)),xlocs{1}(:,combs(i,2)),3,[208,32,144]./256,'filled');
        end
        % Option plots global minimum as well as local minima included in
        % cluster. 
        if showlocs==2
            hold on ;
            [mins,inds]=min(rlocs{1});
            scatter(xlocs{1}(inds,combs(i,1)),xlocs{1}(inds,combs(i,2)),60,[124,250,0]./256,'filled','LineWidth',1,'MarkerEdgeColor',[0,100,0]./256);
        end
        % if users specified good altpoints, those get plotted as well. 
        if showlocs==2
            if ptDims(1)==Dims(2)
                for k=1:ptDims(2)
                     h=scatter(altpoints(combs(i,1),k),altpoints(combs(i,2),k),40,Markers{mod(k-1,length(Colors))+1},'LineWidth',1,'MarkerFaceColor',Colors{mod(k-1,length(Colors))+1},'MarkerEdgeColor',[0,0,0]/255);
                     h.SizeData=60;
                end
            end
        end
        xlim(lims{combs(i,1)});
        ylim(lims{combs(i,2)});
        xlabel(labs{combs(i,1)},'Interpreter','latex');
        ylabel(labs{combs(i,2)},'Interpreter','latex');
        
        set(gca,'box','on','linewidth',2,'fontsize',12,'fontname','times');
        axis square
    
    end
    
    % Plot spectrum and best fit. 
    subplot(ceil((length(combs)+1)/5),5,scombs(1)+1);
    i=1;
    plot(cleans{i}.Bfield(:,cleans{i}.chiSq==min(cleans{i}.chiSq)),cleans{i}.Ifit(:,cleans{i}.chiSq==min(cleans{i}.chiSq)),'LineWidth',2,'Color',[0.2,0.2,1]);
    hold on
    plot(cleans{i}.Bfield(:,cleans{i}.chiSq==min(cleans{i}.chiSq)),cleans{i}.Idata(:,cleans{i}.chiSq==min(cleans{i}.chiSq)),'LineWidth',2,'Color','k');
    set(gca,'box','on','linewidth',2,'fontsize',12,'fontname','times','ytick',[]);
    axis square
    xlabel('B (Gauss)','Interpreter','latex');
    ylabel('I (a.u.)','Interpreter','latex');
    xmin=min(cleans{i}.Bfield(:,cleans{i}.chiSq==min(cleans{i}.chiSq)));
    xmax=max(cleans{i}.Bfield(:,cleans{i}.chiSq==min(cleans{i}.chiSq)));
    xlim([xmin,xmax]);

end


function [cmap]=makemap()

% Make colormap:
    cmap=[255,211,0;
    255,211,0;
    255,210,0;
    255,210,0;
    255,210,0;
    255,209,0;
    255,209,0;
    255,208,0;
    255,208,0;
    255,208,0;
    255,207,0;
    255,207,0;
    255,207,0;
    255,206,0;
    255,206,0;
    255,206,0;
    255,205,0;
    255,205,0;
    255,205,0;
    255,204,0;
    255,204,0;
    255,204,0;
    255,203,0;
    255,203,0;
    255,203,0;
    255,202,0;
    255,202,0;
    255,201,0;
    255,201,0;
    255,201,0;
    255,200,0;
    255,200,0;
    255,200,0;
    255,199,0;
    255,199,0;
    255,199,0;
    255,198,0;
    255,198,0;
    255,198,0;
    255,197,0;
    255,197,0;
    255,197,0;
    255,196,0;
    255,196,0;
    255,195,0;
    255,195,0;
    255,195,0;
    255,194,0;
    255,194,0;
    255,194,0;
    255,193,0;
    255,193,0;
    255,193,0;
    255,192,0;
    255,192,0;
    255,192,0;
    255,191,0;
    255,191,0;
    255,191,0;
    255,190,0;
    255,190,0;
    255,190,0;
    255,189,0;
    255,189,0;
    255,188,0;
    255,187,0;
    255,186,0;
    255,185,0;
    255,184,0;
    255,183,0;
    255,182,0;
    254,181,0;
    254,180,0;
    254,179,0;
    254,178,0;
    254,177,0;
    253,176,0;
    253,175,0;
    253,174,0;
    253,173,0;
    253,172,0;
    252,171,0;
    252,170,0;
    252,169,0;
    252,168,0;
    252,167,0;
    251,166,0;
    251,165,0;
    251,164,0;
    251,163,0;
    251,162,0;
    250,161,0;
    250,160,0;
    250,159,0;
    250,158,0;
    250,157,0;
    250,156,0;
    249,155,0;
    249,154,0;
    249,153,0;
    249,152,0;
    249,151,0;
    248,150,0;
    248,149,0;
    248,148,0;
    248,147,0;
    248,146,0;
    247,145,0;
    247,143,0;
    247,142,0;
    247,141,0;
    247,140,0;
    246,139,0;
    246,138,0;
    246,137,0;
    246,136,0;
    246,135,0;
    245,134,0;
    245,133,0;
    245,132,0;
    245,131,0;
    245,130,0;
    244,129,0;
    244,128,0;
    244,127,0;
    244,126,0;
    244,125,0;
    244,124,0;
    243,123,0;
    243,121,1;
    243,119,1;
    242,117,2;
    242,115,2;
    242,113,3;
    242,111,3;
    241,109,4;
    241,107,5;
    241,105,5;
    240,103,6;
    240,101,6;
    240,99,7;
    239,97,7;
    239,96,8;
    239,94,8;
    239,92,9;
    238,90,9;
    238,88,10;
    238,86,10;
    237,84,11;
    237,82,11;
    237,80,12;
    237,78,13;
    236,76,13;
    236,74,14;
    236,72,14;
    235,70,15;
    235,68,15;
    235,66,16;
    235,64,16;
    234,63,17;
    234,61,17;
    234,59,18;
    233,57,18;
    233,55,19;
    233,53,19;
    233,51,20;
    232,49,21;
    232,47,21;
    232,45,22;
    231,43,22;
    231,41,23;
    231,39,23;
    230,37,24;
    230,35,24;
    230,33,25;
    230,32,25;
    229,30,26;
    229,28,26;
    229,26,27;
    228,24,27;
    228,22,28;
    228,20,29;
    228,18,29;
    227,16,30;
    227,14,30;
    227,12,31;
    226,10,31;
    226,8,32;
    226,6,32;
    226,4,33;
    225,2,33;
    225,0,34;
    225,0,34;
    225,0,35;
    225,0,36;
    225,0,36;
    224,0,37;
    224,0,37;
    224,0,38;
    224,0,39;
    224,0,39;
    224,0,40;
    224,0,40;
    224,0,41;
    224,0,41;
    224,0,42;
    223,0,43;
    223,0,43;
    223,0,44;
    223,0,44;
    223,0,45;
    223,0,45;
    223,0,46;
    223,0,47;
    223,0,47;
    223,0,48;
    222,0,48;
    222,0,49;
    222,0,50;
    222,0,50;
    222,0,51;
    222,0,51;
    222,0,52;
    222,0,52;
    222,0,53;
    222,0,54;
    221,0,54;
    221,0,55;
    221,0,55;
    221,0,56;
    221,0,57;
    221,0,57;
    221,0,58;
    221,0,58;
    221,0,59;
    221,0,59;
    221,0,60;
    220,0,61;
    220,0,61;
    220,0,62;
    220,0,62;
    220,0,63;
    220,0,64;
    220,0,64;
    220,0,65;
    220,0,65;
    220,0,66;
    219,0,66;
    219,0,67;
    219,0,68;
    219,0,68;
    219,0,69;
    219,0,69;
    219,0,70;
    219,0,71;
    219,0,71]./256;

    cmap=flipud(cmap);

end





