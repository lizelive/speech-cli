import pandas as pd
import numpy as np
d = np.stack(pd.read_parquet('0000.parquet')['xvector'])
mean = d.mean(axis=0)

x1 = d - mean

(U, S, Vh) = np.linalg.svd(x1, full_matrices=False)

x2 = np.dot(U, np.dot(np.diag(S), Vh))

# x2 /= np.linalg.norm(x2, axis=1)

dist = (x1 * x2).sum(axis = 1)

