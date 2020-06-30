#include <GL/glut.h>
#include <math.h>

float angle = 0.0;
int pp = 2;

double func(double x)
{
    return(0.5 * cos(x * x)+ 0.5 * sin(x * x));
}

void display(void)
{
    double x;

    glClear(GL_COLOR_BUFFER_BIT);

    switch (pp) {
      case 2: glRotated(angle, 0.0, 0.0, 1.0); break;
      case 1: glRotated(angle, 0.0, 1.0, 0.0); break;
      case 0: glRotated(angle, 1.0, 0.0, 0.0); break;
      default: break;
    }

    glColor3d(0.0, 0.0, 0.0);
    glBegin(GL_LINE_STRIP);
    for (x = - 3.14159 * 2; x < 3.14159 * 2; x += 0.05) {
        glVertex2d(x / 3.14159 * 0.5, func(x));
    }
    glEnd();

    glFlush();
}

void keyboard(unsigned char key, int x, int y)
{
    switch (key) {
        case 'q':
        case 'Q': exit(0); break;
        case 'r': angle =  10.0; display(); break;
        case 'R': angle = -10.0; display(); break;
        case 'z': pp = 2; break;
        case 'y': pp = 1; break;
        case 'x': pp = 0; break;
    }
}

int main(int argc, char *argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_RGBA);
  glutCreateWindow(argv[0]);
  glutDisplayFunc(display);
  glutKeyboardFunc(keyboard);
  glClearColor(1.0, 1.0, 1.0, 0.0);

  glutMainLoop();

  return(0);
}
