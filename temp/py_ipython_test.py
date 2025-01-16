# %%

from IPython.core.interactiveshell import InteractiveShell

InteractiveShell.ast_node_interactivity = "all"


def foo():
    print("Hello")

    def bar():
        print("Bar")
