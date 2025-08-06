args = argv();
load(sprintf('../results/tx_ok_%s.mat', args{1}));

pkg load statistics;

TX = [];
for i = 1:length(TX_OK),
    TX = [TX TX_OK{i}'];
end
names = {"Quadrático", "Variante 1", "Variante 2", "Variante 3", "Variante 4", "MaxCorr", "DMC", "1-KK"};
figure(1, 'position', [0, 0, 900, 600]);
boxplot(TX);
set(gca(), "xticklabel", names, "xtick", 1:length(names));
title('Boxplot das taxas de acerto dos classificadores');
xlabel('Classificador');
ylabel('Taxas de acerto');
filename = sprintf('../figs/boxplot_%s.pdf', args{1});
print(filename, '-dpdf');
close all;
