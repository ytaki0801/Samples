import numpy as np
import scipy.integrate as it
import matplotlib.pyplot as pp
import matplotlib.animation as an

def f(fs, t):
  theta = fs[0]
  omega = fs[1]
  dfs = [omega, -9.8 * np.sin(theta)]
  return dfs

t = np.arange(0.0, 2.1, 0.01)
xy = it.odeint(f, [np.pi/4, 1.0], t)

fig = pp.figure()
axis = fig.add_subplot(111, aspect='equal', xlim=(-1.0, 1.0), ylim=(-1.0, 1.0))

line, = axis.plot([], [], 'o-', animated=True)
x =   np.sin(xy[:, 0])
y = - np.cos(xy[:, 0])
def fanim(a):
  xn = [0, x[a]]
  yn = [0, y[a]]
  line.set_data(xn, yn)
  return line,

tl = np.arange(0, len(t))
mv = an.FuncAnimation(fig, fanim, frames=tl, blit=True, interval=10)

pp.grid()
pp.show()

