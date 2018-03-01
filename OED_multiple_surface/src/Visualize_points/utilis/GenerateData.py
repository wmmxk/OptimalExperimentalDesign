import numpy as np
class GenerateData(object):
    def __init__(self,f,boundaries):
        self.f = f
        self.xbs = boundaries[0]
        self.ybs = boundaries[1]
    def create(self):
        xs = np.linspace(self.xbs[0], self.xbs[1],70)
        ys = np.linspace(self.ybs[0], self.ybs[1],70)
        x, y = np.meshgrid(xs,ys)
        z = self.f(x,y)
        z -= np.min(z)
        z /= np.max(z)

        data = np.stack((x,y,z),axis=0)
        d3 = data.reshape((3,-1))
        d3 = d3.transpose((1,0))
        np.random.shuffle(d3)
        return d3
