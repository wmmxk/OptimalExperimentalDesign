import numpy as np

def f1(f, phi,d=0.1,k=5):
    '''
    f: frequency
    phi: angle

    '''
    speed_of_sound = 330
    summed = 1
    for n in np.arange(1, (k-1)/2 + 1, 1):
        summed += 2 * np.cos(2 * np.pi * f / speed_of_sound * n * d * np.cos(phi))
    out = np.abs(summed / np.max(summed))
    return out

def f2(X,Y):
    Z = X*0
    for i in range(len(X)):
        for j in range(len(Y)):
            z = complex(X[i,j],Y[i,j])
            Z[i,j] = np.sin(z).imag
    return Z

def f3(X,Y):
    Z = X*0
    for i in range(len(X)):
        for j in range(len(Y)):
            z = complex(X[i,j],Y[i,j])
            Z[i,j] = np.abs(1.0/(z**7-2)**1)
    return Z
            

def f4(X,Y):
    Z = X*0
    for i in range(len(X)):
        for j in range(len(Y)):
            Z[i,j] = np.random.normal(0,1,1)
    return Z

