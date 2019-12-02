
%% Basic Information
 % Jingqing Nian, E-mail:nianjingqing@126.com
 % School of Psychology,Guizhou Normal University
 
%%  Analysis Steps
% Define File_Name
% Define Subject_List
% Define Subject_List_Length
% Load Data
     % Define Single_Data_File
% Offline_Reference (˫����ͻ��ȫ��ƽ����REST)
% Event_Code
% Bin_Code
% Epoch (Time Window)
% Baseline Correction
% Artifact Recject in Epoch data
       % Move to Move Window
       % Step Function
% Report Reject Trials number & Ratio
% Save data after Reject
% Average/ Compute ERP

%% Pre_Step
close all;
clear all;
clc;
eeglab;

%% Define Data Basic Information
Exp_File = 'D:\Exp_AB\'; % ʵ�����ݵ�һ��Ŀ¼
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
for i = 1:nsubj; % 1:2:nsubj/ѡȡ�������ԣ� 2:2:nsubj/ѡȡż������;
    Single_Data_File = [EEG_Data_File Subject_List{i} '\'];
    Subject_Name =  Subject_List{i}(1:end); % 1:end /S01  & 2;end/01
    Sname = [Single_Data_File Subject_Name '_ICA_Rejct.set'];
    if exist (Sname, 'file') <= 0;
        fprintf ('\n *** WARING: %s does not exit *** \n',Sname);
        fprintf ('\n *** Skip all Processing for this subject *** \n');
    else
    EEG = pop_loadset('filename',[Subject_Name '_ICA_Rejct.set'],'filepath',Single_Data_File); % ��������
    % EEG = pop_loadcnt ([Single_Data_File Subject_Name '.cnt'],'dataformat', 'auto','memmapfile','');
    % EEG = pop_eegchanopertor(EEG,Ref_File);
    EEG = pop_eegchanoperator(EEG,Ref_File);
    EEG = pop_editeventlist(EEG,'BoundaryNumeric',{-99},'BoundaryString',{'boundary'},'ExportEL',[Single_Data_File Subject_List{i} '_elist.txt'],'List',Event_File);
    EEG  = pop_overwritevent( EEG, 'code'  );
    EEG = pop_binlister(EEG, 'BDF', Bin_File, 'ExportEL', [Single_Data_File Subject_List{i} '_bins.txt'],...
        'ImportEL', 'no', 'Saveas', 'on', 'SendEL2', 'EEG&Text',...
        'UpdateEEG', 'on');
     EEG = pop_epochbin(EEG,[-200 800], 'pre');
     %EEG = pop_epochbin(EEG,[-200 800], [-100 0]);
     EEG=pop_artmwppth(EEG, 'Channel', [44 52 45 59], 'Flag', [1 2], 'Review', 'off',...
        'Threshold', 100, 'Twindow', [-200 800], 'Windowsize', 200 , 'Windowstep', 100);
     EEG = eegcheckset(EEG);
     EEG = pop_saveset(EEG,'filename',[Subject_Name '_ad.set'],'filepath',Single_Data_File);
     ERP = pop_averager(EEG, 'Criterion', 'good', 'DSindex',1);
     ERP = pop_savemyerp(ERP,'erpname',Subject_List{i},'filename', [Subject_Name '.erp'],'filepath', Single_Data_File);
    end
end
