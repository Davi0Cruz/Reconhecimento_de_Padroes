IS=20

run:
	octave --silent compara_todos.m

lower:
	octave face_preprocessing_column.m 10 3 0

higher:
	octave face_preprocessing_column.m $(IS) 15 0

pca:
	octave face_preprocessing_column.m $(IS) 15 1

pca_lower:
	octave face_preprocessing_column.m $(IS) 15 2

pca_box:
	octave face_preprocessing_column.m $(IS) 15 3

tom:
	octave tom_preprocessing.m
	octave tom_compara.m
