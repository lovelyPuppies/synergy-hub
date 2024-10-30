#include <QDebug>
#include <QOpenGLContext>
#include <QOpenGLFunctions>

int main() {
  QOpenGLContext context;
  context.create();

  if (context.isValid()) {
    qDebug() << "OpenGL is enabled.";
    qDebug() << "Version:"
             << reinterpret_cast<const char *>(
                    context.functions()->glGetString(GL_VERSION));
  } else {
    qDebug() << "OpenGL is not enabled.";
  }

  return 0;
}
