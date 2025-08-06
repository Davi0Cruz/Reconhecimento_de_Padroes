
latex: tables
	pdflatex main.tex

test: pre test1 test2 test3 test4 plots latex

pre:
	rm -f results/posto.txt


test1:
	rm -f results/metadata.txt
	cd code; make higher; make run
	mv results/table.txt results/table_sem_pca.txt
	mv results/metadata.txt results/metadata_sem_pca.txt
	mv results/tx_ok.mat results/tx_ok_sem_pca.mat

test2:
	rm -f results/metadata.txt
	cd code; make pca; make run
	mv results/table.txt results/table_pca_sem_red.txt
	mv results/metadata.txt results/metadata_pca_sem_red.txt
	mv results/tx_ok.mat results/tx_ok_pca_sem_red.mat

test3:
	rm -f results/metadata.txt
	cd code; make pca_lower; make run
	mv results/table.txt results/table_pca_red.txt
	mv results/metadata.txt results/metadata_pca_red.txt
	mv results/tx_ok.mat results/tx_ok_pca_red.mat

test4:
	rm -f results/metadata.txt
	cd code; make pca_box; make run
	mv results/table.txt results/table_pca_box.txt
	mv results/metadata.txt results/metadata_pca_box.txt
	mv results/tx_ok.mat results/tx_ok_pca_box.mat

plots:
	cd code; for pos in sem_pca pca_sem_red pca_red pca_box; do \
		octave --silent plots.m $$pos; \
		pdfcrop ../figs/boxplot_$$pos.pdf ../figs/boxplot_$$pos.pdf; \
	done
	cd figs; for im in pca_variance.pdf pca_variance_box.pdf; do \
		pdfcrop $$im $$im; \
	done

tables:
	cd results; python maketable.py
