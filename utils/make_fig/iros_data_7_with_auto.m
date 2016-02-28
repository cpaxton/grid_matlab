% iros_data_2.m

A = [
0.242604 0.142780 -0.174416 0.089719
0.346199 0.331833 -0.088881 0.042905
0.014012 0.013069 -0.001370 0.004863
0.036230 0.015586 -0.005926 0.032165
0.023172 -0.018296 -0.002299 -0.014033
0.218775 -0.199996 0.073229 -0.050018
0.119906 -0.037644 0.110149 0.028764
0.010604 0.010394 0.000059 -0.002097
0.481964 -0.131066 -0.451607 0.105650
0.017310 0.017295 -0.000516 0.000479
];

B = [
0.007629 0.004250 -0.000701 -0.006296
0.009818 0.006890 -0.005929 0.003711
0.010744 0.009620 -0.004166 -0.002353
0.308808 -0.000001 0.073227 0.300000
0.011211 -0.006709 -0.004282 0.007896
0.298330 -0.253058 -0.030852 -0.154955
0.010387 0.003960 -0.009183 -0.002809
0.011519 0.010408 -0.001573 -0.004677
0.020399 0.014693 -0.003824 -0.013624
0.011921 0.011754 0.000227 -0.001973
];

C = [
0.014546 0.004382 -0.008446 -0.011002
0.019408 0.008652 -0.015578 -0.007690
0.014159 0.008094 -0.011215 0.003032
0.308808 -0.000028 0.073226 0.300000
0.043692 -0.007457 0.033808 -0.026653
0.130027 -0.050338 0.037796 0.113774
1.358262 1.119358 -0.146296 0.755322
0.008432 0.008013 -0.001880 0.001833
0.015418 0.014763 -0.004103 -0.001710
0.112506 0.042298 -0.009260 -0.103840
];

D = [
0.008665 0.008654 0.000086 0.000429
0.006709 0.006603 -0.000157 -0.001176
0.014374 0.014287 -0.001070 0.001166
0.012942 0.011464 -0.001063 -0.005911
0.006384 0.004399 -0.004084 -0.002174
0.006985 0.000234 -0.002221 -0.006619
0.007901 0.007384 -0.002527 -0.001230
0.015105 0.011841 -0.009360 -0.000592
0.007224 0.006160 -0.002927 -0.002384
0.004288 0.002360 -0.003560 -0.000374
];

AA = [
0.005250 0.003627 -0.000427 -0.003772
0.005584 -0.002741 -0.000163 -0.004863
0.004128 0.001407 -0.003837 -0.000582
0.003309 -0.003122 0.000108 -0.001092
0.002831 -0.001850 -0.002079 -0.000520
0.005948 0.005374 -0.000000 -0.002547
0.001648 -0.000784 -0.001293 -0.000656
0.004806 0.001067 -0.002524 -0.003949
0.009212 -0.006600 -0.000117 -0.006426
0.013626 -0.012007 -0.002585 -0.005900
    ];
BB = [
    0.005250 0.003627 -0.000427 -0.003772
0.005584 -0.002741 -0.000163 -0.004863
0.004128 0.001407 -0.003837 -0.000582
0.003309 -0.003122 0.000108 -0.001092
0.002831 -0.001850 -0.002079 -0.000520
0.005948 0.005374 -0.000000 -0.002547
0.001648 -0.000784 -0.001293 -0.000656
0.004806 0.001067 -0.002524 -0.003949
0.009212 -0.006600 -0.000117 -0.006426
0.013626 -0.012007 -0.002585 -0.005900
    ];
CC = [
1.588276 -1.379801 0.398915 -0.677964
0.247565 -0.143716 -0.181534 -0.087631
0.076927 -0.035139 0.058140 0.036093
0.308806 -0.000070 0.073221 0.300000
0.007525 -0.004723 -0.000969 0.005777
0.218773 -0.199993 0.073221 -0.050031
0.022983 -0.022107 -0.001244 -0.006161
0.026763 0.010202 0.001099 -0.024718
0.018261 -0.003577 0.000345 -0.017904
0.220863 0.029290 -0.058471 0.210959
    ];
DD = [
0.004134 0.002392 -0.000442 -0.003342
0.002245 0.002106 -0.000408 -0.000661
0.004771 -0.002400 -0.003785 0.001637
0.004509 0.002745 -0.001856 -0.003059
0.002452 0.002291 0.000059 -0.000872
0.011838 -0.009942 -0.000315 -0.006418
0.003128 -0.000036 -0.000883 0.003000
0.003864 0.003107 -0.002204 -0.000646
0.003538 0.002545 -0.000093 0.002457
0.005727 -0.002417 -0.001339 -0.005016
    ];

A = abs(A);
B = abs(B);
C = abs(C);
D = abs(D);
AA = abs(AA);
BB = abs(BB);
CC = abs(CC);
DD = abs(DD);

percentile = 20;
meanA = trimmean(A,percentile); stdA = std(A);
meanB = trimmean(B,percentile); stdB = std(B);
meanC = trimmean(C,percentile); stdC = std(C);
meanD = trimmean(D,percentile); stdD = std(D);
meanAA = trimmean(AA,percentile); stdAA = std(AA);
meanBB = trimmean(BB,percentile); stdBB = std(BB);
meanCC = trimmean(CC,percentile); stdCC = std(CC);
meanDD = trimmean(DD,percentile); stdDD = std(DD);

for i = 1:4
    fprintf('& $%f \\pm %f$',meanA(i),stdA(i));
end
fprintf('\n');
for i = 1:4
    fprintf('& $%f \\pm %f$',meanB(i),stdB(i));
end
fprintf('\n');
for i = 1:4
    fprintf('& $%f \\pm %f$',meanC(i),stdC(i));
end
fprintf('\n');
for i = 1:4
    fprintf('& $%f \\pm %f$',meanD(i),stdD(i));
end
fprintf('\n');

%% graphic
%bar(meanA,meanB,meanC,meanD)
figure; %hold on;
bar(abs([meanA; meanB; meanC; meanD;meanAA; meanBB; meanCC; meanDD])');
set(gca,'fontsize',14);
ylabel('Average error (m)');
legend('no options/no lookahead','no options/lookahead', ...
    'options/no lookahead','options/lookahead',...
    'a/no options/no lookahead', ...
    'a/no options/lookahead', ...
    'a/options/no lookahead', ...
    'a/options/lookahead');
set(gca,'XTickLabel',{'Distance', 'X', 'Y', 'Z'});