from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

def visualize(X,Y,Z,file_path):

   fig = plt.figure()
   ax = fig.gca(projection = '3d')
   rainbow = plt.get_cmap('rainbow')



   surf = ax.plot_surface(X, Y, Z, rstride = 1, cstride = 1, cmap = rainbow, linewidth = 0)
   ax.set_zlim3d(0, Z.max())

   fig.savefig(file_path,bbox_inches = 'tight')
