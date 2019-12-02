% Basic Information
 % Jingqing Nian, E-mail:nianjingqing@126.com
 % School of Psychology,Guizhou Normal University
 
%%  Analysis Steps
% Define File_Name
% Define Subject_List
% Define Subject_List_Length
% Load Data
     % Define Single_Data_File
 % Define Con. & Ips.
 % Compute Different ERP wave
 % Save Data
 
 %% Pre_Step
close all;
clear all;
clc;
eeglab;

%% Define Data Basic Information
Exp_File = 'D:\Exp_AB\'; % 实验数据的一级目录
Code_File = [Exp_File 'Script\'];
Data_File = [Exp_File 'Data\'];
EEG_Data_File = [Data_File 'EEG_Data\'];
Ref_File = [Code_File 'Reference.txt'];
Event_File = [Code_File 'Event_List.txt'];
Bin_File = [Code_File 'Bin_List.txt'];
Com_Ips_File = [Code_File 'Con_Ips.txt'];
Diff_Wave_File = [Code_File 'Diff_Wave.txt'];
Channle_Location_File = 'D:\Software\MATLAB\Toolbox\eeglab14_1_2b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';

%% Define Subject_List 
Subject_List = {'S01' 'S02'};
% Subject_List = {'S01','S02'};
nsubj = length(Subject_List);

%% Pre-Processing
for i = 1:nsubj; % 1:2:nsubj/选取奇数被试； 2:2:nsubj/选取偶数被试;
    Single_Data_File = [EEG_Data_File Subject_List{i} '\'];
    Subject_Name =  Subject_List{i}(1:end); % 1:end /S01  & 2;end/01
    Sname = [Single_Data_File Subject_Name '.erp'];
    if exist (Sname, 'file') <= 0;
        fprintf ('\n *** WARING: %s does not exit *** \n',Sname);
        fprintf ('\n *** Skip all Processing for this subject *** \n');
    else
    ERP = pop_loaderp( 'filename',[Subject_Name '.erp'], 'filepath', Single_Data_File);
    ERP = pop_binoperator( ERP,Com_Ips_File);
    ERP = pop_binoperator( ERP,Diff_Wave_File);
    ERP = pop_savemyerp(ERP,'erpname',Subject_List{i},'filename',[Subject_Name '_Diff.erp'],'filepath', Single_Data_File ); 
    end
    end     