tests = {"sem_pca", "pca_sem_red", "pca_red", "pca_box"};
for i = 1:length(tests)
    name = sprintf('../results/tx_ok_%s.mat', tests{i});
    load(name);
    models = {"Quadrático", "Variante 1", "Variante 2", "Variante 3", "Variante 4", "MaxCorr", "DMC", "1-KK"};
    disp(sprintf('Teste %d - %s', i, tests{i}));
    for j = 1:length(TX_OK)
        TX = TX_OK{j}';
        line = sprintf('%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f', models{j}, mean(TX), min(TX), max(TX), median(TX), std(TX));
        disp(line);
    end
    disp('');
end