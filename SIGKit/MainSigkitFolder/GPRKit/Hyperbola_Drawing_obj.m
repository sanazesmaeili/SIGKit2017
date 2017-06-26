
   function Hyperbola_Drawing_obj(filename)

        %%%%Hyporbola Drawing
        %allows user to define the position of a hyperbola and then vary the
        %dielectric to match the shape of its limbs outputting the material
        %dielectric and velocity 

        imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
        ylim([filename.t0, filename.tend]);
        %figure;
        %plot(filename.Distance,filename.Time,filename.Amplitude); colormap(gray);
        %hold on
        %%%%%%%%
        %user defines apex height. 

        [ex AH]=ginput;
        %AH= 52 %apex height in ns. select using ginput
        %ex=4; %x position of reflector in x axis. select using ginput
 
        DEC= 15 %dielectric constant
        %defined at first by script. 
        v=0.3/sqrt(DEC); % defined in script by auto use of 15
 
        %calculated in script after x and AH prompt
        DD= 0.3/sqrt(DEC)*AH;
 
        EX= [ex-4:0.2:ex+4]; %locations of data points along X
 
        R1= []
        T=[]
            for EX1=EX
   
                R= sqrt((EX1-ex).^2+DD^2);
                R1=[R1 R]
                T=R1/v
            end
 
        %hold on

%         figure
%         imagesc(filename.Distance,filename.Time,filename.Amplitude); colormap(gray); hold on;
        hold on; scatter(EX,T,'filled');
        % figure;
VV=v*100;

        GG='Hyperbola Depth in m';
        WP='Velocity of this material in cm/ns';
        disp (GG);
        disp (DD/2);
        disp (WP);
        disp (VV);

          hold on;
         plot (EX, -T, 'yo', 'markersize', 6,'markerfacecolor',[.4 .7 .0]);        
                
    end