import numpy as np

import random
import matplotlib.mlab as mlab

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

def f5(X,Y,random_seed=2017,sigma=0.5):
    '''
    superposition multiple Gaussian distributions
    '''
    random.seed(random_seed)
    for i in range(300):
        mu1,mu2 = np.array([random.uniform(-10,10) for i in range(2)])
        sigma1 = random.uniform(sigma,3)
        sigma2 = random.uniform(sigma*0.8,4)
        sigma12 = random.uniform(min(sigma1,sigma2)/20,min(sigma1,sigma2)/2)
        if i ==0:
            Z = mlab.bivariate_normal(X,Y,sigma1, sigma2,mu1,mu2,sigma12)
        else:
            Z = Z + mlab.bivariate_normal(X,Y,sigma1, sigma2,mu1,mu2,sigma12)
    return Z