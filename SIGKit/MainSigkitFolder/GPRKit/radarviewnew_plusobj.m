%GROUP 1 indicates a modification to the original radarview

function [radar_small,t,dist]=radarviewnew_plusobj(radarfile,scale);
% function [radar,depth,dist]=radarview(radarfile);
% to produce radargrams
% input: radarfile (GSSI DZT file)
%        scale - gain (linear factor) for colormap
% output: radar - radarsection (matrix)
%         depth - depth values of samples
%         dist  - distance for trace
% calls readgssi.m
% CGB, June 2010
  %clear all; close all; format compact;
  %addpath ../matlab/gpr
 
 %radarfile='../data/20100618/gpr/GRID____002.3DS/FILE____001.DZT';
 
 data=readgssi(radarfile);
 
 
 
 %addpath ../
 
   %shortname=strtok(radarfile,'.'); %removes .DZT extension from file names
   [path,shortname,ext] = fileparts(radarfile)
   
%   shortname2=shortname;
% %  shortname3=shortname;
%  %filename=shortname; %need to make a string of the file name
  filename=GPR; %need to save the file name as object
 
 %filename.DataDir = which(radarfile)
 
 %GROUP 1: reduce the resolution of the radar file for ginput of a 2048x2482 samp double matrix to a single matrix
 %radar_small=(data.samp);
 radar_small=single(data.samp);
 filename.Amplitude=radar_small;
 
  %radar=data.samp;
  
  %%%%%what is this doing?????? and why???
 newzero=mean(mean(radar_small));
 newrange=(max(max(radar_small)) - newzero)/scale;
 %%%%%%%%%%%
 
 %GROUP 1: tmax = bot, tmin = top
 tmax=data.head.range; %max range
 filename.tend=tmax
 tmin=data.head.position; %min range
 filename.t0=tmin
 
 nsamp=data.head.nsamp;
 %GROUP 1: dt = dz
 dt=(tmax-tmin)/(nsamp-1); %defines the step spacing for 
 %%%population of the traces with amplitude data?
 
 %GROUP 1: t is a new vector incorporating two-way travel time rather than
 %a depth conversion (depth is calculated using the depth function)
 %t will be used in the first plot of FILE____009.DZT from 0ns to 400ns
 
 t=tmin:dt:tmax;
 filename.Time=t; %populates the time at equal intervals
 
 ntrace=size(data.samp,2);
 filename.nTraces=ntrace;
 dist=(1:ntrace)/data.head.spm;
 filename.Distance=dist;
 filename.tracespace=dist %this is where the spacing of traces is calculated
 filename.Filename=shortname;
 filename.DataDir=path
 
 %filename.Distance=dist; %the distance and spacing of the traces??? yes. 
 %%%%%%%testers=1:(size(filename.Distance,2))
 
  
 %GROUP 1: pcolor is replaced by imagesc to reduce the resolution of a
 %double 2048x2482 samp matrix and facitilate x and y coordinate selection
 
 
%  imagesc(dist,t,radar_small); %%%%%THIS IS WHERE THE FIGURE IS CREATED
%  caxis([newzero-newrange newzero+newrange]);
%  axis ij; shading flat;
%  xlabel('Distance (m)'); 
%  ylabel('Two-way travel time (ns)');
%  title([radarfile],'interpreter','none');
 
fs = filesep;
save ([filename.DataDir fs,filename.Filename,'.mat'], 'filename');




             fs = filesep;
             filepath=filename.DataDir
             Savepath = strcat([filepath fs 'Raw_Data']);
             
                if exist(Savepath,'dir')
                    %save([Savepath fs,filename.Filename],'RecXProf','PickTime','ShotXProf');
                    save([Savepath fs,filename.Filename],'filename');
                        else mkdir (Savepath)
                            %save([Savepath fs ,filename.Filename],'RecXProf','PickTime','ShotXProf');
                            save([Savepath fs ,filename.Filename],'filename');
                end
 
end
