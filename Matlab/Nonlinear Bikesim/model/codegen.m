clear all; close all; clc;

% rtwcfg = emlcoder.RTWConfig;
% FilePartitionMethod = 'SingleFile';
% emlc -c -O disable:inline -s rtwcfg -d model/emc -T rtw:lib  odefun;

rtwcfg = emlcoder.RTWConfig;
rtwcfg.FilePartitionMethod = 'SingleFile';
emlc -d emc -s rtwcfg -O disable:inline -T rtw odefun_nonlinear;

% -O disable:inline